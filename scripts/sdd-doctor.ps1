[CmdletBinding()]
param(
  [string]$Path = (Get-Location).Path,
  [string]$Feature,
  [switch]$AllowProjectTemplate,
  [switch]$Strict
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Path).Path
$failures = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Fail([string]$Message) { [void]$failures.Add($Message) }
function Warn([string]$Message) { [void]$warnings.Add($Message) }
function RequireFile([string]$Relative) {
  if (-not (Test-Path -LiteralPath (Join-Path $root $Relative) -PathType Leaf)) { Fail "missing file: $Relative" }
}
function ReadText([string]$Relative) {
  $file = Join-Path $root $Relative
  if (-not (Test-Path -LiteralPath $file)) { return '' }
  return Get-Content -LiteralPath $file -Raw
}
function CheckId([string]$Value, [string]$Label) {
  if ($Value -and $Value -notmatch '^[A-Z]{1,4}[0-9]+$') { Fail "invalid $Label '$Value'" }
}

foreach ($file in @('AGENTS.md','README.md','.agents/rules/project.md','.agents/rules/sdd-workflow.md','.agents/rules/writing-specs.md','.agents/skills/INDEX.md')) { RequireFile $file }

$project = ReadText '.agents/rules/project.md'
if (-not $AllowProjectTemplate) {
  foreach ($placeholder in @('<project name>','<one or two sentences>','<prototype | beta | production>','<e.g.','<folder>','<!--')) {
    if ($project.Contains($placeholder)) { Fail "project.md still contains template placeholder: $placeholder" }
  }
}

if (-not $AllowProjectTemplate) {
  $commandLines = [regex]::Matches($project, '(?m)^\|\s*(Types|Lint|Tests|Build|Local DB migrate)\s*\|\s*([^|]+)\|')
  foreach ($line in $commandLines) {
    $commandText = $line.Groups[2].Value.Trim().Trim('`')
    if ($commandText -and $commandText -notmatch '^<') {
      $commandName = ($commandText -split '\s+')[0]
      if (-not (Get-Command $commandName -ErrorAction SilentlyContinue)) { Warn "configured command unavailable: $commandName ($($line.Groups[1].Value))" }
    }
  }
}

$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) { Warn 'git executable unavailable; baseline and diff checks are unverified' }
elseif (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) { Warn 'no .git directory; baseline and diff checks are unavailable' }
else {
  try { & git -C $root rev-parse --verify HEAD *> $null; if ($LASTEXITCODE -ne 0) { Warn 'Git repository has no commit baseline' } }
  catch { Warn 'Git baseline check failed; review evidence is unverified' }
}

$featureRoot = Join-Path $root '.agents/features'
$featureDirs = @(Get-ChildItem -LiteralPath $featureRoot -Directory -ErrorAction SilentlyContinue | Where-Object Name -ne '.gitkeep')
if ($Feature) { $featureDirs = @($featureDirs | Where-Object Name -eq $Feature); if ($featureDirs.Count -eq 0) { Fail "feature not found: $Feature" } }

$validStatuses = @('specifying','spec-approved','planned','plan-approved','in-progress','ready-for-review','changes-requested','approved','done','blocked','stale','cancelled')
foreach ($dir in $featureDirs) {
  $specPath = Join-Path $dir.FullName 'spec.md'
  if (-not (Test-Path -LiteralPath $specPath)) { Fail "feature $($dir.Name): missing spec.md"; continue }
  $spec = Get-Content -LiteralPath $specPath -Raw
  if ($dir.Name -notmatch '^\d{8}-[a-z0-9]+(?:-[a-z0-9]+)*$') { Fail "feature $($dir.Name): invalid feature id" }
  $status = [regex]::Match($spec, '(?m)^- Status:\s*([^\r\n]+)').Groups[1].Value.Trim()
  if ($status -and $status -notin @('specifying','spec-approved')) { Fail "feature $($dir.Name): invalid spec status '$status'" }
  $revision = [regex]::Match($spec, '(?m)^- Revision:\s*(\d+)').Groups[1].Value
  if (-not $revision) { Warn "feature $($dir.Name): legacy spec has no Revision field" }
  $criteria = [regex]::Matches($spec, '(?m)^- AC(\d+):') | ForEach-Object { "AC$($_.Groups[1].Value)" }
  $decisions = [regex]::Matches($spec, '(?m)^\| D(\d+)\s*\|') | ForEach-Object { "D$($_.Groups[1].Value)" }
  $planAcCounts = @{}
  if ($criteria.Count -eq 0 -and $status -eq 'spec-approved') { Fail "feature $($dir.Name): approved spec has no acceptance criteria" }
  foreach ($plan in @(Get-ChildItem -LiteralPath $dir.FullName -Filter 'plan-*.md' -File)) {
    $body = Get-Content -LiteralPath $plan.FullName -Raw
    $planStatus = [regex]::Match($body, '(?m)^- Status:\s*([^\r\n]+)').Groups[1].Value.Trim()
    if ($planStatus -and $planStatus -notin @('planned','plan-approved','stale')) { Fail "$($plan.Name): invalid plan status '$planStatus'" }
    $planRef = [regex]::Match($body, '(?m)^- Feature:\s*`([^`]+)`').Groups[1].Value
    if ($planRef -and -not (Test-Path -LiteralPath (Join-Path $root $planRef))) { Fail "$($plan.Name): referenced spec missing: $planRef" }
    if ($revision -and $body -match '(?m)^- Spec revision:\s*(\d+)' -and [int]$Matches[1] -lt [int]$revision -and $planStatus -ne 'stale') { Fail "$($plan.Name): older spec revision must be marked stale" }
    $specLine = [regex]::Match($body, '(?m)^- Spec:\s*([^\r\n]+)').Groups[1].Value
    foreach ($match in [regex]::Matches($specLine, '\bAC\d+\b')) {
      if (-not $planAcCounts.ContainsKey($match.Value)) { $planAcCounts[$match.Value] = 0 }
      $planAcCounts[$match.Value]++
    }
    foreach ($ac in $criteria) { if ($body -match "\b${ac}\b" -and $body -notmatch "(?m)^\|.*\b${ac}\b.*\|") { Warn "$($plan.Name): $ac is referenced but lacks a task-level mapping" } }
  }
  foreach ($ac in $criteria) {
    $count = if ($planAcCounts.ContainsKey($ac)) { $planAcCounts[$ac] } else { 0 }
    if ($count -ne 1) { Fail "feature $($dir.Name): $ac is covered by $count plans; expected exactly one" }
  }
}

$sourceSkills = Join-Path $root '.agents/skills'
$mirrorSkills = Join-Path $root '.claude/skills'
if (Test-Path $sourceSkills -PathType Container) {
  foreach ($skill in @(Get-ChildItem $sourceSkills -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })) {
    $mirror = Join-Path (Join-Path $mirrorSkills $skill.Name) 'SKILL.md'
    if (-not (Test-Path $mirror)) { Fail "skill mirror missing: .claude/skills/$($skill.Name)" }
    elseif ((Get-FileHash (Join-Path $skill.FullName 'SKILL.md')).Hash -ne (Get-FileHash $mirror).Hash) { Fail "skill mirror drift: $($skill.Name)" }
  }
}

Write-Output "SDD doctor: $root"
foreach ($warning in $warnings) { Write-Output "WARN: $warning" }
foreach ($failure in $failures) { Write-Output "FAIL: $failure" }
Write-Output ("Result: {0} failure(s), {1} warning(s)" -f $failures.Count, $warnings.Count)
if ($Strict -and $warnings.Count -gt 0) { exit 2 }
if ($failures.Count -gt 0) { exit 1 }
exit 0
