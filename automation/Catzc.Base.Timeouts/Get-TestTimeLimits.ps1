<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
    name: get-test-time-limits
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Timeouts/tests/Get-TestTimeLimits.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST#7
---
#>

function Get-TestTimeLimits {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $config = Get-Config -Config timeouts
    [pscustomobject]@{
        LevelMs    = $config.TestLevelLimitsMs()
        RunSeconds = $config.TestRunSeconds()
    }
}
