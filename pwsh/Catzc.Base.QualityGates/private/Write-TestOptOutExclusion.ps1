<#
---
catzc:
  immutable:
    with_body_sha: "88185494cb1a"
  edges:
    docs: "[Write-TestOptOutExclusion.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestOptOutExclusion.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SOURCEONLYTAG
---
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
