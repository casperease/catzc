<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/New-TestAutomationRunDirectory.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Creates and returns a fresh timestamped run directory under the report base.
.DESCRIPTION
    A same-second run gets a -2, -3 suffix, so rapid or concurrent runs never share or overwrite a directory.
.PARAMETER OutputFolder
    The report base directory the timestamped run directory is created under.
.OUTPUTS
    [string] the created run directory's absolute path.
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
