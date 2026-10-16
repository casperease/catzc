<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Get-FileLanguage.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#6
  config:
    synopsis: Returns the repository's file languages — all of them, the named ones, or the one a file is written in.
    description: |-
      The file-language registry (configs/languages.yml, validated by the LanguagesConfig type) names each language a
      tracked file is written in by its extensions ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)),
      with the formatter engine that formats it (or why it has none) and its ADR folder. Each result is a FileLanguage,
      in declared order.

      -Path answers "which file language is this file?" by its extension, case-insensitively. A file whose extension no
      language lists, a file with no extension, and a dotfile such as .gitkeep return nothing; -Path never throws.
    parameters:
      Name: The file-language name(s) to return. An unknown name throws, naming the config file.
      Path: A file path (repository-relative or absolute); returns the file language its extension names.
    examples:
      - Get-FileLanguage
      - '(Get-FileLanguage -Name markdown).formatter                              # -> prettier'
      - '(Get-FileLanguage -Path ''automation/Catzc.Base.Languages/Get-FileLanguage.ps1'').name   # -> powershell'
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
                throw "Unknown file language '$languageName' (declared in automation/Catzc.Base.Languages/configs/languages.yml: $(@($config.languages | ForEach-Object name) -join ', '))."
            }
            $match[0]
        }
        return
    }

    $config.languages
}
