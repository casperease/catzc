<#
---
catzc:
  immutable:
    with_body_sha: "9ffb123c308d"
  edges:
    docs: "[Read-ListenIndex.ps1.md](../../../docs/references/pwsh/catzc-tooling-listen/private/Read-ListenIndex.ps1.md)"
---
#>

function Read-ListenIndex {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf
    $index = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    if ($null -eq $index) {
        return @{}
    }
    $index
}
