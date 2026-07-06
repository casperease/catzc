<#
.SYNOPSIS
    Reduces a live Pester run object to plain per-test rows that survive a process boundary.
.DESCRIPTION
    Tier/category resolution walks a test's live .Block chain (Get-TestLevelTag / Get-TestCategoryTag), which
    does not survive serialization — so a parallel worker reduces its own result to these rows before exiting,
    and the parent aggregates the rows (JSON sidecars) from every shard. The row set is the one shape the run
    reports consume: tests.csv/summary.md (Write-TestAutomationReport), the over-limit timing check, and the
    skip report (Write-TestAutomationSkipReport) all read rows, never a Pester object across a boundary.
    Emits one row per discovered test, in Pester's order, including Skipped and NotRun tests.
.PARAMETER Result
    The live Pester run object (Invoke-Pester -Configuration <with Run.PassThru>), in the process that ran it.
.OUTPUTS
    [pscustomobject] rows: ExpandedPath, ExpandedName, Result, DurationMs, Level, Category, Rules, File, Line,
    ErrorMessage, ErrorStack, SkipReason. Rules is the ';'-joined ADR provenance citations (Get-TestRuleTags),
    '' when the test carries none — resolved in-worker like Level/Category because the .Block chain does not
    survive the process boundary.
#>
function ConvertTo-TestAutomationRowSet {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Result
    )

    foreach ($test in @($Result.Tests)) {
        # Failure detail feeds summary.md's failures section; captured only where it exists.
        $errorMessage = ''
        $errorStack = ''
        if ($test.Result -eq 'Failed') {
            $errorMessage = (@($test.ErrorRecord) | ForEach-Object { $_.Exception.Message }) -join "`n"
            $errorStack = (@($test.ErrorRecord) | ForEach-Object { $_.ScriptStackTrace }) -join "`n"
        }

        # The -Because reason feeds the skip report; resolved here because it reads the live ErrorRecord.
        $skipReason = ''
        if ($test.Result -eq 'Skipped') {
            $skipReason = Get-TestSkipReason -Test $test
        }

        $file = ''
        $line = 0
        if ($test.ScriptBlock) {
            $file = "$($test.ScriptBlock.File)"
            $line = [int]$test.ScriptBlock.StartPosition.StartLine
        }

        [pscustomobject]@{
            ExpandedPath = $test.ExpandedPath
            ExpandedName = $test.ExpandedName
            Result       = "$($test.Result)"
            DurationMs   = [int]$test.Duration.TotalMilliseconds
            Level        = "$(Get-TestLevelTag -Test $test)"
            Category     = "$(Get-TestCategoryTag -Test $test)"
            Rules        = (Get-TestRuleTags -Test $test) -join ';'
            File         = $file
            Line         = $line
            ErrorMessage = $errorMessage
            ErrorStack   = $errorStack
            SkipReason   = $skipReason
        }
    }
}
