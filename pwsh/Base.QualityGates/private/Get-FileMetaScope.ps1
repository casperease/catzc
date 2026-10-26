function Get-FileMetaScope {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Catzc.Base.QualityGates.FileCarrierResolver] $Resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = Get-ScopeLookup -RepositoryRoot $root -Path $Path -Command Get-FileMetaScope
    $fileKinds = Get-Config -Config file-kinds

    # A file named in -Path counts only while git tracks it: an untracked authored file carries no head.
    $paths = @(if ($lookup.Count -gt 0) {
            Get-GitTrackedPath ([string[]] @($lookup))
        })

    $candidates = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($tracked in $paths) {
        $carrier = $Resolver.For($tracked)
        if ($null -eq $carrier) {
            continue
        }
        if ($carrier.carrier -eq [Catzc.Base.Languages.CarrierKind]::None) {
            continue
        }
        if ($Resolver.IsExcluded($carrier, $tracked)) {
            continue
        }
        $candidates.Add([pscustomobject]@{ Path = $tracked; Carrier = $carrier; Class = $fileKinds.Resolve($tracked).Class })
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
