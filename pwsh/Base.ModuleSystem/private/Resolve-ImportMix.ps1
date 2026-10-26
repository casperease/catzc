function Resolve-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param(
        [string[]] $Languages,

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

    # A module's code languages are those of the files a language's own layout row places; the shared rows never count.
    $languageConfig = Get-Config -Config languages
    $moduleLanguages = [ordered]@{}
    foreach ($module in Get-CatzcModule -EngineTrack) {
        $code = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($file in $module.files) {
            $row = $languageConfig.PlaceOf($file)
            $language = $languageConfig.ForPath($file)
            if ($null -ne $row -and $null -ne $row.language -and $null -ne $language -and $language.executable) {
                [void] $code.Add($language.name)
            }
        }
        $moduleLanguages[$module.name] = [string[]] @($code)
    }

    $executable = [string[]] @(foreach ($entry in $languageConfig.languages) {
            if ($entry.executable) {
                $entry.name
            }
        })
    $handled = [string[]] @(foreach ($entry in $languageConfig.languages) {
            if ($entry.handled) {
                $entry.name
            }
        })
    try {
        [Catzc.Base.ModuleSystem.ImportMix]::Resolve(
            (Get-Config -Config importer),
            ($PSBoundParameters.ContainsKey('Languages') ? $Languages : $null),
            ($PSBoundParameters.ContainsKey('Engines') ? $Engines : $null),
            [string[]] $present,
            $moduleLanguages,
            [string[]] @($languageConfig.languages.name),
            $executable,
            $handled)
    }
    catch [System.Management.Automation.MethodInvocationException] {
        # The resolution's own error surfaces as itself, not as the call's wrapper.
        throw $_.Exception.InnerException
    }
}
