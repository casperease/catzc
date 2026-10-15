<#
.SYNOPSIS
    Writes every failure of a finished test run to the console: each failed test with its message, and each test
    file that failed before any of its tests ran.
.DESCRIPTION
    The one place a test run's failures reach the console, shared by Invoke-TestFile and Test-Automation, at every...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestRunFailures.ps1.md#comment1)
.PARAMETER Rows
    The run's test rows (ConvertTo-TestAutomationRowSet's shape: Result, ExpandedPath, ErrorMessage).
.PARAMETER Files
    The run's per-file entries from the files sidecars (New-TestAutomationShardScript: File, Result, ErrorMessage).
.EXAMPLE
    Write-TestRunFailures -Rows $rows -Files $files
#>
function Write-TestRunFailures {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [AllowEmptyCollection()]
        [object[]] $Files = @()
    )

    $failedRows = @($Rows | Where-Object { $_.Result -eq 'Failed' })
    $failedFiles = @($Files | Where-Object { $_.Result -eq 'Failed' -and -not [string]::IsNullOrWhiteSpace($_.ErrorMessage) })
    if ($failedRows.Count -eq 0 -and $failedFiles.Count -eq 0) {
        return
    }

    Write-Message '' -NoHeader
    Write-Header "Failures ($($failedRows.Count + $failedFiles.Count))" -ForegroundColor Red
    foreach ($row in $failedRows) {
        Write-Message "FAIL $($row.ExpandedPath)" -NoHeader -ForegroundColor Red
        foreach ($line in ("$($row.ErrorMessage)".TrimEnd() -split '\r?\n')) {
            Write-Message "     $line" -NoHeader
        }
    }
    foreach ($file in $failedFiles) {
        Write-Message "FAIL $($file.File) (failed before its tests ran)" -NoHeader -ForegroundColor Red
        foreach ($line in ("$($file.ErrorMessage)".TrimEnd() -split '\r?\n')) {
            Write-Message "     $line" -NoHeader
        }
    }
    Write-Footer -ForegroundColor Red
}
