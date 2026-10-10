# Builds release zips from the committed HEAD (uncommitted changes are not included).
# 1. dist/sdd-kit-<version>.zip: the whole kit, ready to unzip into a project root.
# 2. dist/skills/<skill>-<version>.zip: one zip per skill with SKILL.md and LICENSE at
#    the root, for marketplaces that take single skills. The sdd-* skills read the
#    kit's .agents/rules, templates and schemas, so they need the full kit installed.
# Usage: pwsh scripts/package-kit.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
  if (-not (Test-Path LICENSE)) { throw 'LICENSE is missing' }
  git ls-files --error-unmatch LICENSE *> $null
  if ($LASTEXITCODE -ne 0) { throw 'commit LICENSE first' }
  if (git status --porcelain) { Write-Warning 'uncommitted changes are not packaged' }
  $version = git describe --tags --always
  if (Test-Path dist) { Remove-Item -Recurse -Force dist }
  New-Item -ItemType Directory -Force dist/skills | Out-Null

  git archive --format=zip --prefix=sdd-kit/ -o "dist/sdd-kit-$version.zip" HEAD `
    AGENTS.md CLAUDE.md LICENSE README.md .agents .claude scripts
  if ($LASTEXITCODE -ne 0) { throw 'git archive failed for the kit' }
  "built dist/sdd-kit-$version.zip"

  foreach ($dir in Get-ChildItem .agents/skills -Directory) {
    if (-not (Test-Path (Join-Path $dir.FullName 'SKILL.md'))) { continue }
    $name = $dir.Name
    git archive --format=zip --add-file=LICENSE -o "dist/skills/$name-$version.zip" "HEAD:.agents/skills/$name"
    if ($LASTEXITCODE -ne 0) { throw "git archive failed for $name" }
    "built dist/skills/$name-$version.zip"
  }
}
finally { Pop-Location }
