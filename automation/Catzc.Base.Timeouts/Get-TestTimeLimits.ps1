<#
.SYNOPSIS
    Returns the test-run time limits: the most one test of each tier may take, and the budget for a whole run.
.DESCRIPTION
    One source for the timing report and the run-budget check, so Test-Automation keeps no literal limit of its own.
    [ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)
    [comment:1](/docs/references/automation/catzc-base-timeouts/Get-TestTimeLimits.ps1.md#comment1)
.OUTPUTS
    [pscustomobject] with LevelMs ([hashtable]) and RunSeconds ([int]).
.EXAMPLE
    (Get-TestTimeLimits).LevelMs['L2']   # the most milliseconds one L2 test may take
.EXAMPLE
    (Get-TestTimeLimits).RunSeconds      # the budget for a whole run
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
