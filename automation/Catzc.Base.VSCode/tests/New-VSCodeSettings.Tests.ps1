# cspell:ignore gopls  -- the Go language server and its VS Code settings key
Describe 'New-VSCodeSettings' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam
        # ([ADR-AUTO-PESTER#2](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester2)): a small
        # fixture registry with an authored
        # search.exclude carrying an explicit un-exclude (false) that injection must not override.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{
                        'editor.tabSize' = 4
                        'search.exclude' = [ordered]@{
                            'automation/.vendor'   = $true
                            'keep/searchable.psd1' = $false
                        }
                    }
                })
        }
    }

    It 'renders a JSONC header and valid JSON carrying the authored settings' {
        $text = New-VSCodeSettings
        $text | Should -Match '^// GENERATED FILE'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'editor.tabSize' | Should -Be 4
    }

    It 'completes search.exclude with every managed target' {
        $text = New-VSCodeSettings -ManagedTarget 'importer.ps1', '.editorconfig'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
        $json.'search.exclude'.'.editorconfig' | Should -BeTrue
        $json.'search.exclude'.'automation/.vendor' | Should -BeTrue
    }

    It 'sets each language''s editor formatter, merged into an authored [language] block whose own keys win' -Tag 'ADR-REPO-FORMAT#8' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{
                        '[widget]' = [ordered]@{ 'editor.wordWrap' = 'off' }
                        '[gadget]' = [ordered]@{ 'editor.defaultFormatter' = 'gadget.authored' }
                    }
                })
        }
        $text = New-VSCodeSettings -LanguageFormatter ([ordered]@{ widget = 'widget.engine'; gadget = 'gadget.engine'; sprocket = 'sprocket.engine' })
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'[widget]'.'editor.defaultFormatter' | Should -Be 'widget.engine'
        $json.'[widget]'.'editor.wordWrap' | Should -Be 'off'
        $json.'[gadget]'.'editor.defaultFormatter' | Should -Be 'gadget.authored'
        $json.'[sprocket]'.'editor.defaultFormatter' | Should -Be 'sprocket.engine'
    }

    It 'lets an authored entry win over an injected key of the same name' {
        $text = New-VSCodeSettings -ManagedTarget 'keep/searchable.psd1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'keep/searchable.psd1' | Should -BeFalse -Because 'an explicit authored un-exclude must survive injection'
    }

    It 'creates the search.exclude map when the registry has none' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{ settings = [ordered]@{ 'editor.tabSize' = 2 } })
        }
        $text = New-VSCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
    }

    It 'adds the machine-resolved settings after the authored ones, and the authored key wins' {
        $text = New-VSCodeSettings -MachineSetting @{ 'widget.root' = 'C:\widget'; 'editor.tabSize' = 8 }
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'widget.root' | Should -Be 'C:\widget'
        $json.'editor.tabSize' | Should -Be 4 -Because 'an authored setting wins over a machine-resolved one'
    }

    It 'leaves the cached config untouched when it completes search.exclude' {
        $fixture = [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                settings = [ordered]@{ 'search.exclude' = [ordered]@{ 'automation/.vendor' = $true } }
            })
        Mock Get-Config -ModuleName Catzc.Base.VSCode { $fixture }
        $null = New-VSCodeSettings -ManagedTarget 'importer.ps1'
        @($fixture.settings['search.exclude'].Keys) | Should -Be @('automation/.vendor')
    }
}

Describe 'New-VSCodeSettings — real vscode-settings.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry to valid settings JSON with the analyzer wiring intact' {
        $text = New-VSCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'powershell.scriptAnalysis.settingsPath' | Should -Be './automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
        # The authored un-exclude of the analyzer's settings file must survive rendering verbatim.
        $json.'search.exclude'.'automation/.internal/assets/PSScriptAnalyzerSettings.psd1' | Should -BeFalse
    }

    It 'hides no Go test source from the explorer, search, the watcher, or gopls, for the <_>/ root' -ForEach @('go', '.go') {
        # The managed Go targets (go.work and the generated go.mod files) are injected like every managed target;
        # the test code under either Go root must stay visible, searchable, watched, and loaded by gopls.
        $text = New-VSCodeSettings -ManagedTarget 'go.work', '*/tests/*/go.mod'
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
        @($filters | Where-Object { $_ -like '-*' -and $source -like (($_.Substring(1) -replace '\*\*', '*') + '*') }) | Should -BeNullOrEmpty
        $json['search.exclude']['*/tests/*/go.mod'] | Should -BeTrue
    }
}
