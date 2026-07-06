<#
.SYNOPSIS
    Writes a run's report artifacts and the skip report — best-effort, never masking the run outcome.
.DESCRIPTION
    Persists summary.md + tests.csv beside the per-shard results (Write-TestAutomationReport), points
    latest.txt at the run, renders the end-of-run skip report (Write-TestAutomationSkipReport), and writes the
    ADR rule-enforcement coverage (Write-TestAutomationRuleCoverage — rule-coverage.md/.csv). Each part is
    try/catch-guarded independently: a rendering error is reported as a yellow line and swallowed, so a failing
    run still throws for its own reason, not a reporting one.
.PARAMETER Rows
    The run's aggregated per-test rows.
.PARAMETER RunDirectory
    The run's timestamped artifact directory.
.PARAMETER OutputFolder
    The report base directory (latest.txt lands here).
.PARAMETER MaxLevel
    The run's maximum tier (report metadata).
.PARAMETER Limits
    The per-level duration limits (report metadata).
.PARAMETER RunResult
    The aggregate verdict ('Passed'/'Failed').
.PARAMETER DurationSeconds
    The run's wall-clock duration.
.PARAMETER EnforceTimings
    Whether timing violations fail the run (report metadata).
.PARAMETER MinLevel
    The run's minimum tier (skip-report scope).
.PARAMETER Category
    The run's category (skip-report scope).
#>
function Write-TestAutomationArtifacts {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [Parameter(Mandatory)]
        [int] $MaxLevel,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [Parameter(Mandatory)]
        [string] $RunResult,

        [Parameter(Mandatory)]
        [double] $DurationSeconds,

        [switch] $EnforceTimings,

        [Parameter(Mandatory)]
        [int] $MinLevel,

        [Parameter(Mandatory)]
        [string] $Category
    )

    # Persist the run report (summary.md + tests.csv) beside the per-shard results — written before any
    # throw, so a failing run still produces it.
    try {
        Write-TestAutomationReport -Rows $Rows -OutputFolder $RunDirectory -Level $MaxLevel -Limits $Limits `
            -RunResult $RunResult -DurationSeconds $DurationSeconds -TimingsEnforced:$EnforceTimings
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $RunDirectory -Leaf) -Encoding utf8
        Write-Message '' -NoHeader
        Write-Message "Test report: $RunDirectory" -ForegroundColor Cyan -NoHeader
    }
    catch {
        Write-Message "Could not write test report to ${RunDirectory}: $_" -ForegroundColor Yellow -NoHeader
    }

    # Final section: what was skipped (a self-skip, with its reason) or not run (excluded by this run's
    # tier/category scope).
    try {
        Write-TestAutomationSkipReport -Rows $Rows -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    # ADR rule-enforcement coverage — report-only, same best-effort discipline. Unions the tagged-test
    # enforcers (each row's Rules column) with the analyzer-rule enforcers (Get-AnalyzerAdrCoverage) over the
    # full rule universe. Plain assignment receives the comma-wrapped getter intact; ':'->'#' matches the tags.
    try {
        $ruleIds = Get-CatsAdrRuleIds
        Write-TestAutomationRuleCoverage -Rows $Rows -AnalyzerCoverage @(Get-AnalyzerAdrCoverage) `
            -AllRuleIds @($ruleIds -replace ':', '#') -OutputFolder $RunDirectory
    }
    catch {
        Write-Message "Could not render the rule-coverage report: $_" -ForegroundColor Yellow -NoHeader
    }
}
