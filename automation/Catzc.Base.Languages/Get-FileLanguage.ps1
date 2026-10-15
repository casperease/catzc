<#
.SYNOPSIS
    Returns the repository's file languages — all of them, the named ones, or the one a file is written in.
.DESCRIPTION
    The file-language registry (configs/languages.yml, validated by the LanguagesConfig type) names each language a...
    [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)
    [comment:1](/docs/references/automation/catzc-base-languages/Get-FileLanguage.ps1.md#comment1)
.PARAMETER Name
    The file-language name(s) to return. An unknown name throws, naming the config file.
.PARAMETER Path
    A file path (repository-relative or absolute); returns the file language its extension names.
.EXAMPLE
    Get-FileLanguage
.EXAMPLE
    (Get-FileLanguage -Name markdown).formatter                              # -> prettier
.EXAMPLE
    (Get-FileLanguage -Path 'automation/Catzc.Base.Languages/Get-FileLanguage.ps1').name   # -> powershell
#>
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
