<#
.SYNOPSIS
    Builds the link engine for a repository and runs it over a file scope.
.DESCRIPTION
    A root other than this repository has no tracked set, so the tracked-file check is skipped there.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-LinkEngine.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root.
.PARAMETER Path
    Optional files or folders to limit the run to (Get-LinkScope); default the git-tracked repository.
.PARAMETER Kind
    Which link kinds to process.
.PARAMETER Wrap
    How an aligned comment line that outgrows its limit is wrapped.
.OUTPUTS
    [Catzc.Base.QualityGates.LinkEngineResult]
#>
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
