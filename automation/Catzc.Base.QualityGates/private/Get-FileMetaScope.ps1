<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1
    folder: private
    name: get-file-meta-scope
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-FileMetaScope.Tests.ps1
  config:
    synopsis: Lists the tracked files that carry a meta block, each with the carrier entry that says where it goes.
    description: |-
      A file is in scope when its class has a front-matter or comment-head carrier, the class does not leave it out, an imprint kind's
      globs match it, and `.gitattributes` does not exempt it or opt it out.
    parameters:
      RepositoryRoot: The repository root the returned paths are relative to.
      Path: Optional files or folders (absolute or relative to the current location) to limit the scope to.
      Config: The meta-kind registry.
      Resolver: 'The carrier resolver. Default: built from the shipped file-carriers and languages registries.'
    outputs: '[pscustomobject] @{ Path; Carrier } per file, Path repository-relative and ''/''-separated, in git''s order.'
---
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
    $languages = Get-Config -Config languages
    $fileKinds = Get-Config -Config file-kinds

    $candidates = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($tracked in @(Get-GitTrackedPath $lookup)) {
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
        $language = $languages.ForPath($tracked)
        $languageName = if ($language) {
            $language.name
        }
        else {
            $null
        }
        if ($Config.SelectsAny($fileKinds.Resolve($tracked).Class, $languageName)) {
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
