# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-AdrCitationPath.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Maps every ADR citation code to its ADR's repository-relative path.
.DESCRIPTION
    The heading normal form needs a plain code-to-path lookup to write a moved citation as a link to its ADR.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-AdrCitationPath.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root whose ADR index is read.
.OUTPUTS
    [hashtable] citation code -> repository-relative ADR path.
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
