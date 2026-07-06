<#
.SYNOPSIS
    Lists every passed test that exceeded its level's time limit, as report lines.
.DESCRIPTION
    Validates the aggregated per-test rows against the per-level duration limits (L0 < 400ms, L1 < 2s,
    L2 < 120s, L3 < 30s). Only passed tests are checked — a failed test's duration is noise — and a row with
    no resolved tier is skipped (the tag gate already reported it). Test-Automation reports the lines and
    fails the run only under -EnforceTimings.
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
