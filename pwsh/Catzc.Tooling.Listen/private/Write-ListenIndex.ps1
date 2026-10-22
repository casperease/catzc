<#
---
catzc:
  immutable:
    with_body_sha: f8471745c2ae
  edges:
    docs: "[Write-ListenIndex.ps1.md](../../../docs/references/pwsh/catzc-tooling-listen/private/Write-ListenIndex.ps1.md)"
---
#>

function Write-ListenIndex {
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
