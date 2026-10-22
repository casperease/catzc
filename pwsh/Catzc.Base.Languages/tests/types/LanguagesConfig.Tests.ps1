<#
---
catzc:
  immutable:
    with_body_sha: "7aa8682f2f31"
  edges:
    code: pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-IDIOM-LANGUAGEIDIOM
      - ADR-AUTO-IDIOM-CLOSEDCASES
      - ADR-AUTO-IDIOM-NORMALFORM
      - ADR-AUTO-IDIOM-ROUNDTRIP
      - ADR-AUTO-IDIOM-ACRONYMISWORD
      - ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM
      - ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
      - ADR-AUTO-MODULE-CHECKSBYLANGUAGE
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
---
#>

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
                    formatters = [ordered]@{ prettier = [ordered]@{ settings = @('widget/widget-settings.yml', '.editorconfig') } }
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
                    formatters = [ordered]@{ prettier = [ordered]@{ settings = @('widget/tools.yml#widget', 'widget/tools.yml#gadget_two') } }
                    languages  =[ordered]@{ widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier' } }
                })
            $config.formatters['prettier'].settings | Should -Be @('widget/tools.yml#widget', 'widget/tools.yml#gadget_two')
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
            (& $script:one ([ordered]@{ extensions = @('.wdg'); executable = $true })).languages[0].executable | Should -BeTrue
            (& $script:one ([ordered]@{ extensions = @('.wdg'); executable = $false })).languages[0].executable | Should -BeFalse
            (& $script:one ([ordered]@{ extensions = @('.wdg') })).languages[0].executable | Should -BeFalse
            { & $script:one ([ordered]@{ extensions = @('.wdg'); executable = 'yes' }) } | Should -Throw '*executable must be true or false*'
        }

        It 'accepts every engine it declares' {
            foreach ($engine in [Catzc.Base.Languages.LanguagesConfig]::FormatterEngines) {
                (& $script:one ([ordered]@{ extensions = @('.wdg'); formatter = $engine })).languages[0].formatter | Should -Be $engine
            }
        }

        It 'throws on a language with neither a formatter nor the reason for none, or with both' -Tag 'PDR-CONFIG-EXCEPTIONISCONFIGENTRY' {
            { & $script:make ([ordered]@{ languages = [ordered]@{ widget = [ordered]@{ extensions = @('.wdg') } } }) } |
                Should -Throw '*needs a formatter engine (formatter: one of prettier*or the reason it has none*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); no_formatter = '  ' }) } | Should -Throw '*needs a formatter engine*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; no_formatter = 'never' }) } |
                Should -Throw '*names both a formatter and no_formatter*'
        }

        It 'reads the global imprint steps and a language''s own, with the files each step''s cache stamp reads' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
            $config = & $script:make ([ordered]@{
                    imprint   = @('file-meta')
                    steps     = [ordered]@{ 'file-meta' = [ordered]@{ settings = @('configs/file-meta.yml', 'configs/file-carriers.yml') } }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); formatter = 'prettier'; imprint = @('bcl-namespace') }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    }
                })
            $config.imprint | Should -Be @('file-meta')
            $config.languages[0].imprint | Should -Be @('bcl-namespace')
            $config.languages[1].imprint.Count | Should -Be 0
            $config.steps['file-meta'].settings | Should -Be @('configs/file-meta.yml', 'configs/file-carriers.yml')
            $config.steps['bcl-namespace'].settings.Count | Should -Be 0 -Because 'a listed step the file does not describe reads no settings'
            $config.steps.Keys.Count | Should -Be 2
        }

        It 'lists no step unless the file does' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
            $config = & $script:one ([ordered]@{ extensions = @('.wdg') })
            $config.imprint.Count | Should -Be 0
            $config.steps.Count | Should -Be 0
            $config.languages[0].imprint.Count | Should -Be 0
        }

        It 'throws on an unknown step, a duplicate, a step both global and a language''s own, and malformed steps' -Tag 'PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE' {
            { & $script:make ([ordered]@{ imprint = @('shine') }) } | Should -Throw "*imprint: unknown imprint step 'shine' (one of: file-meta, bcl-namespace, comments, ps-help, plan-counts)*"
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
            [Catzc.Base.Languages.LanguagesConfig]::ImprintSteps | Should -Be @('file-meta', 'bcl-namespace', 'comments', 'ps-help', 'plan-counts')
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

        It 'throws on an uppercase or empty-part extension, and a duplicate within one language' {
            $err = { & $script:one ([ordered]@{ extensions = @('.WDG', '.w..dg', '.wdg', '.wdg') }) } | Should -Throw -PassThru
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
            { & $script:one ([ordered]@{ extensions = @('.wdg'); layout = 'inner' }) } | Should -Throw '*layout must be a list of rows*'
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
            $config.MisnamedPaths([string[]] @('widgets/catzc-widget/widget_test.wdg', 'widgets/catzcwidget/widget_test.wdg')) |
                Should -Be @('widgets/catzc-widget/: the folder is not flat (widget)')
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'title' } }) } | Should -Throw "*unknown case 'title'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'snake'; style = 'x' } }) } | Should -Throw "*unknown key 'style'*"
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ exempt = @('a.wdg') } }) } | Should -Throw '*names the cases of its folders, its files, its functions or its types*'
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ file = 'snake'; exempt = @('a.md') } }) } | Should -Throw "*invalid exempt file 'a.md'*"
            { & $script:make ([ordered]@{ naming = [ordered]@{ exempt_folders = @('a/b') } }) } | Should -Throw "*invalid exempt folder 'a/b'*"
        }

        It 'reads a language''s function and type cases, and a naming that names only them' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $naming = (& $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ function = 'snake'; type = @('pascal', 'pascal-dotted') } })).languages[0].naming
            $naming.function | Should -Be @('snake')
            $naming.type | Should -Be @('pascal', 'pascal-dotted')
            $naming.folder | Should -BeNullOrEmpty
            { & $script:one ([ordered]@{ extensions = @('.wdg'); naming = [ordered]@{ function = 'title' } }) } | Should -Throw "*naming.function: unknown case 'title'*"
        }

        It 'reads the normal form, snake when the file names none, and throws on a case that cannot render every other' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            (& $script:make ([ordered]@{ naming = [ordered]@{ normal_form = 'kebab' } })).naming_normal_form | Should -BeExactly 'kebab'
            (& $script:make ([ordered]@{})).naming_normal_form | Should -BeExactly 'snake'
            { & $script:make ([ordered]@{ naming = [ordered]@{ normal_form = 'verb-noun' } }) } | Should -Throw "*normal_form 'verb-noun' is not a case every name renders from*"
        }
    }

    Context 'LanguageNaming cases' {
        It 'splits a name in its case into namespace segments of lowercase words, and joins them back' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' -ForEach @(
            @{ Case = 'pascal'; Name = 'GadgetMetrics'; Words = 'gadget metrics' }
            @{ Case = 'camel'; Name = 'requireGadgetPart'; Words = 'require gadget part' }
            @{ Case = 'pascal-dotted'; Name = 'Widget.Base.GadgetParts'; Words = 'widget|base|gadget parts' }
            @{ Case = 'verb-noun'; Name = 'Get-GadgetPart'; Words = 'get gadget part' }
            @{ Case = 'verb-noun'; Name = 'ConvertTo-GadgetName'; Words = 'convert to gadget name' }
            @{ Case = 'kebab'; Name = 'widget-gadget-part'; Words = 'widget gadget part' }
            @{ Case = 'snake'; Name = 'widget_gadget_part'; Words = 'widget gadget part' }
            @{ Case = 'flat'; Name = 'widgetgadget'; Words = 'widgetgadget' }
        ) {
            $segments = [Catzc.Base.Objects.NameCase]::Split($Case, $Name)
            ($segments.ForEach({ $_ -join ' ' }) -join '|') | Should -BeExactly $Words
            [Catzc.Base.Objects.NameCase]::Join($Case, $segments) | Should -BeExactly $Name
        }

        It 'renders one name in every case, the namespaces joined as one run where a case has none' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' -ForEach @(
            @{ Case = 'snake'; Expected = 'widget_base_gadget_parts' }
            @{ Case = 'kebab'; Expected = 'widget-base-gadget-parts' }
            @{ Case = 'flat'; Expected = 'widgetbasegadgetparts' }
            @{ Case = 'pascal'; Expected = 'WidgetBaseGadgetParts' }
            @{ Case = 'camel'; Expected = 'widgetBaseGadgetParts' }
            @{ Case = 'pascal-dotted'; Expected = 'Widget.Base.GadgetParts' }
        ) {
            $segments = [Catzc.Base.Objects.NameCase]::Split('pascal-dotted', 'Widget.Base.GadgetParts')
            [Catzc.Base.Objects.NameCase]::Join($Case, $segments) | Should -BeExactly $Expected
        }

        It 'reads an acronym as one ordinary word, so a capitalised run does not round-trip' -Tag 'ADR-AUTO-IDIOM-ACRONYMISWORD' {
            $segments = [Catzc.Base.Objects.NameCase]::Split('pascal', 'HTTPGadget')
            $segments[0] | Should -Be @('http', 'gadget')
            [Catzc.Base.Objects.NameCase]::Join('pascal', $segments) | Should -BeExactly 'HttpGadget'
        }

        It 'takes the longest leading approved verb, and throws when the words start with none' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' {
            [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('convert', 'from', 'gadget'))) | Should -BeExactly 'ConvertFrom-Gadget'
            { [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('gadget', 'part'))) } | Should -Throw '*no approved verb*'
            { [Catzc.Base.Objects.NameCase]::Join('verb-noun', [string[][]] @(, [string[]] @('get'))) } | Should -Throw '*no approved verb*'
        }

        It 'keeps snake''s leading and trailing underscores outside the case' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' {
            [Catzc.Base.Objects.NameCase]::Split('snake', '__init__')[0] | Should -Be @('init')
            [Catzc.Base.Objects.NameCase]::Split('snake', '_private_part')[0] | Should -Be @('private', 'part')
        }

        It 'splits nothing for a name outside the case, and throws on an unknown case or a word that is not lowercase' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' {
            [Catzc.Base.Objects.NameCase]::Split('kebab', 'Gadget-Part') | Should -BeNullOrEmpty
            [Catzc.Base.Objects.NameCase]::Split('pascal', 'Widget.Gadget') | Should -BeNullOrEmpty
            { [Catzc.Base.Objects.NameCase]::Split('title', 'Gadget Part') } | Should -Throw "*unknown case 'title'*"
            { [Catzc.Base.Objects.NameCase]::Join('kebab', [string[][]] @(, [string[]] @('Gadget'))) } | Should -Throw "*'Gadget' is not a lowercase word*"
        }

        It 'renders any text by its words, a case boundary and any non-letter starting a word' -Tag 'ADR-AUTO-IDIOM-CLOSEDCASES' -ForEach @(
            @{ Text = 'HelveticaMetrics'; Expected = 'helvetica-metrics' }
            @{ Text = 'Get-FooBar'; Expected = 'get-foo-bar' }
            @{ Text = 'Catzc.Internal.Types'; Expected = 'catzc-internal-types' }
            @{ Text = 'already-kebab'; Expected = 'already-kebab' }
            @{ Text = '..'; Expected = '' }
        ) {
            [Catzc.Base.Objects.NameCase]::Render($Text, 'kebab') | Should -BeExactly $Expected
        }

        It 'names a module''s test folder in each language''s first folder case, and throws for a language without one or a name not dotted pascal' -Tag 'ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM' {
            $config = & $script:make ([ordered]@{ languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ folder = @('snake', 'kebab') } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ folder = 'flat' } }
                        plain  = [ordered]@{ extensions = @('.pln'); no_formatter = 'never'; naming = [ordered]@{ file = 'kebab' } }
                        bare   = [ordered]@{ extensions = @('.bre'); no_formatter = 'never' }
                    }
                })
            $config.TestFolderOf('widget', 'Widget.Base.GadgetParts') | Should -BeExactly 'widget_base_gadget_parts'
            $config.TestFolderOf('gadget', 'Widget.Base.GadgetParts') | Should -BeExactly 'widgetbasegadgetparts'
            { $config.TestFolderOf('plain', 'Widget.Base') } | Should -Throw '*names no folder case*'
            { $config.TestFolderOf('bare', 'Widget.Base') } | Should -Throw "*languages?'bare'?: no naming entry*"
            { $config.TestFolderOf('widget', '.internal') } | Should -Throw "*module '.internal' is not a pascal-dotted name*"
        }

        It 'judges a defined function or type by its kind''s cases and its round trip, past exempt files and folders' -Tag 'ADR-AUTO-IDIOM-ROUNDTRIP' {
            $config = & $script:make ([ordered]@{
                    naming    = [ordered]@{ exempt_folders = @('assets'); normal_form = 'snake' }
                    languages = [ordered]@{
                        widget = [ordered]@{ extensions = @('.wdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'verb-noun'; type = 'pascal'; exempt = @('Fixed.wdg') } }
                        gadget = [ordered]@{ extensions = @('.gdg'); no_formatter = 'never'; naming = [ordered]@{ function = 'snake' } }
                    }
                })
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Get-Gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'ConvertTo-GadgetName') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'get_gadget') | Should -BeExactly "a/Get-Gadget.wdg: the function 'get_gadget' is not verb-noun (widget)"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Get-HTTPGadget') |
                Should -BeExactly "a/Get-Gadget.wdg: the function 'Get-HTTPGadget' does not round-trip through the normal form (it renders back as Get-HttpGadget) (widget)"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'function', 'Gadget-Part') | Should -BeLike "*'Gadget-Part' does not round-trip*no approved verb*"
            $config.MisnamedDefinition('a/Get-Gadget.wdg', 'type', 'GadgetConfig') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/gadgets.gdg', 'function', '__init__') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/gadgets.gdg', 'type', 'Anything_Goes') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('Fixed.wdg', 'function', 'get_gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('a/assets/x.wdg', 'function', 'get_gadget') | Should -BeNullOrEmpty
            $config.MisnamedDefinition('notes.md', 'function', 'get_gadget') | Should -BeNullOrEmpty
        }

        It 'carries a name to the normal form and back, snake''s outer underscores outside the case' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            [Catzc.Base.Objects.NameCase]::ToNormal('pascal-dotted', 'Widget.Base.GadgetParts', 'snake') | Should -BeExactly 'widget.base.gadget_parts'
            [Catzc.Base.Objects.NameCase]::FromNormal('widget.base.gadget_parts', 'pascal-dotted', 'snake') | Should -BeExactly 'Widget.Base.GadgetParts'
            [Catzc.Base.Objects.NameCase]::ToNormal('snake', '__init__', 'snake') | Should -BeExactly '__init__'
            [Catzc.Base.Objects.NameCase]::FromNormal('__init__', 'snake', 'snake') | Should -BeExactly '__init__'
            [Catzc.Base.Objects.NameCase]::FromNormal('_private_part', 'pascal', 'snake') | Should -BeExactly 'PrivatePart'
            { [Catzc.Base.Objects.NameCase]::ToNormal('kebab', 'Gadget', 'snake') } | Should -Throw "*'Gadget' is not kebab*"
        }

        It 'tells a dotted normal-form name in one call, while a case stays strict about the dot' -Tag 'ADR-AUTO-IDIOM-NORMALFORM' {
            [Catzc.Base.Objects.NameCase]::IsNormal('widget.base.gadget_parts', 'snake') | Should -BeTrue
            [Catzc.Base.Objects.NameCase]::IsNormal('__init__', 'snake') | Should -BeTrue
            [Catzc.Base.Objects.NameCase]::IsNormal('widget.Base', 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsNormal('widget..gadget', 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsNormal($null, 'snake') | Should -BeFalse
            [Catzc.Base.Objects.NameCase]::IsInCase('snake', 'widget.gadget') | Should -BeFalse
        }

        It 'judges a file name past its role suffix and the one qualifier before it' -Tag 'ADR-AUTO-IDIOM-LANGUAGEIDIOM' {
            $naming = [Catzc.Base.Languages.LanguageNaming]::new(@(), @('verb-noun', 'pascal'), @())
            $naming.IsFileIdiomatic('Get-Gadget.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('GadgetConfig.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Get-Gadget.L2.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Build-Gadget.SampleWidget.Tests') | Should -BeTrue
            $naming.IsFileIdiomatic('Get-Gadget.L2.Extra.Tests') | Should -BeFalse
            $naming.IsFileIdiomatic('Get-Gadget.l2.Tests') | Should -BeFalse
            $naming.IsFileIdiomatic('Get-Gadget.Spec') | Should -BeFalse
        }
    }

    Context 'integrity (shipped languages.yml layout)' -Tag 'integrity' {
        It 'places the five live folders the aspects were written with and each language track''s root scripts, and the shared tests folder is not live' -Tag 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
            $config = Get-Config -Config languages
            $config.LivePatterns() | Should -Be @('*.ps1', 'private/**', 'types/**', 'configs/**', '*.py', '*.go', '*.sh', 'assets/**')
            $config.IsLaidOut(@('python')) | Should -BeTrue
            $config.IsLaidOut(@('go')) | Should -BeTrue
            $config.IsLaidOut(@('bash')) | Should -BeTrue
            $config.IsLaidOut(@('markdown', 'asset')) | Should -BeFalse
            # The editor extension's folder and the run-list folder are laid out but neither live nor shipped, like the shared tests folder.
            $config.LayoutFolders() | Should -Be @('private', 'extension', 'types', 'configs', 'accosted', 'assets', 'tests')
            $config.ShippedFolders() | Should -Be @('types', 'configs', 'assets')
        }
    }
}
