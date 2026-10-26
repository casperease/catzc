<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/ConvertTo-TestAutomationRowSet.ps1.md"
  header: "generated"
---
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
            $records = @($test.ErrorRecord)
            # A test a failed setup never ran takes its cause from the nearest block above that has one.
            $block = $test.PSObject.Properties['Block'] ? $test.Block : $null
            while (-not $records.Count -and $block) {
                $records = @($block.PSObject.Properties['ErrorRecord'] ? $block.ErrorRecord : @())
                $block = $block.PSObject.Properties['Parent'] ? $block.Parent : $null
            }
            $errorMessage = (@($records) | ForEach-Object {
                    $inner = $_.Exception.PSObject.Properties['InnerException'] ? $_.Exception.InnerException : $null
                    $inner ? "$($_.Exception.Message)`n  inner: $($inner.Message)" : $_.Exception.Message
                }) -join "`n"
            $errorStack = (@($records) | ForEach-Object { $_.ScriptStackTrace }) -join "`n"
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
