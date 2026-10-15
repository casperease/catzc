<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestTimingViolation.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists every passed test that exceeded its level's time limit, as report lines.
.DESCRIPTION
    Failed tests and rows with no tier are skipped: a failed duration is noise, the tag check reports the tier.
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
