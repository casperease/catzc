<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/tests/types/VscodeSettingsConfig.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.VSCode
    relatives:
      page: docs/references/automation/catzc-base-vscode/tests/types/VscodeSettingsConfig.Tests.ps1.md
      source: automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
---
#>

Describe 'Catzc.Base.VSCode.VscodeSettingsConfig' -Tag 'L0' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodeSettingsConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodeSettingsConfig constructor to throw'
        }
    }

    Context 'logic' -Tag 'logic' {
        It 'keeps the settings as an ordered passthrough map' {
            $config = [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{
                        'widget.fontSize' = 14
                        '[gadget]'        = [ordered]@{ 'editor.tabSize' = 4 }
                        'search.exclude'  = [ordered]@{ 'tst/**' = $true; 'tst/keep.psd1' = $false }
                    }
                })
            @($config.settings.Keys) | Should -Be @('widget.fontSize', '[gadget]', 'search.exclude')
            $config.settings['widget.fontSize'] | Should -Be 14
            $config.settings['[gadget]']['editor.tabSize'] | Should -Be 4
            $config.settings.IsReadOnly | Should -BeTrue
        }

        It 'throws when settings is missing or empty' {
            Get-ViolationMessage ([ordered]@{}) | Should -BeLike "*'settings' must be a non-empty map*"
            Get-ViolationMessage ([ordered]@{ settings = [ordered]@{} }) | Should -BeLike "*'settings' must be a non-empty map*"
        }

        It 'throws when a search.exclude entry is not a boolean' {
            $raw = [ordered]@{ settings = [ordered]@{ 'search.exclude' = [ordered]@{ 'tst/**' = 'yes' } } }
            Get-ViolationMessage $raw | Should -BeLike "*'search.exclude' entry 'tst/``*``*' must be true or false*"
        }

        It 'reports every violation in one throw: an unknown key, a scalar language override, and a scalar search.exclude' {
            $message = Get-ViolationMessage ([ordered]@{
                    widget   = 1
                    settings = [ordered]@{ '[gadget]' = 'tst'; 'search.exclude' = 'tst/**' }
                })
            $message | Should -BeLike "*unknown top-level key 'widget'*"
            $message | Should -BeLike "*language override '``[gadget``]' must be a map of settings*"
            $message | Should -BeLike "*'search.exclude' must be a map of glob -> true/false*"
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped vscode-settings.yml loads and validates' {
            $config = Get-Config -Config vscode-settings
            $config | Should -BeOfType ([Catzc.Base.VSCode.VscodeSettingsConfig])
            $config.settings['search.exclude'] | Should -Not -BeNullOrEmpty
        }
    }
}
