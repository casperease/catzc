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

        It 'marks PowerShell with its hosted C#, Bash, Python and Go as the implementation languages' -Tag 'ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION' {
            @((Get-Config -Config languages).languages.Where({ $_.executable }).name) |
                Should -Be @('powershell', 'bcl', 'python', 'go', 'bash')
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'reads languages in declared order: a formatter engine or the reason for none, and adr_folder defaulting to none' -Tag 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg',
                            '.widget'); formatter = 'prettier'; adr_folder = 'widgets/core' }
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

        It 'routes each formatted language''s VS Code language id to its engine''s editor extension' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
            $config = & $script:make ([ordered]@{
                    formatters = [ordered]@{ prettier = [ordered]@{ vscode_extension = 'widget.prettier' }; gofmt = [ordered]@{} }
                    languages  = [ordered]@{
                        widget   = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' }
                        gadget   = [ordered]@{ extensions = @('.gdg'); formatter = 'prettier'; vscode_language = 'gadget-pipelines' }
                        sprocket = [ordered]@{ extensions = @('.spr'); formatter = 'gofmt' }
                        gizmo    = [ordered]@{ extensions = @('.gzm'); formatter = 'ruff' }
                        cog      = [ordered]@{ extensions = @('.cog'); no_formatter = 'binary' }
                    }
                })
            $config.languages[0].vscode_language | Should -Be 'widget'
            $config.languages[1].vscode_language | Should -Be 'gadget-pipelines'
            $config.formatters['prettier'].vscode_extension | Should -Be 'widget.prettier'
            $config.formatters['gofmt'].vscode_extension | Should -BeNullOrEmpty
            $formatters = $config.EditorFormatters()
            @($formatters.Keys | Sort-Object) | Should -Be @('gadget-pipelines', 'widget')
            $formatters['widget'] | Should -Be 'widget.prettier'
            $formatters['gadget-pipelines'] | Should -Be 'widget.prettier'
        }

        It 'reads a language''s tag and its shapes, and refuses a tag-less or invalid one' {
            $config = & $script:make ([ordered]@{
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; tag = 'wdg'; shapes = @('^Widget-[A-Z]\w+$', '^\$widget$') }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never' }
                    }
                })
            $config.languages[0].tag | Should -Be 'wdg'
            $config.languages[0].shapes | Should -Be @('^Widget-[A-Z]\w+$', '^\$widget$')
            $config.languages[1].tag | Should -BeNullOrEmpty
            $config.languages[1].shapes.Count | Should -Be 0
            $err = { & $script:make ([ordered]@{
                        languages = [ordered]@{
                            widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; shapes = @('^ok$') }
                            gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; tag = 'two words'; shapes = @('(unclosed') }
                        }
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*languages?'widget'?: shapes need a tag*"
            $err.Exception.Message | Should -BeLike "*invalid tag 'two words'*"
            $err.Exception.Message | Should -BeLike "*shapes entry '(unclosed' is not a valid regular expression*"
        }

        It 'throws on an unknown engine, a bad extension id, an unknown engine key, and a bad vscode_language' {
            $err = { & $script:make ([ordered]@{
                        formatters = [ordered]@{ gizmo = [ordered]@{}; prettier = [ordered]@{ vscode_extension = 'no-dot' }; ruff = [ordered]@{ colour = 'blue' } }
                        languages  = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; vscode_language = 'Widget Lang' } }
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*formatters: unknown formatter engine 'gizmo'*"
            $err.Exception.Message | Should -BeLike "*invalid vscode_extension 'no-dot'*"
            $err.Exception.Message | Should -BeLike "*formatters?'ruff'?: unknown key 'colour'*"
            $err.Exception.Message | Should -BeLike "*invalid vscode_language 'Widget Lang'*"
        }

        It 'reads an engine''s settings files, and throws on one that is not a repository-relative path' -Tag 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
            $config = & $script:make ([ordered]@{
                    formatters = [ordered]@{ prettier = [ordered]@{ settings = @('widget/widget-settings.yml',
                        '.editorconfig') } }
                    languages  =[ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
                })
            $config.formatters['prettier'].settings | Should -Be @('widget/widget-settings.yml', '.editorconfig')
            $err = { & $script:make ([ordered]@{ formatters = [ordered]@{ prettier = [ordered]@{ settings = @('../widget.yml', 'C:\gadget.yml') } } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid settings file '../widget.yml'*"
            $err.Exception.Message | Should -BeLike "*invalid settings file 'C:\gadget.yml'*"
        }

        It 'accepts a settings entry that names one top-level key of a file, and throws on a key that is empty or doubled' -Tag 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
            $config = & $script:make ([ordered]@{
                    formatters = [ordered]@{ prettier = [ordered]@{ settings = @('widget/tools.yml#widget',
                        'widget/tools.yml#gadget_two') } }
                    languages  =[ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
                })
            $config.formatters['prettier'].settings | Should -Be @('widget/tools.yml#widget',
                'widget/tools.yml#gadget_two')
            $err = { & $script:make ([ordered]@{ formatters = [ordered]@{ prettier = [ordered]@{ settings = @('widget/tools.yml#', 'widget/tools.yml#a#b') } } }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid settings file 'widget/tools.yml#'*"
            $err.Exception.Message | Should -BeLike "*invalid settings file 'widget/tools.yml#a#b'*"
        }

        It 'reads a test runner with tools or with an engine, each with its test-file pattern, and none for a language without one' -Tag 'ADR-AUTO-MODULE-CHECKSBYLANGUAGE' {
            $tools = (& $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = 'test_*.wdg'; tools = @('gizmo', 'sprocket'); executable_parameter = 'GizmoExecutable' } })).languages[0].tests
            $tools.runner | Should -Be 'Invoke-WidgetTest'
            $tools.pattern | Should -Be 'test_*.wdg'
            $tools.tools | Should -Be @('gizmo', 'sprocket')
            $tools.executable_parameter | Should -Be 'GizmoExecutable'
            $tools.engine | Should -BeNullOrEmpty
            $tools.ExecutableName | Should -Be 'gizmo'
            $engine = (& $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; engine = 'bash'; executable_parameter = 'EngineExecutable' } })).languages[0].tests
            $engine.tools.Count | Should -Be 0
            $engine.ExecutableName | Should -Be 'bash'
            (& $script:one ([ordered]@{ extensions = @('.wdg') })).languages[0].tests | Should -BeNullOrEmpty
        }

        It 'throws on a test runner that is not a command, a bad executable, an unknown key, a missing or path-like pattern, or tools and an engine together or neither' -Tag 'ADR-AUTO-MODULE-CHECKSBYLANGUAGE' {
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'widget'; pattern = '*.wdg'; tools = @('gizmo'); executable_parameter = 'GizmoExecutable' } }) } |
                Should -Throw "*runner 'widget' is not a command name*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; tools = @('gizmo'); executable_parameter = '-gizmo' } }) } |
                Should -Throw "*executable_parameter '-gizmo' is not a parameter name*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; tools = @('gizmo'); executable_parameter = 'GizmoExecutable'; colour = 'red' } }) } |
                Should -Throw "*unknown key 'colour'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; tools = @('gizmo'); executable = 'GizmoExecutable' } }) } |
                Should -Throw "*unknown key 'executable'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; tools = @('gizmo'); executable_parameter = 'GizmoExecutable' } }) } |
                Should -Throw "*pattern '' is not a test-file glob*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = 'tests/*.wdg'; tools = @('gizmo'); executable_parameter = 'GizmoExecutable' } }) } |
                Should -Throw "*pattern 'tests/*.wdg' is not a test-file glob*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; tools = @('gizmo'); engine = 'bash'; executable_parameter = 'GizmoExecutable' } }) } |
                Should -Throw '*never both and never neither*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); tests = [ordered]@{ runner = 'Invoke-WidgetTest'; pattern = '*.wdg'; executable_parameter = 'GizmoExecutable' } }) } |
                Should -Throw '*never both and never neither*'
        }

        It 'says whether a track is laid out by its primary language, the first it declares' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'x'; layout = @([ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }) }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'x' }
                    }
                })
            $config.IsLaidOut(@('widget', 'gadget')) | Should -BeTrue
            $config.IsLaidOut(@('gadget', 'widget')) | Should -BeFalse
            $config.IsLaidOut(@('sprocket')) | Should -BeFalse
            $config.IsLaidOut(@()) | Should -BeFalse
            $config.IsLaidOut($null) | Should -BeFalse
        }

        It 'reads executable as stated, false when the entry is silent, and throws on one that is not a boolean' -Tag 'ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION' {
            (& $script:one ([ordered]@{ extensions = @('.wdg'); executable = $true })).languages[0].executable |
                Should -BeTrue
            (& $script:one ([ordered]@{ extensions = @('.wdg'); executable = $false })).languages[0].executable |
                Should -BeFalse
            (& $script:one ([ordered]@{ extensions = @('.wdg') })).languages[0].executable | Should -BeFalse
            { & $script:one ([ordered]@{ extensions = @('.wdg'); executable = 'yes' }) } |
                Should -Throw '*executable must be true or false*'
        }

        It 'accepts every engine it declares' {
            foreach ($engine in [Catzc.Base.Languages.LanguagesConfig]::FormatterEngines) {
                (& $script:one ([ordered]@{ extensions = @('.wdg'); formatter = $engine })).languages[0].formatter |
                    Should -Be $engine
            }
        }

        It 'throws on a language with neither a formatter nor the reason for none, or with both' -Tag 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg') } } }) } |
                Should -Throw '*needs a formatter engine (formatter: one of prettier*or the reason it has none*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); no_formatter = '  ' }) } |
                Should -Throw '*needs a formatter engine*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; no_formatter = 'never' }) } |
                Should -Throw '*names both a formatter and no_formatter*'
        }

        It 'reads the global imprint steps and a language''s own, with the files each step''s cache stamp reads' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
            $config = & $script:make ([ordered]@{
                    imprint   = @('file-meta')
                    steps     = [ordered]@{ 'file-meta' = [ordered]@{ settings = @('configs/file-meta.yml',
                        'configs/file-carriers.yml') } }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; imprint = @('bcl-namespace') }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    }
                })
            $config.imprint | Should -Be @('file-meta')
            $config.languages[0].imprint | Should -Be @('bcl-namespace')
            $config.languages[1].imprint.Count | Should -Be 0
            $config.steps['file-meta'].settings | Should -Be @('configs/file-meta.yml', 'configs/file-carriers.yml')
            $config.steps['bcl-namespace'].settings.Count |
                Should -Be 0 -Because 'a listed step the file does not describe reads no settings'
            $config.steps.Keys.Count | Should -Be 2
        }

        It 'lists no step unless the file does' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.imprint.Count | Should -Be 0
            $config.steps.Count | Should -Be 0
            $config.languages[0].imprint.Count | Should -Be 0
        }

        It 'throws on an unknown step, a duplicate, a step both global and a language''s own, and malformed steps' -Tag 'PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE' {
            { & $script:make ([ordered]@{ imprint = @('shine') }) } |
                Should -Throw "*imprint: unknown imprint step 'shine' (one of: file-meta, bcl-namespace, comments, ps-help, wrap-powershell, plan-counts)*"
            { & $script:make ([ordered]@{ imprint = @('file-meta', 'file-meta') }) } |
                Should -Throw "*imprint: duplicate imprint step 'file-meta'*"
            { & $script:make ([ordered]@{ imprint = 'file-meta' }) } |
                Should -Throw '*imprint must be a list of imprint step names*'
            { & $script:make ([ordered]@{ steps = [ordered]@{ shine = [ordered]@{} } }) } |
                Should -Throw "*steps: unknown imprint step 'shine'*"
            { & $script:make ([ordered]@{ steps = [ordered]@{ 'file-meta' = [ordered]@{ colour = 'red' } } }) } |
                Should -Throw "*unknown key 'colour' (allowed: settings)*"
            { & $script:make ([ordered]@{ steps = [ordered]@{ 'file-meta' = [ordered]@{ settings = @('../outside.yml') } } }) } | Should -Throw "*invalid settings file '../outside.yml'*"
            { & $script:make ([ordered]@{ steps = 'file-meta' }) } | Should -Throw '*invalid steps (must be a map*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); imprint = @('shine') }) } |
                Should -Throw "*.imprint: unknown imprint step 'shine'*"
            $both = [ordered]@{ imprint = @('file-meta'); languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'x'; imprint = @('file-meta') } } }
            { & $script:make $both } | Should -Throw "*imprint lists 'file-meta', which is already global*"
        }

        It 'names the steps it may list, each with an adapter in Format-Code' -Tag 'integrity' {
            [Catzc.Base.Languages.LanguagesConfig]::ImprintSteps | Should -Be @('file-meta', 'bcl-namespace',
                'comments', 'ps-help', 'wrap-powershell', 'plan-counts')
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
            { & $script:one ([ordered]@{ extensions = @('wdg') }) } |
                Should -Throw "*extension 'wdg' needs its leading dot*"
        }

        It 'throws on an uppercase or empty-part extension, and a duplicate within one language' {
            $err = { & $script:one ([ordered]@{ extensions = @('.WDG', '.w..dg', '.wdg', '.wdg') }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid extension '.WDG'*"
            $err.Exception.Message | Should -BeLike "*invalid extension '.w..dg'*"
            $err.Exception.Message | Should -BeLike "*duplicate extension '.wdg'*"
        }

        It 'accepts a compound extension, each part a dot and lowercase letters or digits' {
            { & $script:one ([ordered]@{ extensions = @('.gadget.wdg') }) } | Should -Not -Throw
        }

        It 'throws on a language with no extensions' {
            { & $script:one ([ordered]@{ formatter = 'prettier' }) } | Should -Throw '*needs at least one extension*'
            { & $script:one ([ordered]@{ extensions = @() }) } | Should -Throw '*needs at least one extension*'
        }

        It 'throws on an unknown key, at the top and in an entry' {
            { & $script:make ([ordered]@{ gadgets = @() }) } | Should -Throw "*unknown key 'gadgets'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); colour = 'blue' }) } |
                Should -Throw "*unknown key 'colour'*"
        }

        It 'throws on a non-kebab name, a non-map entry, and a non-map languages' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ Widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never' } } }) } |
                Should -Throw "*invalid language name 'Widget'*"
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = '.wdg' } }) } |
                Should -Throw '*must be a mapping*'
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
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = @('Format-Widget', 'Test-Spelling',
                'Test-Spelling') }) } |
                Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*invalid check 'Format-Widget'*"
            $err.Exception.Message | Should -BeLike "*duplicate check 'Test-Spelling'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = 'Test-Spelling' }) } |
                Should -Throw '*checks must be a list*'
        }

        It 'reads the config address a check governs, and none for a check the entry gives no scope' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; checks = @('Test-WidgetLint', 'Test-Spelling'); check_scopes = [ordered]@{ 'Test-WidgetLint' = 'global.widgets.folder' } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; checks = @('Test-Spelling') }
                    }
                })
            $config.languages[0].check_scopes['Test-WidgetLint'] | Should -BeExactly 'global.widgets.folder'
            $config.languages[0].check_scopes.ContainsKey('Test-Spelling') | Should -BeFalse
            $config.languages[1].check_scopes.Count | Should -Be 0
        }

        It 'throws on a scope for a check the language does not name, on a scope that is no global address, and on scopes that are not a map' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = @('Test-Spelling'); check_scopes = [ordered]@{ 'Test-WidgetLint' = 'global.widgets.folder'; 'Test-Spelling' = 'widgets/folder' } }) } |
                Should -Throw -PassThru
            $err.Exception.Message |
                Should -BeLike "*check_scopes names 'Test-WidgetLint', which is not one of the language's checks*"
            $err.Exception.Message |
                Should -BeLike "*invalid check_scopes address 'widgets/folder' for 'Test-Spelling'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); checks = @('Test-Spelling'); check_scopes = @('Test-Spelling') }) } | Should -Throw '*check_scopes must be a map*'
        }

        It 'reads a language''s layout rows, then the shared assets and tests rows, and derives the live patterns and folders from them' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg', '.wdx'); layout = @(
                        [ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }
                        [ordered]@{ folder = 'inner'; role = 'private-widget' }
                        [ordered]@{ folder = 'drafts'; role = 'draft'; live = $false; shipped = $false }
                    )
                })
            $config.languages[0].layout.folder | Should -Be @('.', 'inner', 'drafts')
            $config.layout.folder | Should -Be @('.', 'inner', 'drafts', 'assets', 'tests', '.')
            $config.LivePatterns() | Should -Be @('*.wdg', 'inner/**', 'assets/**')
            $config.LayoutFolders() | Should -Be @('inner', 'drafts', 'assets', 'tests')
            $config.ShippedFolders() | Should -Be @('inner', 'assets')
        }

        It 'resolves a role''s folder from the layout, the shared test row too, and throws on a role no folder has' -Tag 'ADR-REPO-FOLDERS-NAMESARESETTINGS' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg'); layout = @(
                        [ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }
                        [ordered]@{ folder = 'inner'; role = 'private-widget' }
                    )
                })
            $config.FolderOf('private-widget') | Should -BeExactly 'inner'
            $config.FolderOf('test') | Should -BeExactly 'tests'
            { $config.FolderOf('public-widget') } | Should -Throw "*no layout folder has the role 'public-widget'*"
            { $config.FolderOf('gadget') } | Should -Throw "*no layout folder has the role 'gadget'*"
        }

        It 'has only the shared rows when no language declares a layout, the generated project file placed and never live' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.layout.folder | Should -Be @('assets', 'tests', '.')
            $config.LivePatterns() | Should -Be @('assets/**')
            $config.PlaceOf('pyproject.toml').role | Should -Be 'project'
            $config.PlaceOf('go.mod').live | Should -BeFalse
            $config.PlaceOf('gadget.wdx') | Should -BeNullOrEmpty
        }

        It 'places a file by the root row of its extension or by the row that names its folder, and places none it does not know' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg', '.wdx'); layout = @(
                        [ordered]@{ folder = '.'; role = 'public-widget'; extensions = @('.wdg') }
                        [ordered]@{ folder = 'inner'; role = 'private-widget' }
                    )
                })
            $config.PlaceOf('Gadget.wdg').role | Should -Be 'public-widget'
            $config.PlaceOf('inner/deep/Gadget.txt').role | Should -Be 'private-widget'
            $config.PlaceOf('assets/a/b.bin').role | Should -Be 'asset'
            $config.PlaceOf('tests/Gadget.Tests.wdg').live | Should -BeFalse
            $config.PlaceOf('Gadget.wdx') | Should -BeNullOrEmpty
            $config.PlaceOf('NOTES') | Should -BeNullOrEmpty
            $config.PlaceOf('stray/Gadget.wdg') | Should -BeNullOrEmpty
            $config.PlaceOf('') | Should -BeNullOrEmpty
        }

        It 'throws on a folder named twice, within a language, across languages and against a shared row' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = @(
                            [ordered]@{ folder = 'inner'; role = 'a' }
                            [ordered]@{ folder = 'inner'; role = 'b' }
                        )
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*folder 'inner' is named twice*"
            { & $script:make ([ordered]@{ languages = [ordered]@{
                            widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'x'; layout = @([ordered]@{ folder = 'inner'; role = 'a' }) }
                            gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'x'; layout = @([ordered]@{ folder = 'inner'; role = 'b' }) }
                        }
                    }) } | Should -Throw "*folder 'inner' is named twice (by 'widget' and 'gadget')*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = @([ordered]@{ folder = 'tests'; role = 'a' }) }) } |
                Should -Throw "*folder 'tests' is named twice (by 'widget' and '(shared)')*"
        }

        It 'throws on an unknown layout key, a bad folder, a bad role, a root row without extensions, extensions on a folder row, and a foreign extension' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $err = { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = @(
                            [ordered]@{ folder = 'a'; role = 'r'; speed = 1 }
                            [ordered]@{ folder = 'Bad/Folder'; role = 'r' }
                            [ordered]@{ folder = 'b'; role = 'Bad Role' }
                            [ordered]@{ folder = '.'; role = 'r' }
                            [ordered]@{ folder = 'c'; role = 'r'; extensions = @('.wdg') }
                            [ordered]@{ folder = '.'; role = 'r'; extensions = @('.zzz') }
                            [ordered]@{ folder = '.'; role = 's'; extensions = @('.wdg') }
                            [ordered]@{ folder = '.'; role = 't'; extensions = @('.wdg') }
                        )
                    }) } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*layout: unknown key 'speed'*"
            $err.Exception.Message | Should -BeLike "*invalid folder 'Bad/Folder'*"
            $err.Exception.Message | Should -BeLike "*invalid role 'Bad Role'*"
            $err.Exception.Message | Should -BeLike '*the root row must list the extensions it places*'
            $err.Exception.Message | Should -BeLike "*only the root row lists extensions; folder 'c'*"
            $err.Exception.Message | Should -BeLike "*extension '.zzz' is not one of the language's own*"
            $err.Exception.Message | Should -BeLike "*extension '.wdg' is placed by two root rows*"
        }

        It 'throws on a layout that is not a list, and on live or shipped that is not a boolean' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = 'inner' }) } |
                Should -Throw '*layout must be a list of rows*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = @([ordered]@{ folder = 'a'; role = 'r'; live = 'yes' }) }) } |
                Should -Throw '*live must be true or false*'
        }

        It 'judges each file name and each folder on its path by its language''s cases, a folder once, a hidden folder past its dot' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $config = & $script:make ([ordered]@{
                    naming    = [ordered]@{ exempt_folders = @('assets') }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ folder = @('snake'); file = 'snake'; exempt = @('Fixed.wdg') } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ folder = @('pascal-dotted', 'kebab'); file = @('verb-noun', 'pascal') } }
                        other  = [ordered]@{ extensions = @('.oth'); no_formatter = 'never' }
                    }
                })
            $config.naming_exempt_folders | Should -Be @('assets')
            $config.languages[0].naming.file | Should -Be @('snake')
            $config.MisnamedPaths([string[]] @(
                    'widget_root/Bad-Folder/good_name.wdg'
                    'widget_root/Bad-Folder/BadName.wdg'
                    'widget_root/.hidden_ok/__init__.wdg'
                    'widget_root/assets/Any-Name.wdg'
                    'Fixed.wdg'
                    '.internal/Catzc.Gadget/Get-Gadget.Tests.gdg'
                    'Catzc.Gadget/lower_case.gdg'
                    'Any_Folder/Any-Name.oth'
                    'notes.md'
                )) | Should -Be @(
                'Catzc.Gadget/lower_case.gdg: the file name is not verb-noun or pascal (gadget)'
                'widget_root/Bad-Folder/: the folder is not snake (widget)'
                'widget_root/Bad-Folder/BadName.wdg: the file name is not snake (widget)'
            )
        }

        It 'reads go''s flat folders and snake files, and rejects an unknown case, an unknown key, and a naming without cases' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ folder = 'flat'; file = 'snake' } })
            $config.MisnamedPaths([string[]] @('widgets/catzc-widget/widget_test.wdg',
                'widgets/catzcwidget/widget_test.wdg')) |
                Should -Be @('widgets/catzc-widget/: the folder is not flat (widget)')
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'title' } }) } |
                Should -Throw "*unknown case 'title'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'snake'; style = 'x' } }) } | Should -Throw "*unknown key 'style'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ exempt = @('a.wdg') } }) } |
                Should -Throw '*names the cases of its folders, its files, its functions or its types*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'snake'; exempt = @('a.md') } }) } | Should -Throw "*invalid exempt file 'a.md'*"
            { & $script:make ([ordered]@{ naming = [ordered]@{ exempt_folders = @('a/b') } }) } |
                Should -Throw "*invalid exempt folder 'a/b'*"
        }

        It 'reads a language''s function and type cases, and a naming that names only them' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $naming = (& $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ function = 'snake'; type = @('pascal', 'pascal-dotted') } })).languages[0].naming
            $naming.function | Should -Be @('snake')
            $naming.type | Should -Be @('pascal', 'pascal-dotted')
            $naming.folder | Should -BeNullOrEmpty
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ function = 'title' } }) } |
                Should -Throw "*naming.function: unknown case 'title'*"
        }

        It 'reads the normal form, snake when the file names none, and throws on a case that cannot render every other' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            (& $script:make ([ordered]@{ naming = [ordered]@{ normal_form = 'kebab' } })).naming_normal_form |
                Should -BeExactly 'kebab'
            (& $script:make ([ordered]@{})).naming_normal_form | Should -BeExactly 'snake'
            { & $script:make ([ordered]@{ naming = [ordered]@{ normal_form = 'verb-noun' } }) } |
                Should -Throw "*normal_form 'verb-noun' is not a case every name renders from*"
        }
    }
}
