Describe 'LanguagesConfig' -Tag 'L0' {
    BeforeAll {
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Base.Languages.LanguagesConfig]::new($raw) }
        # One 'widget' entry; it states no_formatter unless the test sets formatter or no_formatter itself.
        $script:one = {
            param([System.Collections.IDictionary] $entry)
            $full = [ordered]@{}
            foreach ($key in $entry.Keys) {
                $full[$key] = $entry[$key]
            }
            if (-not $full.Contains('formatter') -and -not $full.Contains('no_formatter')) {
                $full['no_formatter'] = 'widgets are never formatted'
            }
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{ widget = $full } })
        }
    }

    Context 'integrity (shipped languages.yml)' -Tag 'integrity' {
        It 'passes for the shipped languages.yml' {
            Get-Config -Config languages | Should -BeOfType [Catzc.Base.Languages.LanguagesConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads languages in declared order: a formatter engine or the reason for none, and adr_folder defaulting to none' -Tag 'ADR-PRIN-CONFIG#4' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg', '.widget'); formatter = 'prettier'; adr_folder = 'widgets/core' }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'binary gadgets' }
                    }
                })
            $config.languages.name | Should -Be @('widget', 'gadget')
            $config.languages[0] | Should -BeOfType [Catzc.Base.Languages.FileLanguage]
            $config.languages[0].extensions | Should -Be @('.wdg', '.widget')
            $config.languages[0].formatter | Should -Be 'prettier'
            $config.languages[0].no_formatter | Should -BeNullOrEmpty
            $config.languages[0].adr_folder | Should -Be 'widgets/core'
            $config.languages[1].formatter | Should -BeNullOrEmpty
            $config.languages[1].no_formatter | Should -Be 'binary gadgets'
            $config.languages[1].adr_folder | Should -BeNullOrEmpty
        }

        It 'routes each formatted language''s VS Code language id to its engine''s editor extension' -Tag 'ADR-REPO-FORMAT#8' {
            $config = & $script:make ([ordered]@{
                    engines   = [ordered]@{ prettier = [ordered]@{ vscode_extension = 'widget.prettier' }; gofmt = [ordered]@{} }
                    languages = [ordered]@{
                        widget   = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' }
                        gadget   = [ordered]@{ extensions = @('.gdg'); formatter = 'prettier'; vscode_language = 'gadget-pipelines' }
                        sprocket = [ordered]@{ extensions = @('.spr'); formatter = 'gofmt' }
                        gizmo    = [ordered]@{ extensions = @('.gzm'); formatter = 'ruff' }
                        cog      = [ordered]@{ extensions = @('.cog'); no_formatter = 'binary' }
                    }
                })
            $config.languages[0].vscode_language | Should -Be 'widget'
            $config.languages[1].vscode_language | Should -Be 'gadget-pipelines'
            $config.engines['prettier'].vscode_extension | Should -Be 'widget.prettier'
            $config.engines['gofmt'].vscode_extension | Should -BeNullOrEmpty
            $formatters = $config.EditorFormatters()
            @($formatters.Keys | Sort-Object) | Should -Be @('gadget-pipelines', 'widget')
            $formatters['widget'] | Should -Be 'widget.prettier'
            $formatters['gadget-pipelines'] | Should -Be 'widget.prettier'
        }

        It 'throws on an unknown engine, a bad extension id, an unknown engine key, and a bad vscode_language' {
            $err = { & $script:make ([ordered]@{
                        engines   = [ordered]@{ gizmo = [ordered]@{}; prettier = [ordered]@{ vscode_extension = 'no-dot' }; ruff = [ordered]@{ colour = 'blue' } }
                        languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; vscode_language = 'Widget Lang' } }
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*engines: unknown formatter engine 'gizmo'*"
            $err.Exception.Message | Should -BeLike "*invalid vscode_extension 'no-dot'*"
            $err.Exception.Message | Should -BeLike "*engines?'ruff'?: unknown key 'colour'*"
            $err.Exception.Message | Should -BeLike "*invalid vscode_language 'Widget Lang'*"
        }

        It 'reads an engine''s settings files, and throws on one that is not a repository-relative path' -Tag 'ADR-AUTO-CACHE#10' {
            $config = & $script:make ([ordered]@{
                    engines   = [ordered]@{ prettier = [ordered]@{ settings = @('widget/widget-settings.yml', '.editorconfig') } }
                    languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
                })
            $config.engines['prettier'].settings | Should -Be @('widget/widget-settings.yml', '.editorconfig')
            $err = { & $script:make ([ordered]@{ engines = [ordered]@{ prettier = [ordered]@{ settings = @('../widget.yml', 'C:\gadget.yml') } } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid settings file '../widget.yml'*"
            $err.Exception.Message | Should -BeLike "*invalid settings file 'C:\gadget.yml'*"
        }

        It 'accepts a settings entry that names one top-level key of a file, and throws on a key that is empty or doubled' -Tag 'ADR-AUTO-CACHE#10' {
            $config = & $script:make ([ordered]@{
                    engines   = [ordered]@{ prettier = [ordered]@{ settings = @('widget/tools.yml#widget', 'widget/tools.yml#gadget_two') } }
                    languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
                })
            $config.engines['prettier'].settings | Should -Be @('widget/tools.yml#widget', 'widget/tools.yml#gadget_two')
            $err = { & $script:make ([ordered]@{ engines = [ordered]@{ prettier = [ordered]@{ settings = @('widget/tools.yml#', 'widget/tools.yml#a#b') } } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid settings file 'widget/tools.yml#'*"
            $err.Exception.Message | Should -BeLike "*invalid settings file 'widget/tools.yml#a#b'*"
        }

        It 'accepts every engine it declares' {
            foreach ($engine in [Catzc.Base.Languages.LanguagesConfig]::FormatterEngines) {
                (& $script:one ([ordered]@{ extensions = @('.wdg'); formatter = $engine })).languages[0].formatter | Should -Be $engine
            }
        }

        It 'throws on a language with neither a formatter nor the reason for none, or with both' -Tag 'ADR-PRIN-CONFIG#4' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg') } } }) } |
                Should -Throw '*needs a formatter engine (formatter: one of prettier*or the reason it has none*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); no_formatter = '  ' }) } | Should -Throw '*needs a formatter engine*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; no_formatter = 'never' }) } |
                Should -Throw '*names both a formatter and no_formatter*'
        }

        It 'reads the global imprint steps and a language''s own, with the files each step''s cache stamp reads' -Tag 'ADR-REPO-FORMAT#8' {
            $config = & $script:make ([ordered]@{
                    imprint   = @('file-meta')
                    steps     = [ordered]@{ 'file-meta' = [ordered]@{ settings = @('configs/file-meta.yml', 'configs/file-carriers.yml') } }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; imprint = @('csharp-namespace') }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    }
                })
            $config.imprint | Should -Be @('file-meta')
            $config.languages[0].imprint | Should -Be @('csharp-namespace')
            $config.languages[1].imprint.Count | Should -Be 0
            $config.steps['file-meta'].settings | Should -Be @('configs/file-meta.yml', 'configs/file-carriers.yml')
            $config.steps['csharp-namespace'].settings.Count | Should -Be 0 -Because 'a listed step the file does not describe reads no settings'
            $config.steps.Keys.Count | Should -Be 2
        }

        It 'lists no step unless the file does' -Tag 'ADR-AUTO-DEFAULT#6' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.imprint.Count | Should -Be 0
            $config.steps.Count | Should -Be 0
            $config.languages[0].imprint.Count | Should -Be 0
        }

        It 'throws on an unknown step, a duplicate, a step both global and a language''s own, and malformed steps' -Tag 'ADR-PRIN-CONFIG#2' {
            { & $script:make ([ordered]@{ imprint = @('shine') }) } | Should -Throw "*imprint: unknown imprint step 'shine' (one of: file-meta, csharp-namespace, comments)*"
            { & $script:make ([ordered]@{ imprint = @('file-meta', 'file-meta') }) } | Should -Throw "*imprint: duplicate imprint step 'file-meta'*"
            { & $script:make ([ordered]@{ imprint = 'file-meta' }) } | Should -Throw '*imprint must be a list of imprint step names*'
            { & $script:make ([ordered]@{ steps = [ordered]@{ shine = [ordered]@{} } }) } | Should -Throw "*steps: unknown imprint step 'shine'*"
            { & $script:make ([ordered]@{ steps = [ordered]@{ 'file-meta' = [ordered]@{ colour = 'red' } } }) } | Should -Throw "*unknown key 'colour' (allowed: settings)*"
            { & $script:make ([ordered]@{ steps = [ordered]@{ 'file-meta' = [ordered]@{ settings = @('../outside.yml') } } }) } | Should -Throw "*invalid settings file '../outside.yml'*"
            { & $script:make ([ordered]@{ steps = 'file-meta' }) } | Should -Throw '*invalid steps (must be a map*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); imprint = @('shine') }) } | Should -Throw "*.imprint: unknown imprint step 'shine'*"
            $both = [ordered]@{ imprint = @('file-meta'); languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'x'; imprint = @('file-meta') } } }
            { & $script:make $both } | Should -Throw "*imprint lists 'file-meta', which is already global*"
        }

        It 'names the steps it may list, each with an adapter in Format-Code' -Tag 'integrity' {
            [Catzc.Base.Languages.LanguagesConfig]::ImprintSteps | Should -Be @('file-meta', 'csharp-namespace', 'comments')
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
                    widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never' }
                    gadget = [ordered]@{ extensions = @('.gdg', '.wdg'); no_formatter = 'never' }
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
            { & $script:one ([ordered]@{ formatter = 'prettier' }) } | Should -Throw '*needs at least one extension*'
            { & $script:one ([ordered]@{ extensions = @() }) } | Should -Throw '*needs at least one extension*'
        }

        It 'throws on an unknown key, at the top and in an entry' {
            { & $script:make ([ordered]@{ gadgets = @() }) } | Should -Throw "*unknown key 'gadgets'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); colour = 'blue' }) } | Should -Throw "*unknown key 'colour'*"
        }

        It 'throws on a non-kebab name, a non-map entry, and a non-map languages' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ Widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never' } } }) } |
                Should -Throw "*invalid language name 'Widget'*"
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = '.wdg' } }) } | Should -Throw '*must be a mapping*'
            { & $script:make ([ordered]@{ languages = @('widget') }) } | Should -Throw '*invalid languages*'
        }

        It 'throws on a formatter that is not a declared engine and on a bad adr_folder' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); formatter = 'Format-Widget'; adr_folder = '../widgets' }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown formatter engine 'Format-Widget' (one of: prettier, *"
            $err.Exception.Message | Should -BeLike "*invalid adr_folder '../widgets'*"
        }

        It 'reads a language''s checks in declared order, and none when the entry names none' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; checks = @('Test-WidgetLint', 'Test-Spelling') }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never' }
                    }
                })
            $config.languages[0].checks | Should -Be @('Test-WidgetLint', 'Test-Spelling')
            @($config.languages[1].checks) | Should -HaveCount 0
        }

        It 'throws on a check that is not a quality-gate name, on a duplicate check, and on checks that are not a list' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = @('Format-Widget', 'Test-Spelling', 'Test-Spelling') }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid check 'Format-Widget'*"
            $err.Exception.Message | Should -BeLike "*duplicate check 'Test-Spelling'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = 'Test-Spelling' }) } | Should -Throw '*checks must be a list*'
        }
    }
}
