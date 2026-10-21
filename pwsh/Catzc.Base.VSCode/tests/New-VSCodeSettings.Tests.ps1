<#
---
catzc:
  immutable:
    with_body_sha: "93733d1d09cd"
  edges:
    docs: "[New-VSCodeSettings.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-vs-code/tests/New-VSCodeSettings.Tests.ps1.md)"
    code: pwsh/Catzc.Base.VSCode/New-VSCodeSettings.ps1
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---
#>

# cspell:ignore gopls  -- the Go language server and its VS Code settings key
Describe 'New-VsCodeSettings' -Tag 'L0', 'logic' {
    BeforeAll {
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
        $json.'search.exclude'.'keep/searchable.psd1' | Should -BeFalse -Because 'an explicit authored un-exclude must survive injection'
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

    It 'hides no Go test source from the explorer, search, the watcher, or gopls, for the <_>/ root' -ForEach @('go', '.go') {
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
        @($filters | Where-Object { $_ -like '-*' -and $source -like (($_.Substring(1) -replace '\*\*', '*') + '*') }) | Should -BeNullOrEmpty
        $json['search.exclude']['*/tests/*/go.mod'] | Should -BeTrue
    }
}
