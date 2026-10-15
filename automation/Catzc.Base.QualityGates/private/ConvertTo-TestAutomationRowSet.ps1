<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/ConvertTo-TestAutomationRowSet.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Reduces a live Pester run object to plain per-test rows that survive a process boundary.
.DESCRIPTION
    The live Block chain does not survive serialization, so each worker resolves tier and category into rows itself.
.PARAMETER Result
    The live Pester run object (Invoke-Pester -Configuration <with Run.PassThru>), in the process that ran it.
.OUTPUTS
    [pscustomobject] rows: ExpandedPath, ExpandedName, Result, DurationMs, Level, Category, Rules, File, Line,
    ErrorMessage, ErrorStack, SkipReason. Rules is the ';'-joined ADR provenance citations (Get-TestRuleTags),
    '' when the test carries none — resolved in-worker like Level/Category because the .Block chain does not
    survive the process boundary. File is the test's run file (Get-TestRunFile): its test file, or for a Go bridge
    test its Go test folder, with Line 0.
#>
function ConvertTo-TestAutomationRowSet {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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

        # The test's run file: its test file, or the Go test folder of a Go bridge test, which has no line of its own.
        $file = Get-TestRunFile -Test $test
        $line = 0
        if ($test.ScriptBlock -and $file -eq "$($test.ScriptBlock.File)") {
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
