<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/types/ProfilesConfig.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/types/ProfilesConfig.Tests.ps1.md
      source: automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
---
#>

Describe 'Catzc.Base.ModuleSystem.ProfilesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.ModuleSystem.ProfilesConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the ProfilesConfig constructor to throw'
        }
    }

    It 'accepts a valid profiles map (including an empty seed)' {
        $config = [Catzc.Base.ModuleSystem.ProfilesConfig]::new([ordered]@{ profiles = [ordered]@{
                    minimal = @('Catzc.Base.Asserts')
                    azure   = @('Catzc.Azure.Cli', 'Catzc.Azure.Templates')
                    full    = @()
                }
            })
        @($config.profiles.Keys) | Should -Be @('minimal', 'azure', 'full')
        @($config.profiles['azure']) | Should -Be @('Catzc.Azure.Cli', 'Catzc.Azure.Templates')
        @($config.profiles['full']).Count | Should -Be 0
    }

    It 'throws when profiles is missing or empty' {
        Get-ViolationMessage ([ordered]@{}) | Should -BeLike '*profiles*'
        Get-ViolationMessage ([ordered]@{ profiles = [ordered]@{} }) | Should -BeLike '*non-empty*'
    }

    It 'throws on a non-snake_case profile name' {
        Get-ViolationMessage ([ordered]@{ profiles = [ordered]@{ 'Bad-Name' = @('Catzc.Base.Asserts') } }) | Should -BeLike '*snake_case*'
    }

    It 'throws when a profile is a single string, not a list' {
        Get-ViolationMessage ([ordered]@{ profiles = [ordered]@{ minimal = 'Catzc.Base.Asserts' } }) | Should -BeLike '*list of module names*'
    }

    It 'reports every violation in one throw, including an unknown key and a non-name entry' {
        $message = Get-ViolationMessage ([ordered]@{
                widget   = 1
                profiles = [ordered]@{ 'Bad-Name' = @('Catzc.Tst'); gadget = 'Catzc.Tst'; tst = @('') }
            })
        $message | Should -BeLike "*unknown top-level key 'widget'*"
        $message | Should -BeLike "*profile 'Bad-Name' is not snake_case*"
        $message | Should -BeLike "*profile 'gadget' must be a list*"
        $message | Should -BeLike "*profile 'tst' lists an entry that is not a module name*"
    }
}
