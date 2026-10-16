<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/FileCarrierResolver.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/types/FileCarrierResolver.cs
    adrs:
      - ADR-REPO-FILEMETA#5
---
#>

Describe 'FileCarrierResolver' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#5' {
    BeforeAll {
        $script:languages = [Catzc.Base.Languages.LanguagesConfig]::new(@{
                languages = [ordered]@{
                    widget = @{ extensions = @('.wdg'); no_formatter = 'widgets are never formatted' }
                    gadget = @{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    cog    = @{ extensions = @('.cog'); no_formatter = 'cogs are never formatted' }
                }
            })
        $script:carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    widget   = @{ carrier = 'comment-head'; line = '#'; exclude = @{ '**/tests/**' = 'a test carries no head' } }
                    gadget   = @{ carrier = 'front-matter' }
                    sprocket = @{ files = @('docs/special/**', '**/*.wdg.keep'); carrier = 'none'; reason = 'kept verbatim' }
                }
            })
        $script:resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new($script:carriers, $script:languages)
    }

    It 'resolves a path by its file language when no class selects it' {
        $script:resolver.For('automation/Widget/get.wdg').id | Should -BeExactly 'widget'
        $script:resolver.For('docs/read.gdg').id | Should -BeExactly 'gadget'
    }

    It 'lets a class with files win over the language of the same file' {
        $script:resolver.For('docs/special/get.wdg').id | Should -BeExactly 'sprocket'
        $script:resolver.For('anywhere/get.wdg.keep').id | Should -BeExactly 'sprocket'
    }

    It 'resolves nothing for a path no language and no class names, or a language with no entry' {
        $script:resolver.For('docs/plain.txt') | Should -BeNullOrEmpty
        $script:resolver.For('docs/spin.cog') | Should -BeNullOrEmpty
        $script:resolver.For('README') | Should -BeNullOrEmpty
    }

    It 'reads backslashes as the separators they mean' {
        $script:resolver.For('docs\special\get.wdg').id | Should -BeExactly 'sprocket'
    }

    It 'says which paths an entry leaves out' {
        $widget = $script:resolver.For('automation/Widget/get.wdg')
        $script:resolver.IsExcluded($widget, 'automation/Widget/tests/get.wdg') | Should -BeTrue
        $script:resolver.IsExcluded($widget, 'automation/Widget/get.wdg') | Should -BeFalse
        $script:resolver.IsExcluded($script:resolver.For('docs/read.gdg'), 'docs/tests/read.gdg') | Should -BeFalse -Because 'only the widget entry lists an exclude'
    }

    It 'resolves with the shipped registries, every language file to its entry' -Tag 'integrity' {
        $shipped = [Catzc.Base.QualityGates.FileCarrierResolver]::new((Get-Config -Config file-carriers), (Get-Config -Config languages))
        $shipped.For('automation/Catzc.Base.QualityGates/Format-Code.ps1').id | Should -BeExactly 'powershell'
        $shipped.For('automation/Catzc.Base.Languages/types/FileLanguage.cs').id | Should -BeExactly 'csharp'
        $shipped.For('docs/adr/index.md').id | Should -BeExactly 'markdown'
        $shipped.For('docs/.assets/explanation/x.drawio.png').id | Should -BeExactly 'diagram'
        $shipped.For('.gitignore').id | Should -BeExactly 'dotfile'
        $shipped.IsExcluded($shipped.For('automation/Catzc.Base.Widget/tests/Get-Gadget.Tests.ps1'), 'automation/Catzc.Base.Widget/tests/Get-Gadget.Tests.ps1') | Should -BeTrue
    }
}
