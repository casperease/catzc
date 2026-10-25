<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-DrsCitationPath.ps1.md"
  warning: "Generated Header"
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
