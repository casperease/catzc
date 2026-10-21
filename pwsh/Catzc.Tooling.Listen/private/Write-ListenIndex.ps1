<#
---
catzc:
  immutable:
    with_body_sha: "56c7f0d14afd"
---
#>

function Write-ListenIndex {
    <#
    .SYNOPSIS
        Writes a session's file index, its paths in ordinal order, so two equal indexes are equal files.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Index
    )

    $keys = [string[]] @($Index.Keys)
    [Array]::Sort($keys, [System.StringComparer]::Ordinal)
    $sorted = [ordered]@{}
    foreach ($key in $keys) {
        $sorted[$key] = $Index[$key]
    }
    [System.IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $sorted -Depth 4), [System.Text.UTF8Encoding]::new($false))
}
