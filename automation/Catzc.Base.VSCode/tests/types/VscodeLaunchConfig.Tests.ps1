<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/tests/types/VscodeLaunchConfig.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.VSCode
    relatives:
      source: automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
---
#>

Describe 'Catzc.Base.VSCode.VscodeLaunchConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:valid = {
            [ordered]@{
                version        = '0.2.0'
                configurations = @(
                    [ordered]@{ name = 'Fixture'; type = 'PowerShell'; request = 'launch' }
                )
            }
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.VSCode.VscodeLaunchConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the VscodeLaunchConfig constructor to throw'
        }
    }

    It 'accepts a well-formed registry' {
        $raw = & $script:valid
        $raw['configurations'][0]['script'] = 'widget.ps1'
        $config = [Catzc.Base.VSCode.VscodeLaunchConfig]::new($raw)
        $config.version | Should -Be '0.2.0'
        $config.configurations[0].name | Should -Be 'Fixture'
        @($config.configurations[0].fields.Keys) | Should -Be @('name', 'type', 'request', 'script')
    }

    It 'throws when version is missing or blank' {
        $config = & $script:valid
        $config.Remove('version')
        Get-ViolationMessage $config | Should -BeLike "*'version' must be a non-empty string*"
    }

    It 'throws when configurations is missing or empty' {
        Get-ViolationMessage ([ordered]@{ version = '0.2.0'; configurations = @() }) | Should -BeLike '*non-empty list of launch profiles*'
    }

    It 'throws when a profile lacks name, type, or request' {
        $config = & $script:valid
        $config['configurations'] = @([ordered]@{ name = 'X'; type = 'PowerShell' })
        Get-ViolationMessage $config | Should -BeLike "*missing a non-empty 'request'*"
    }

    It 'throws on duplicate profile names' {
        $config = & $script:valid
        $config['configurations'] = @(
            [ordered]@{ name = 'Same'; type = 'PowerShell'; request = 'launch' }
            [ordered]@{ name = 'Same'; type = 'PowerShell'; request = 'attach' }
        )
        Get-ViolationMessage $config | Should -BeLike "*duplicate configuration name 'Same'*"
    }

    It 'reports every violation in one throw, including an unknown key and a non-mapping entry' {
        $message = Get-ViolationMessage ([ordered]@{ widget = 1; configurations = @('gadget') })
        $message | Should -BeLike "*unknown top-level key 'widget'*"
        $message | Should -BeLike "*'version' must be a non-empty string*"
        $message | Should -BeLike '*each configurations entry must be a mapping*'
    }
}
