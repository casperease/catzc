<#
.SYNOPSIS
    Writes the opening banner for a Test-Automation run — the framed header that brackets the run's output.
.DESCRIPTION
    Renders a single Write-Header (a self-contained curved box) naming the run's scope: its tier range, plus the...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md#comment1)
.PARAMETER MinLevel
    The run's minimum tier (0-3), as Test-Automation resolved it.
.PARAMETER MaxLevel
    The run's maximum tier (0-3).
.PARAMETER Category
    The run's category filter (Logic / Integrity / Both); named in the scope only when it is not Both.
.PARAMETER Modules
    The modules the run was scoped to; named in the scope only when non-empty.
.PARAMETER Title
    The run's name on the banner: "Test Automation" (the source run, the default) or the build run's "Catzc Build Run".
    [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md#comment2)
#>
function Write-TestAutomationHeader {
    [CmdletBinding()]
    param(
        [int] $MinLevel = 0,

        [int] $MaxLevel = 2,

        [string] $Category = 'Both',

        [string[]] $Modules = @(),

        [string] $Title = 'Test Automation'
    )

    $scope = Format-TierRange -MinLevel $MinLevel -MaxLevel $MaxLevel
    if ($Category -ne 'Both') {
        $scope += ", $Category"
    }
    if ($Modules) {
        $scope += ", modules: $($Modules -join ', ')"
    }
    Write-Header "$Title — $scope" -ForegroundColor Cyan
}
