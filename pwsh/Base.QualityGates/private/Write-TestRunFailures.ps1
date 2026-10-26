<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestRunFailures.ps1.md"
  header: "generated"
---
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
    # Rows sharing a message share a cause: the message is written once, in first-failure order.
    $byMessage = [ordered]@{}
    foreach ($row in $failedRows) {
        $message = "$($row.ErrorMessage)".TrimEnd()
        if (-not $byMessage.Contains($message)) {
            $byMessage[$message] = [System.Collections.Generic.List[string]]::new()
        }
        $byMessage[$message].Add($row.ExpandedPath)
    }
    foreach ($message in $byMessage.Keys) {
        $paths = $byMessage[$message]
        foreach ($path in $paths) {
            Write-Message "FAIL $path" -NoHeader -ForegroundColor Red
        }
        if ($paths.Count -gt 1) {
            Write-Message "     $($paths.Count) failures share this message:" -NoHeader
        }
        foreach ($line in ($message -split '\r?\n')) {
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
