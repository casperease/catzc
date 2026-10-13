<#
.SYNOPSIS
    Maps every ADR citation code to its ADR's repository-relative path.
.DESCRIPTION
    A flat view of the citation map (Get-AdrCitationMap) for the Markdown heading normal form, which writes a moved
    citation as a link to its ADR.
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
