<#
.SYNOPSIS
    Creates and returns a fresh timestamped run directory under the report base.
.DESCRIPTION
    A same-second run gets a -2, -3 suffix, so rapid or concurrent runs never share or overwrite a directory.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationRunDirectory.ps1.md#comment1)
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
