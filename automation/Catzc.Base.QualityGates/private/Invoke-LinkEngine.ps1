<#
.SYNOPSIS
    Builds the link engine for a repository and runs it over a file scope.
.DESCRIPTION
    The one place Format-Links and Test-Links assemble the engine, so the aligner and the gate can never disagree:
    the ADR citation map (Get-AdrCitationMap), the line limits (Get-LinkLineLimit over .editorconfig and links.yml),
    the default limit, the wrap mode, this repository's web URL (Get-RepositoryWebUrl), the string-citation check's
    exempt globs (links.yml string_citations), and the paths git tracks, so a
    markdown link to a file GitHub does not have is reported. Any other root (a test's scratch root) has no tracked
    set to compare against, so the tracked check is skipped there. Reads only — the result
    carries each changed file's new text for the caller to write.
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
