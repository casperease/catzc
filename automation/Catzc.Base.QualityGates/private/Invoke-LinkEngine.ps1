function Invoke-LinkEngine {
    [CmdletBinding()]
    [OutputType([Catzc.Base.QualityGates.LinkEngineResult])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.LinkKind] $Kind,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.LinkWrap] $Wrap
    )

    $settings = Get-Config -Config links
    $limits = Get-LinkLineLimit -RepositoryRoot $RepositoryRoot -Override $settings.line_limit
    # Get-GitTrackedPath reads the loaded repository's index, so it answers only for that root.
    $engineRoot = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/')
    $loadedRoot = [System.IO.Path]::GetFullPath((Get-RepositoryRoot)).TrimEnd('\', '/')
    $isLoadedRepository = $engineRoot -ieq $loadedRoot
    # Assigned in the branch: an `if` expression would re-wrap the string[] as object[], which the constructor refuses.
    [string[]] $tracked = $null
    if ($isLoadedRepository) {
        $tracked = @(Get-GitTrackedPath '.')
    }
    $engine = [Catzc.Base.QualityGates.LinkEngine]::new(
        $RepositoryRoot,
        (Get-AdrCitationMap -RepositoryRoot $RepositoryRoot),
        $Wrap,
        $limits,
        $settings.default_line_limit,
        (Get-RepositoryWebUrl -RepositoryRoot $RepositoryRoot),
        $tracked,
        $settings.string_citations)

    $scope = Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path
    $engine.Run([string[]] $scope, $Kind)
}
