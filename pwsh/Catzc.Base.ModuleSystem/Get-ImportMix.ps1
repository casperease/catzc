function Get-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param(
        [ArgumentCompleter({ (Get-Config -Config languages).languages.name })]
        [string[]] $Languages,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string[]] $Engines
    )

    $present = [System.Collections.Generic.List[string]]::new()
    foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::Names) {
        try {
            [void] (Resolve-EngineExecutable -Engine $engine)
            $present.Add($engine)
        }
        catch {
            Write-Verbose "The $engine engine is not present: $($_.Exception.Message)"
        }
    }

    $moduleLanguages = [ordered]@{}
    foreach ($module in Get-CatzcModule -TrackType modules) {
        $moduleLanguages[$module.name] = [string[]] @($module.languages)
    }

    $languageEntries = (Get-Config -Config languages).languages
    [Catzc.Base.ModuleSystem.ImportMix]::Resolve(
        (Get-Config -Config importer),
        ($PSBoundParameters.ContainsKey('Languages') ? $Languages : $null),
        ($PSBoundParameters.ContainsKey('Engines') ? $Engines : $null),
        [string[]] $present,
        $moduleLanguages,
        [string[]] @($languageEntries.name),
        [string[]] @($languageEntries.Where({ $_.executable }).name))
}
