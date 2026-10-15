<#
.SYNOPSIS
    Lists every passed test that exceeded its level's time limit, as report lines.
.DESCRIPTION
    Validates the aggregated per-test rows against the per-level duration limits (`tests.level_ms` in timeouts.yml,...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestTimingViolation.ps1.md#comment1)
.PARAMETER Rows
    The run's aggregated per-test rows.
.PARAMETER Limits
    The per-level duration limits (level tag -> milliseconds).
#>
function Get-TestTimingViolation {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [Parameter(Mandatory)]
        [hashtable] $Limits
    )

    foreach ($row in $Rows) {
        if ($row.Result -ne 'Passed') {
            continue
        }
        if (-not $row.Level) {
            continue
        }   # untagged/ambiguous tier — already reported by the tag check
        $limitMs = $Limits[$row.Level]

        if ($row.DurationMs -gt $limitMs) {
            "[$($row.Level) > ${limitMs}ms] $($row.ExpandedName) took $($row.DurationMs)ms"
        }
    }
}
