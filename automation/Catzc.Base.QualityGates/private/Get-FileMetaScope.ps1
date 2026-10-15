<#
.SYNOPSIS
    Lists the tracked files that carry a meta block, each with the carrier entry that says where it goes
    ([ADR-REPO-FILEMETA#5](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta5)).
.DESCRIPTION
    Exempt files, opt-outs, a class's own excludes and a path no imprint kind names all stay out.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FileMetaScope.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.PARAMETER Config
    The meta-kind registry.
.PARAMETER Resolver
    The carrier resolver. Default: built from the shipped file-carriers and languages registries.
.OUTPUTS
    [pscustomobject] @{ Path; Carrier } per file, Path repository-relative and '/'-separated, in git's order.
#>
function Get-FileMetaScope {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaConfig] $Config,

        [Catzc.Base.QualityGates.FileCarrierResolver] $Resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-FileMetaScope
    $kindGlobs = @($Config.Imprint() | ForEach-Object { $_.files } | Select-Object -Unique | ForEach-Object { [Catzc.Base.Globs.GlobPattern]::new($_) })

    $candidates = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($tracked in @(Get-GitTrackedPath $lookup)) {
        $carrier = $Resolver.For($tracked)
        if ($null -eq $carrier) {
            continue
        }
        if ($carrier.carrier -ne [Catzc.Base.Languages.CarrierKind]::FrontMatter -and $carrier.carrier -ne [Catzc.Base.Languages.CarrierKind]::CommentHead) {
            continue
        }
        if ($Resolver.IsExcluded($carrier, $tracked)) {
            continue
        }
        $applies = $false
        foreach ($glob in $kindGlobs) {
            if ($glob.Matches($tracked)) {
                $applies = $true
                break
            }
        }
        if ($applies) {
            $candidates.Add([pscustomobject]@{ Path = $tracked; Carrier = $carrier })
        }
    }
    if ($candidates.Count -eq 0) {
        return
    }

    # Get-ContentExemptPath returns one array, so it is assigned first and the set holds paths, not the array.
    $paths = [string[]] @($candidates | ForEach-Object Path)
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $paths
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $paths -Attribute catzc-meta
    foreach ($candidate in $candidates) {
        $classes = $attributes[$candidate.Path]
        if (-not $exempt.Contains($candidate.Path) -and -not ($classes -and $classes['catzc-meta'] -eq 'unset')) {
            $candidate
        }
    }
}
