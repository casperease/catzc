<#
.SYNOPSIS
    Prints and records the tests a test run's opt-out tag excluded — the visible half of
    [ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31).
.DESCRIPTION
    The build run never drops a test silently: every test it leaves out by its opt-out tag ('source-only') is
    counted and listed on the console, grouped by file (repository-relative), and written to
    excluded-tests.csv in the run directory (File, ExpandedPath, Level, Category) beside tests.csv. Nothing to
    exclude still prints its one-line count, so a reader sees the exclusion was considered.
.PARAMETER Tests
    The excluded test rows from Get-TestOptOutExclusion.
.PARAMETER Tag
    The opt-out tag(s), named in the message.
.PARAMETER RunDirectory
    The run directory excluded-tests.csv is written into.
#>
function Write-TestOptOutExclusion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Tests,

        [Parameter(Mandatory)]
        [string[]] $Tag,

        [Parameter(Mandatory)]
        [string] $RunDirectory
    )

    $tagText = $Tag -join ', '
    $csvPath = Join-Path $RunDirectory 'excluded-tests.csv'
    $rows = @(foreach ($test in $Tests) {
            [pscustomobject]@{
                File         = ConvertTo-RepoRelativePath $test.File
                ExpandedPath = $test.ExpandedPath
                Level        = $test.Level
                Category     = $test.Category
            }
        })
    if ($rows.Count -gt 0) {
        $rows | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding utf8
    }
    else {
        # Export-Csv writes no file for empty input; the header alone records "considered, nothing excluded".
        [System.IO.File]::WriteAllText($csvPath, "`"File`",`"ExpandedPath`",`"Level`",`"Category`"`n")
    }

    $fileGroups = @($rows | Group-Object -Property File)
    Write-Message "$($rows.Count) test(s) in $($fileGroups.Count) file(s) excluded by '$tagText' — only the source run executes them (list: $csvPath)" -ForegroundColor Yellow -NoHeader
    foreach ($group in $fileGroups) {
        Write-Message "  $($group.Name) ($($group.Count))" -ForegroundColor Yellow -NoHeader
        foreach ($row in $group.Group) {
            Write-Message "    - $($row.ExpandedPath)" -NoHeader
        }
    }
}
