function Get-CatzcBundleFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind reads the bundle by path alone')]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaKind] $Kind
    )

    $exporter = Get-Config -Config exporter
    # One resolved member list per bundle, smallest first, built once per exporter registry.
    $cachedFor = Get-Variable -Name bundleMembersFor -Scope Script -ValueOnly -ErrorAction Ignore
    if (-not [object]::ReferenceEquals($cachedFor, $exporter)) {
        $members = foreach ($name in $exporter.bundles.Keys) {
            [pscustomobject]@{ Name = $name; Modules = [string[]] @(Get-ModuleProfile -Name $exporter.bundles[$name].profile) }
        }
        $script:bundleMembers = @($members | Sort-Object { $_.Modules.Count })
        $script:bundleMembersFor = $exporter
    }

    $root = (Get-Track -Name automation).places[0]
    $value = ''
    $folder = [regex]::Match(($Path -replace '\\', '/'), '^' + [regex]::Escape($root) + '/(?<folder>[^/]+)/')
    if ($folder.Success) {
        foreach ($bundle in $script:bundleMembers) {
            if ($folder.Groups['folder'].Value -in $bundle.Modules) {
                $value = $bundle.Name
                break
            }
        }
    }
    [ordered]@{ $Kind.keys[0] = $value }
}
