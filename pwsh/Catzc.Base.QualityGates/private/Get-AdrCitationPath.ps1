<#
---
catzc:
  immutable:
    with_body_sha: "4db5498e8872"
  edges:
    docs: "[Get-AdrCitationPath.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-AdrCitationPath.ps1.md)"
---
#>

function Get-AdrCitationPath {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    $paths = @{}
    foreach ($code in $map.Codes) {
        $paths[$code] = $map.PathOf($code)
    }
    $paths
}
