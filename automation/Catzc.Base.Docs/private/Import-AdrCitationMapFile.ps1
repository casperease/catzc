<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1
    folder: private
    name: import-adr-citation-map-file
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-FAILFAST
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
