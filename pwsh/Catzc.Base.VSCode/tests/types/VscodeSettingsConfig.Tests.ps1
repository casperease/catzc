<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-vs-code/tests/types/VscodeSettingsConfig.Tests.ps1.md"
  warning: "Generated Header"
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

        It 'reads the hidden actions per menu, and none when it declares none' {
            $config = [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings       = [ordered]@{ 'editor.tabSize' = 4 }
                    hidden_actions = [ordered]@{ Widget = @('widget.add', 'widget.remove') }
                })
            @($config.hidden_actions['Widget']) | Should -Be @('widget.add', 'widget.remove')
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{ settings = [ordered]@{ 'editor.tabSize' = 4 } }).hidden_actions.Count | Should -Be 0
        }

        It 'throws when a hidden-actions menu names no command or is not a list' {
            $message = Get-ViolationMessage ([ordered]@{
                    settings       = [ordered]@{ 'editor.tabSize' = 4 }
                    hidden_actions = [ordered]@{ Widget = @(); Gadget = 'gadget.add' }
                })
            $message | Should -BeLike "*hidden_actions 'Widget' names no command*"
            $message | Should -BeLike "*hidden_actions 'Gadget' must be a list of command ids*"
        }

        It 'reads the carried settings with their owner keys, none by default, and refuses an entry without an owner' {
            $config = [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{
                    settings = [ordered]@{ 'editor.tabSize' = 4 }
                    carried  = [ordered]@{ 'widget.exclude' = 'gadget.owned' }
                })
            $config.carried['widget.exclude'] | Should -Be 'gadget.owned'
            [Catzc.Base.VSCode.VscodeSettingsConfig]::new([ordered]@{ settings = [ordered]@{ 'editor.tabSize' = 4 } }).carried.Count | Should -Be 0
            Get-ViolationMessage ([ordered]@{ settings = [ordered]@{ 'editor.tabSize' = 4 }; carried = [ordered]@{ 'widget.exclude' = '' } }) |
                Should -BeLike "*carried 'widget.exclude' must name the setting key*"
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
            $config.hidden_actions['ViewTitle'] | Should -Contain 'workbench.files.action.createFileFromExplorer'
        }
    }
}
