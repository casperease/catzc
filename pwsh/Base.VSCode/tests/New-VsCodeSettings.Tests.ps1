<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/tests/New-VsCodeSettings.Tests.ps1.md"
  header: "generated"
---
#>

# cspell:ignore gopls  -- the Go language server and its VS Code settings key
Describe 'New-VsCodeSettings' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolated through the config seam; the authored search.exclude carries an un-exclude (false) injection must not override.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{
                        'editor.tabSize' = 4
                        'search.exclude' = [ordered]@{
                            'widgets/.vendor'      = $true
                            'keep/searchable.psd1' = $false
                        }
                    }
                })
        }
    }

    It 'renders valid JSON carrying the authored settings, with no head of its own' {
        $text = New-VsCodeSettings
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'editor.tabSize' | Should -Be 4
    }

    It 'carries the rows another writer owns from the file on disk, and keeps an authored row the registry''s' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{ 'widget.exclude' = [ordered]@{ 'authored' = $true } }
                    carried  = [ordered]@{ 'widget.exclude' = 'gadget.owned' }
                })
        }
        $current = Join-Path $TestDrive 'settings.json'
        Set-Content -LiteralPath $current -Value "// head`n{ `"widget.exclude`": { `"authored`": false, `"lamp`": true, `"stray`": true }, `"gadget.owned`": [ `"authored`", `"lamp`" ] }"
        $json = ((New-VsCodeSettings -CurrentPath $current) -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'widget.exclude'.authored | Should -BeTrue
        $json.'widget.exclude'.lamp | Should -BeTrue
        $json.'widget.exclude'.PSObject.Properties['stray'] | Should -BeNullOrEmpty
        @($json.'gadget.owned') | Should -Be @('authored', 'lamp')
        (((New-VsCodeSettings -CurrentPath (Join-Path $TestDrive 'none.json')) -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json).PSObject.Properties['gadget.owned'] | Should -BeNullOrEmpty
    }

    It 'renders the .editorconfig baseline into the top level and each mapped language, an authored setting winning' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings     = [ordered]@{ 'files.eol' = "`r`n"; '[widget]' = [ordered]@{ 'editor.tabSize' = 8 } }
                    editorconfig = [ordered]@{ '*.wdg' = @('widget', 'gadget') }
                })
        }
        $editorConfigPath = Join-Path $TestDrive '.editorconfig'
        Set-Content -LiteralPath $editorConfigPath -Value "root = true`n[*]`nindent_style = space`nindent_size = 4`nend_of_line = lf`ntrim_trailing_whitespace = true`n[*.wdg]`nindent_style = tab`nindent_size = 2`nmax_line_length = 100`n[*.cs]`ndotnet_style_widget = false"
        $json = (New-VsCodeSettings -EditorConfigPath $editorConfigPath -CurrentPath (Join-Path $TestDrive 'none.json')) |
            ConvertFrom-Json -AsHashtable
        $json['editor.insertSpaces'] | Should -BeTrue
        $json['editor.tabSize'] | Should -Be 4
        $json['editor.detectIndentation'] | Should -BeFalse
        $json['files.trimTrailingWhitespace'] | Should -BeTrue
        $json['files.eol'] | Should -Be "`r`n"
        $json['[gadget]']['editor.insertSpaces'] | Should -BeFalse
        $json['[gadget]']['editor.tabSize'] | Should -Be 2
        @($json['[gadget]']['editor.rulers']) | Should -Be @(100)
        $json['[widget]']['editor.tabSize'] | Should -Be 8
        $json['[widget]']['editor.insertSpaces'] | Should -BeFalse
        $json.Keys | Should -Not -Contain '[cs]'
    }

    It 'renders the tagged languages the lamps offer, each with its tag and extensions, in the order given' {
        $languages = [ordered]@{ widget = @{ tag = 'wdg'; extensions = @('.wdg',
                    '.wdgx')
            }; gadget                   = @{ tag = 'gdg'; extensions = @('.gdg') }
        }
        $json = (New-VsCodeSettings -LampLanguage $languages -CurrentPath (Join-Path $TestDrive 'none.json')) |
            ConvertFrom-Json -AsHashtable
        @($json['catzc.trackLamps.languages'].Keys) | Should -Be @('widget', 'gadget')
        $json['catzc.trackLamps.languages']['widget']['tag'] | Should -Be 'wdg'
        @($json['catzc.trackLamps.languages']['widget']['extensions']) | Should -Be @('.wdg', '.wdgx')
        @($json['catzc.trackLamps.languages']['gadget']['extensions']) | Should -Be @('.gdg')
    }

    It 'completes search.exclude with every managed target' {
        $text = New-VsCodeSettings -ManagedTarget 'importer.ps1', '.editorconfig'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
        $json.'search.exclude'.'.editorconfig' | Should -BeTrue
        $json.'search.exclude'.'widgets/.vendor' | Should -BeTrue
    }

    It 'sets each language''s editor formatter, merged into an authored [language] block whose own keys win' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{
                        '[widget]' = [ordered]@{ 'editor.wordWrap' = 'off' }
                        '[gadget]' = [ordered]@{ 'editor.defaultFormatter' = 'gadget.authored' }
                    }
                })
        }
        $text = New-VsCodeSettings -LanguageFormatter ([ordered]@{ widget = 'widget.engine'; gadget = 'gadget.engine'; sprocket = 'sprocket.engine' })
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'[widget]'.'editor.defaultFormatter' | Should -Be 'widget.engine'
        $json.'[widget]'.'editor.wordWrap' | Should -Be 'off'
        $json.'[gadget]'.'editor.defaultFormatter' | Should -Be 'gadget.authored'
        $json.'[sprocket]'.'editor.defaultFormatter' | Should -Be 'sprocket.engine'
    }

    It 'lets an authored entry win over an injected key of the same name' {
        $text = New-VsCodeSettings -ManagedTarget 'keep/searchable.psd1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'keep/searchable.psd1' |
            Should -BeFalse -Because 'an explicit authored un-exclude must survive injection'
    }

    It 'renders each filter''s include/exclude sets in lamp order, and no key without them' {
        $filter = [ordered]@{
            widgets = @([ordered]@{ include = @('widgets/**'); exclude = @('widgets/tests/**') })
            gadgets = @([ordered]@{ include = @('gadgets', 'gadgets/**'); exclude = @() })
        }
        $json = (New-VsCodeSettings -RepositoryFilter $filter) | ConvertFrom-Json
        @($json.'catzc.trackLamps.filters'.PSObject.Properties.Name) | Should -Be @('widgets',
            'gadgets') -Because 'the declaration order is the lamp order'
        @($json.'catzc.trackLamps.filters'.widgets[0].exclude) | Should -Be @('widgets/tests/**')
        @($json.'catzc.trackLamps.filters'.gadgets[0].include) | Should -Be @('gadgets', 'gadgets/**')
        $bare = (New-VsCodeSettings | ConvertFrom-Json).PSObject.Properties.Name
        $bare | Should -Not -Contain 'catzc.trackLamps.filters'
    }

    It 'creates the search.exclude map when the registry has none' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{ settings = [ordered]@{ 'editor.tabSize' = 2 } })
        }
        $text = New-VsCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
    }

    It 'adds the machine-resolved settings after the authored ones, and the authored key wins' {
        $text = New-VsCodeSettings -MachineSetting @{ 'widget.root' = 'C:\widget'; 'editor.tabSize' = 8 }
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'widget.root' | Should -Be 'C:\widget'
        $json.'editor.tabSize' | Should -Be 4 -Because 'an authored setting wins over a machine-resolved one'
    }

    It 'leaves the cached config untouched when it completes search.exclude' {
        $fixture = [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                settings = [ordered]@{ 'search.exclude' = [ordered]@{ 'widgets/.vendor' = $true } }
            })
        Mock Get-Config -ModuleName Catzc.Base.VSCode { $fixture }
        $null = New-VsCodeSettings -ManagedTarget 'importer.ps1'
        @($fixture.settings['search.exclude'].Keys) | Should -Be @('widgets/.vendor')
    }
}

Describe 'New-VsCodeSettings — real vscode-settings.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry to valid settings JSON with the analyzer wiring intact' {
        $text = New-VsCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $settings = "$(Get-CatzcModulesFolder)/.internal/assets/PSScriptAnalyzerSettings.psd1"
        $json.'powershell.scriptAnalysis.settingsPath' | Should -Be "./$settings"
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
        # The authored un-exclude of the analyzer's settings file must survive rendering verbatim.
        $json.'search.exclude'.$settings | Should -BeFalse
    }

    It 'hides no Go test source from the explorer, search, the watcher, or gopls, for the <_>/ root' -ForEach @('go',
        '.go') {
        # The managed Go targets are injected like every managed target; the Go test code must stay visible, searched and watched.
        $text = New-VsCodeSettings -ManagedTarget 'go.work', '*/tests/*/go.mod'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json -AsHashtable
        $source = "$_/tests/widget/widget_test.go"
        foreach ($key in 'files.exclude', 'search.exclude', 'files.watcherExclude') {
            if ($json.Contains($key)) {
                foreach ($glob in @($json[$key].Keys | Where-Object { $json[$key][$_] -eq $true })) {
                    # A VS Code glob as a -like pattern ('**' and '*' both span '/'), on the path and its leading '**/' form.
                    $pattern = $glob -replace '\*\*', '*'
                    $source | Should -Not -BeLike $pattern -Because "$key '$glob' would hide $source"
                    "x/$source" | Should -Not -BeLike $pattern -Because "$key '$glob' would hide $source"
                }
            }
        }
        $filters = @(if ($json.Contains('gopls') -and $json['gopls'].Contains('build.directoryFilters')) {
                $json['gopls']['build.directoryFilters']
            })
        @($filters | Where-Object { $_ -like '-*' -and $source -like (($_.Substring(1) -replace '\*\*', '*') + '*') }) |
            Should -BeNullOrEmpty
        $json['search.exclude']['*/tests/*/go.mod'] | Should -BeTrue
    }
}
