<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FileLanguageFileMetaFact.Tests.ps1
    folder: tests
    name: get-file-language-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Get-FileLanguageFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Languages.LanguagesConfig]::new(@{
                    languages = [ordered]@{
                        widget = @{ extensions = @('.wdg'); no_formatter = 'widgets are never formatted' }
                        gadget = @{ extensions = @('.gdg', '.gdx'); no_formatter = 'gadgets are never formatted' }
                    }
                })
        } -ParameterFilter { $Config -eq 'languages' }

        $script:kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-language' = @{ keys = @('language') } } }).kinds[0]

        function script:Get-Language {
            param([string] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $script:kind; Path = $Path } {
                param($Kind, $Path)
                Get-FileLanguageFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
            }
        }
    }

    It 'names the language whose extensions list the file''s own, under the kind''s key' {
        $fact = Get-Language 'docs/part.wdg'
        @($fact.Keys) | Should -Be @('language')
        $fact['language'] | Should -BeExactly 'widget'
    }

    It 'reads any extension a language lists, whatever the folder' {
        (Get-Language 'a/b/c/part.gdx')['language'] | Should -BeExactly 'gadget'
    }

    It 'reads the extension case-insensitively' {
        (Get-Language 'docs/PART.WDG')['language'] | Should -BeExactly 'widget'
    }

    It 'gives an empty value to a file no language lists, a file with no extension, and a dotfile' -ForEach @(
        @{ Path = 'docs/part.xyz' }
        @{ Path = 'docs/PART' }
        @{ Path = '.gitkeep' }
    ) {
        (Get-Language $Path)['language'] | Should -BeExactly ''
    }
}
