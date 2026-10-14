Describe 'LanguagesConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Languages.LanguagesConfig]::new($raw) }
        $script:one = {
            param([System.Collections.IDictionary] $entry)
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{ widget = $entry } })
        }
    }

    Context 'integrity (shipped languages.yml)' -Tag 'integrity' {
        It 'passes for the shipped languages.yml' {
            Get-Config -Config languages | Should -BeOfType [Catzc.Base.Languages.LanguagesConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads languages in declared order, with formatter and adr_folder defaulting to none' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg', '.widget'); formatter = 'Format-Widget'; adr_folder = 'widgets/core' }
                        gadget = [ordered]@{ extensions = @('.gdg') }
                    }
                })
            $config.languages.name | Should -Be @('widget', 'gadget')
            $config.languages[0] | Should -BeOfType [Catzc.Base.Languages.FileLanguage]
            $config.languages[0].extensions | Should -Be @('.wdg', '.widget')
            $config.languages[0].formatter | Should -Be 'Format-Widget'
            $config.languages[0].adr_folder | Should -Be 'widgets/core'
            $config.languages[1].formatter | Should -BeNullOrEmpty
            $config.languages[1].adr_folder | Should -BeNullOrEmpty
        }

        It 'is empty for an empty file' {
            (& $script:make ([ordered]@{})).languages.Count | Should -Be 0
        }

        It 'finds a language by extension, with or without the dot, in any case' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.ForExtension('.wdg').name | Should -Be 'widget'
            $config.ForExtension('WDG').name | Should -Be 'widget'
            $config.ForExtension('.gdg') | Should -BeNullOrEmpty
        }

        It 'finds a language by path, and none for an unknown extension, a dotfile, or no extension' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.ForPath('widget/deep/Gadget.Widget.WDG').name | Should -Be 'widget'
            $config.ForPath('widget\gadget.wdg').name | Should -Be 'widget'
            $config.ForPath('widget/gadget.gdg') | Should -BeNullOrEmpty
            $config.ForPath('widget/.wdg') | Should -BeNullOrEmpty
            $config.ForPath('widget/WIDGET') | Should -BeNullOrEmpty
            $config.ForPath('widget/gadget.') | Should -BeNullOrEmpty
        }

        It 'throws on an extension claimed by two languages' {
            $raw = [ordered]@{ languages = [ordered]@{
                    widget = [ordered]@{ extensions = @('.wdg') }
                    gadget = [ordered]@{ extensions = @('.gdg', '.wdg') }
                }
            }
            { & $script:make $raw } | Should -Throw "*extension '.wdg' is already claimed by 'widget'*"
        }

        It 'throws on an extension without its leading dot' {
            { & $script:one ([ordered]@{ extensions = @('wdg') }) } | Should -Throw "*extension 'wdg' needs its leading dot*"
        }

        It 'throws on an uppercase or dotted extension, and a duplicate within one language' {
            $err = { & $script:one ([ordered]@{ extensions = @('.WDG', '.w.dg', '.wdg', '.wdg') }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid extension '.WDG'*"
            $err.Exception.Message | Should -BeLike "*invalid extension '.w.dg'*"
            $err.Exception.Message | Should -BeLike "*duplicate extension '.wdg'*"
        }

        It 'throws on a language with no extensions' {
            { & $script:one ([ordered]@{ formatter = 'Format-Widget' }) } | Should -Throw '*needs at least one extension*'
            { & $script:one ([ordered]@{ extensions = @() }) } | Should -Throw '*needs at least one extension*'
        }

        It 'throws on an unknown key, at the top and in an entry' {
            { & $script:make ([ordered]@{ gadgets = @() }) } | Should -Throw "*unknown key 'gadgets'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); colour = 'blue' }) } | Should -Throw "*unknown key 'colour'*"
        }

        It 'throws on a non-kebab name, a non-map entry, and a non-map languages' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ Widget = [ordered]@{ extensions = @('.wdg') } } }) } |
                Should -Throw "*invalid language name 'Widget'*"
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = '.wdg' } }) } | Should -Throw '*must be a mapping*'
            { & $script:make ([ordered]@{ languages = @('widget') }) } | Should -Throw '*invalid languages*'
        }

        It 'throws on a formatter that is not a Verb-Noun command and on a bad adr_folder' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); formatter = 'widget-fmt'; adr_folder = '../widgets' }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid formatter 'widget-fmt'*"
            $err.Exception.Message | Should -BeLike "*invalid adr_folder '../widgets'*"
        }
    }
}
