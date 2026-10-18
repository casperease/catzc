function Get-FileLanguage {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Catzc.Base.Languages.FileLanguage])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [ArgumentCompleter({ Get-FileLanguage | ForEach-Object name })]
        [string[]] $Name,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [AllowEmptyString()]
        [string] $Path
    )

    $config = Get-Config -Config languages

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $language = $config.ForPath($Path)
        if ($null -ne $language) {
            $language
        }
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'Name') {
        foreach ($languageName in $Name) {
            $match = @($config.languages | Where-Object { $_.name -ceq $languageName })
            if ($match.Count -eq 0) {
                throw "Unknown file language '$languageName' (declared in automation/Catzc.Base.Languages/configs/languages.yml: $(@($config.languages | ForEach-Object name) -join ', '))."
            }
            $match[0]
        }
        return
    }

    $config.languages
}
