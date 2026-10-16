<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
  config:
    synopsis: |-
      Writes every failure of a finished test run to the console: each failed test with its message, and each test
      file that failed before any of its tests ran.
    description: |-
      The one place a test run's failures reach the console, shared by Invoke-TestFile and Test-Automation, at every
      -Output level: a failure is the one thing a quiet run must still show, and the worker's Pester output does not
      carry it to a redirected console. Renders a framed section (Write-Header / Write-Footer, red) with one
      'FAIL <ExpandedPath>' line per failed row followed by its whole ErrorMessage, then one
      'FAIL <file> (failed before its tests ran)' line per file the files sidecar marks Failed with an error of its own
      — a file that throws while Pester discovers it, or in its BeforeAll, yields no row, so its error is only there.
      Writes nothing when there is no failure.
    parameters:
      Rows: 'The run''s test rows (ConvertTo-TestAutomationRowSet''s shape: Result, ExpandedPath, ErrorMessage).'
      Files: 'The run''s per-file entries from the files sidecars (New-TestAutomationShardScript: File, Result, ErrorMessage).'
    examples:
      - Write-TestRunFailures -Rows $rows -Files $files
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
