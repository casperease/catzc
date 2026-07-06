Describe 'New-VSCodeSettings' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam (ADR-TEST:2): a small fixture registry with an authored
        # search.exclude carrying an explicit un-exclude (false) that injection must not override.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [pscustomobject]@{
                settings = [ordered]@{
                    'editor.tabSize' = 4
                    'search.exclude' = [ordered]@{
                        'automation/.vendor'   = $true
                        'keep/searchable.psd1' = $false
                    }
                }
            }
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

    It 'lets an authored entry win over an injected key of the same name' {
        $text = New-VSCodeSettings -ManagedTarget 'keep/searchable.psd1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'keep/searchable.psd1' | Should -BeFalse -Because 'an explicit authored un-exclude must survive injection'
    }

    It 'creates the search.exclude map when the registry has none' {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [pscustomobject]@{ settings = [ordered]@{ 'editor.tabSize' = 2 } }
        }
        $text = New-VSCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
    }
}

Describe 'New-VSCodeSettings — real vscode-settings.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry to valid settings JSON with the analyzer wiring intact' {
        $text = New-VSCodeSettings -ManagedTarget 'importer.ps1'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.'powershell.scriptAnalysis.settingsPath' | Should -Be './automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
        $json.'search.exclude'.'importer.ps1' | Should -BeTrue
        # The authored un-exclude of the analyzer source must survive rendering verbatim.
        $json.'search.exclude'.'automation/.internal/assets/PSScriptAnalyzerSettings.psd1' | Should -BeFalse
    }
}
