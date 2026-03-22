$demoPath = (Resolve-Path (Join-Path $PSScriptRoot "demo\index.html")).Path.Replace('\', '/')
$baseUrl = "file:///$demoPath"
$outDir = Join-Path $PSScriptRoot "screenshots"

New-Item -ItemType Directory -Force $outDir | Out-Null

$shots = @(
  @{ Hash = "#mockups/dashboard"; File = "mockups-dashboard.png" },
  @{ Hash = "#mockups/kanban"; File = "mockups-kanban.png" },
  @{ Hash = "#mockups/task-detail"; File = "mockups-task-detail.png" },
  @{ Hash = "#mockups/settings"; File = "mockups-settings.png" },
  @{ Hash = "#mockups/analytics"; File = "mockups-analytics.png" },
  @{ Hash = "#data-models"; File = "data-models.png" },
  @{ Hash = "#data-models/entities"; File = "data-models-entities.png" },
  @{ Hash = "#architecture"; File = "architecture.png" },
  @{ Hash = "#concerns"; File = "concerns.png" }
)

foreach ($shot in $shots) {
  $url = "$baseUrl$($shot.Hash)"
  $file = Join-Path $outDir $shot.File
  npx playwright screenshot --browser chromium --viewport-size "1600,1200" --wait-for-timeout 600 $url $file
}
