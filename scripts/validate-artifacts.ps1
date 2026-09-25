[CmdletBinding()]
param(
  [string]$Path = (Get-Location).Path,
  [switch]$IncludeTemplates
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Path).Path
$schemaRoot = Join-Path $root '.agents/schemas'
$errors = [System.Collections.Generic.List[string]]::new()
function Error([string]$Message) { [void]$errors.Add($Message) }

foreach ($schemaFile in @(Get-ChildItem $schemaRoot -Filter '*.schema.json' -File -ErrorAction SilentlyContinue)) {
  try { Get-Content -LiteralPath $schemaFile.FullName -Raw | ConvertFrom-Json | Out-Null }
  catch { Error "invalid JSON schema: $($schemaFile.Name)" }
}

function ParseFrontmatter([string]$File) {
  $lines = @(Get-Content -LiteralPath $File)
  if ($lines.Count -lt 2 -or $lines[0] -ne '---') { return $null }
  $data = @{}
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -eq '---') { return $data }
    if ($lines[$i] -match '^([A-Za-z][A-Za-z0-9_-]*):\s*(.*)$') {
      $key = $Matches[1]
      $value = $Matches[2].Trim().Trim('"').Trim("'")
      if ($value -match '^\d+$') { $value = [int]$value }
      $data[$key] = $value
    } else { Error "${File}: unsupported frontmatter line $($lines[$i])" }
  }
  Error "${File}: frontmatter is not closed"; return $null
}

$files = [System.Collections.Generic.List[string]]::new()
if ($IncludeTemplates) {
  foreach ($file in @(Get-ChildItem (Join-Path $root '.agents/templates') -File | Where-Object { $_.Name -in @('spec.md','plan.md','implementation.md','review.md','checklist.md') })) { [void]$files.Add($file.FullName) }
}
$featureRoot = Join-Path $root '.agents/features'
foreach ($dir in @(Get-ChildItem $featureRoot -Directory -ErrorAction SilentlyContinue)) {
  foreach ($file in @(Get-ChildItem $dir.FullName -File | Where-Object { $_.Name -match '^(spec|plan-|impl-|review-|checklist).*\.md$' })) { [void]$files.Add($file.FullName) }
}

$allowed = @{
  spec = @('specifying','spec-approved')
  plan = @('planned','plan-approved','stale')
  implementation = @('in-progress','ready-for-review','changes-requested')
  review = @('pass','changes-requested','blocked')
  checklist = @('draft','pass','changes-requested','blocked')
}
foreach ($file in $files) {
  $meta = ParseFrontmatter $file
  if ($null -eq $meta) { Error "${file}: missing frontmatter"; continue }
  foreach ($required in @('artifact','schema','feature','revision','status')) { if (-not $meta.ContainsKey($required)) { Error "${file}: missing frontmatter field $required" } }
  if (-not $meta.ContainsKey('artifact')) { continue }
  $artifact = [string]$meta.artifact
  if (-not $allowed.ContainsKey($artifact)) { Error "${file}: unsupported artifact '$artifact'"; continue }
  $schemaFile = Join-Path $schemaRoot "$artifact.schema.json"
  if (-not (Test-Path $schemaFile)) { Error "${file}: schema missing for $artifact"; continue }
  $schema = Get-Content $schemaFile -Raw | ConvertFrom-Json
  if ([int]$meta.schema -ne 1) { Error "${file}: unsupported schema version '$($meta.schema)'" }
  if ($meta.artifact -ne $artifact) { Error "${file}: artifact mismatch" }
  if ([string]$meta.feature -notmatch '^\d{8}-[a-z0-9]+(?:-[a-z0-9]+)*$' -and [string]$meta.feature -notmatch '^<') { Error "${file}: invalid feature id" }
  if ([int]$meta.revision -lt 1) { Error "${file}: revision must be positive" }
  if ([string]$meta.status -notin $allowed[$artifact] -and [string]$meta.status -notmatch '^<') { Error "${file}: invalid status '$($meta.status)'" }
  if ($schema.properties.risk -and $meta.ContainsKey('risk') -and [string]$meta.risk -notin @('quick','standard','high-risk') -and [string]$meta.risk -notmatch '^<') { Error "${file}: invalid risk '$($meta.risk)'" }
}

foreach ($error in $errors) { Write-Output "FAIL: $error" }
Write-Output ("Artifact validation: {0} failure(s)" -f $errors.Count)
if ($errors.Count -gt 0) { exit 1 }
exit 0
