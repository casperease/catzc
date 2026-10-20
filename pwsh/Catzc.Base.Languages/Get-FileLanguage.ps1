<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/Get-FileLanguage.ps1
    name: get-file-language
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
    docs: "[Get-FileLanguage.ps1.md](docs/references/pwsh/catzc-base-languages/Get-FileLanguage.ps1.md)"
    cites:
      - ADR-DSGN-TRACK-FILELANGUAGE
---
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
                throw "Unknown file language '$languageName' (declared in the languages config, Catzc.Base.Languages configs/languages.yml:$(@($config.languages | ForEach-Object name) -join ', '))."
            }
            $match[0]
        }
        return
    }

    $config.languages
}
