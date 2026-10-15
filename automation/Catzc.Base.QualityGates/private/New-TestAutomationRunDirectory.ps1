<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/New-TestAutomationRunDirectory.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Creates and returns a fresh timestamped run directory under the report base.
    description: |-
      Each Test-Automation run writes its artifacts into <OutputFolder>/yyyyMMdd-HHmmss/, suffixed -2, -3, … when
      a same-second directory already exists, so rapid or concurrent runs never collide. The directory is created
      before it is returned.
    parameters:
      OutputFolder: The report base directory the timestamped run directory is created under.
    outputs: '[string] the created run directory''s absolute path.'
---
#>

function New-TestAutomationRunDirectory {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDirectory = Join-Path $OutputFolder $stamp
    $suffix = 2
    while (Test-Path $runDirectory) {
        $runDirectory = Join-Path $OutputFolder "$stamp-$suffix"
        $suffix++
    }
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
    $runDirectory
}
