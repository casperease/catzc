<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#30
  config:
    synopsis: Writes the opening banner for a Test-Automation run — the framed header that brackets the run's output.
    description: |-
      Renders a single Write-Header (a self-contained curved box) naming the run's scope: its tier range, plus
      the category and the module list when either is narrowed from the defaults. Test-Automation calls this
      before it sets the writers' suppression flag, so the banner renders and everything the run then emits —
      Pester's own lines, and the timing / report / skip sections below — sits under it.
    parameters:
      MinLevel: The run's minimum tier (0-3), as Test-Automation resolved it.
      MaxLevel: The run's maximum tier (0-3).
      Category: The run's category filter (Logic / Integrity / Both); named in the scope only when it is not Both.
      Modules: The modules the run was scoped to; named in the scope only when non-empty.
      Title: |-
        The run's name on the banner: "Test Automation" (the source run, the default) or the build run's
        "Catzc Build Run" ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)).
---
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
