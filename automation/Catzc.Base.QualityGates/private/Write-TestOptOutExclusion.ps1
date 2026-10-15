<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#31
---
#>

<#
.SYNOPSIS
    Prints and records the tests a test run's opt-out tag excluded — the visible half of the opt-out rule.
.DESCRIPTION
    With nothing excluded it still prints its count and writes a header-only CSV, so the check is seen to have run.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestOptOutExclusion.ps1.md#comment1)
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
