[CmdletBinding()]
param([string]$Path = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$doctor = Join-Path $PSScriptRoot 'sdd-doctor.ps1'
$output = & $doctor -Path $Path 2>&1
if ($LASTEXITCODE -eq 0) { throw 'Expected the starter kit to fail while project.md contains placeholders' }
if (($output -join "`n") -notmatch 'project\.md') { throw 'Doctor did not identify project.md placeholders' }
& $doctor -Path $Path -AllowProjectTemplate 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Expected the starter kit to pass structural validation with its template configuration allowed' }
Write-Output 'PASS: doctor rejects the unconfigured starter kit honestly'
