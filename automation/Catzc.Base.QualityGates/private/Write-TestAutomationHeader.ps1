<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#30
---
#>

<#
.SYNOPSIS
    Writes the opening banner for a Test-Automation run — the framed header that brackets the run's output.
.DESCRIPTION
    Called before the writers' suppression flag is set, so the banner shows and the run's later output sits under it.
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
    The build run passes its own name here, so its banner is told apart from the source run's default.
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
