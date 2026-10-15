<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
    kind: private-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-AUTO-FAILFAST
  config:
    synopsis: Reads one tab-separated ADR map (a code map or a rule map) into one hashtable per row, keyed by the header.
    description: |-
      The map's first line must be exactly the expected header, and every row must have one cell per header column;
      anything else throws, naming the file and line, before a single reference is rewritten
      ([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)). Blank lines are skipped. The cells are
      validated by [Catzc.Base.Docs.AdrCitationRewriter], which reads the rows.
    parameters:
      Path: The absolute path of the map file.
      Header: The expected column names, in order.
    outputs: '[hashtable[]] One hashtable per data row, column name to cell.'
    examples:
      - Import-AdrCitationMapFile -Path $codeMapPath -Header 'old_code', 'new_code', 'old_path', 'new_path', 'kind'
---
#>

function Import-AdrCitationMapFile {
    [CmdletBinding()]
    [OutputType([hashtable[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string[]] $Header
    )

    Assert-PathExist $Path -PathType Leaf
    $lines = [System.IO.File]::ReadAllLines($Path)
    $expected = $Header -join "`t"
    $actual = if ($lines.Count -gt 0) {
        $lines[0].TrimStart([char] 0xFEFF)
    }
    else {
        ''
    }
    Assert-True ($actual -ceq $expected) -ErrorText "${Path}: the header is '$actual', expected '$expected' (tab-separated)"

    $rows = for ($index = 1; $index -lt $lines.Count; $index++) {
        if ([string]::IsNullOrWhiteSpace($lines[$index])) {
            continue
        }
        $cells = $lines[$index].Split("`t")
        Assert-True ($cells.Count -eq $Header.Count) -ErrorText "${Path}:$($index + 1): $($cells.Count) cells, expected $($Header.Count)"
        $row = @{}
        for ($column = 0; $column -lt $Header.Count; $column++) {
            $row[$Header[$column]] = $cells[$column]
        }
        $row
    }

    , [hashtable[]] @($rows)
}
