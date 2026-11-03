function Get-DeclaredTrack {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.VariantTrack[]])]
    param()

    $declared = @(Get-Variant -Name tracks)
    if ((Get-CatzcRunMode) -eq 'source') {
        return $declared
    }

    $token = 'Catzc'
    $engineTrack = 'pwsh'
    foreach ($track in $declared) {
        if ($track.name -ceq $engineTrack) {
            throw "The variants config of a consumer repository names the track '$engineTrack', which is the engine's own (ADR-AUTO-CONSUMER-OWNTRACKS); declare the repository's own tracks only."
        }
        if ($track.namespace -ceq $token -or $track.namespace.StartsWith("$token.", [System.StringComparison]::Ordinal)) {
            throw "The variants config of a consumer repository gives the track '$($track.name)' the namespace '$($track.namespace)', which is the system's (ADR-AUTO-CONSUMER-OWNTRACKS); a consumer track's namespace is its own."
        }
    }

    $codeRoot = [System.IO.Path]::GetRelativePath((Get-RepositoryRoot), (Get-CatzcModulesRoot)).Replace('\', '/')
    $member = [Catzc.Base.Variants.VariantMember]::new($codeRoot)
    $engine = [Catzc.Base.Variants.VariantTrack]::new(
        $engineTrack,
        [Catzc.Base.Variants.VariantMember[]]@($member),
        'modules',
        $null,
        [string[]]@('powershell', 'bcl', 'yaml', 'json'),
        [string[]]@('pwsh'),
        $null,
        $null,
        $token)
    @($engine) + $declared
}
