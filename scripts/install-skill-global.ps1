$ErrorActionPreference = "Stop"

$repoRoot = Split-Path $PSScriptRoot -Parent
$sourceDir = Join-Path $repoRoot "plan-review"
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$targetDir = Join-Path $codexHome "skills\plan-review"

if (-not (Test-Path $sourceDir)) {
  throw "Skill source directory not found: $sourceDir"
}

New-Item -ItemType Directory -Force $targetDir | Out-Null
Copy-Item (Join-Path $sourceDir "*") $targetDir -Recurse -Force

Write-Host "Installed plan-review globally to $targetDir"
