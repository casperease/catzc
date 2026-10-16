<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-TestTimingViolation.ps1
    folder: private
    name: get-test-timing-violation
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Lists every passed test that exceeded its level's time limit, as report lines.
    description: |-
      Validates the aggregated per-test rows against the per-level duration limits (`tests.level_ms` in
      timeouts.yml, Get-TestTimeLimits; by default L0 < 400ms, L1 < 2s, L2 < 30s, L3 < 120s). Only passed tests are
      checked — a failed test's duration is noise — and a row with no resolved tier is skipped (the tag check already
      reported it). Test-Automation reports the lines and fails the run only under -EnforceTimings.
    parameters:
      Rows: The run's aggregated per-test rows.
      Limits: The per-level duration limits (level tag -> milliseconds).
---
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
