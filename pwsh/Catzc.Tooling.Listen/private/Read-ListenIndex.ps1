<#
---
catzc:
  immutable:
    with_body_sha: "74b9e067ec84"
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
