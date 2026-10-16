<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Timeouts/tests/Get-TestTimeLimits.Tests.ps1
    adrs:
      - ADR-AUTO-FAILFAST#7
  config:
    synopsis: 'Returns the test-run time limits: the most one test of each tier may take, and the budget for a whole run.'
    description: |-
      Reads the `tests` section of timeouts.yml (TimeoutsConfig), defaults filled in, so Test-Automation's timing report
      and its run-budget check read one source instead of a literal of their own
      ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). LevelMs is keyed by
      tier tag ([Catzc.Base.Timeouts.TestTiers]::Names, L0 to L4) in milliseconds; RunSeconds is the budget for a whole
      Test-Automation run up to L3 (an L4 run is a stage of its own).
    outputs: '[pscustomobject] with LevelMs ([hashtable]) and RunSeconds ([int]).'
    examples:
      - '(Get-TestTimeLimits).LevelMs[''L2'']   # the most milliseconds one L2 test may take'
      - '(Get-TestTimeLimits).RunSeconds      # the budget for a whole run'
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
