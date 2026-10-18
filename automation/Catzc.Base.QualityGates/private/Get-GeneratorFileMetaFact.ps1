function Get-GeneratorFileMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind names one writer for every file it selects')]
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

    if (-not $Kind.settings.ContainsKey('generator') -or [string]::IsNullOrWhiteSpace("$($Kind.settings['generator'])")) {
        throw "Get-GeneratorFileMetaFact: the kind '$($Kind.id)' needs a 'generator' setting, the path of the file that writes its files."
    }
    $normalized = "$($Kind.settings['generator'])" -replace '\\', '/'
    Assert-PathExist (Join-Path (Get-RepositoryRoot) $normalized) -PathType Leaf
    [ordered]@{ $Kind.keys[0] = $normalized }
}
