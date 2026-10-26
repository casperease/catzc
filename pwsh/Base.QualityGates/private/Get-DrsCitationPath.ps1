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
