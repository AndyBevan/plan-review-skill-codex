$ErrorActionPreference = "Stop"

$repoRoot = Split-Path $PSScriptRoot -Parent
$sourceDir = Join-Path $repoRoot "plan-review"
$targetDir = Join-Path $repoRoot ".codex\skills\plan-review"

if (-not (Test-Path $sourceDir)) {
  throw "Skill source directory not found: $sourceDir"
}

New-Item -ItemType Directory -Force $targetDir | Out-Null
Copy-Item (Join-Path $sourceDir "*") $targetDir -Recurse -Force

Write-Host "Installed plan-review into project-local Codex folder at $targetDir"
