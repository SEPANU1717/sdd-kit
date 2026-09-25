[CmdletBinding()]
param([string]$Path = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$validator = Join-Path $PSScriptRoot 'validate-artifacts.ps1'
& $validator -Path $Path -IncludeTemplates
if ($LASTEXITCODE -ne 0) { throw 'Artifact validation failed' }
Write-Output 'PASS: artifact frontmatter and schemas validate'
