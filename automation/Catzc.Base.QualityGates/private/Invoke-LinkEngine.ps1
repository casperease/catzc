<#
.SYNOPSIS
    Builds the link engine for a repository and runs it over a file scope.
.DESCRIPTION
    The one place Format-Links and Test-Links assemble the engine, so the aligner and the gate can never disagree:
    the ADR citation map (Get-AdrCitationMap), the line limits (Get-LinkLineLimit over .editorconfig and links.yml),
    the default limit, the wrap mode, and this repository's web URL (Get-RepositoryWebUrl). Reads only — the result
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
    $engine = [Catzc.Base.QualityGates.LinkEngine]::new(
        $RepositoryRoot,
        (Get-AdrCitationMap -RepositoryRoot $RepositoryRoot),
        $Wrap,
        $limits,
        $settings.default_line_limit,
        (Get-RepositoryWebUrl -RepositoryRoot $RepositoryRoot))

    $scope = Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path
    $engine.Run([string[]] $scope, $Kind)
}
