<#
---
catzc:
  immutable:
    with_body_sha: "84c2b4b005b1"
  edges:
    docs: "[Get-DrsCitationPath.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsCitationPath.ps1.md)"
---
#>

function Get-DrsCitationPath {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $map = Get-DrsCitationMap -RepositoryRoot $RepositoryRoot
    $paths = @{}
    foreach ($code in $map.Codes) {
        $paths[$code] = $map.PathOf($code)
    }
    $paths
}
