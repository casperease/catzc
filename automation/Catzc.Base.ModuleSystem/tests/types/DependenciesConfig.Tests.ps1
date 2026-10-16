<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/types/DependenciesConfig.Tests.ps1
    folder: tests/types
    name: dependencies-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Catzc.Base.ModuleSystem.DependenciesConfig' -Tag 'L0' {
    BeforeAll {
        # Constructs the type; a violation surfaces as the inner ArgumentException's message.
        function New-DependenciesConfig {
            param($Raw)
            [Catzc.Base.ModuleSystem.DependenciesConfig]::new($Raw)
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] (New-DependenciesConfig $Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the DependenciesConfig constructor to throw'
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes a valid acyclic config' {
            $config = New-DependenciesConfig @{ modules = [ordered]@{ A = @('B'); B = @() } }
            @($config.modules['A']) | Should -Be @('B')
            @($config.modules.Keys) | Should -Be @('A', 'B')
            $config.groups.Count | Should -Be 0
        }

        It 'allows a declared module with no dependencies' {
            $config = New-DependenciesConfig @{ modules = [ordered]@{ A = @(); B = $null } }
            @($config.modules['A']).Count | Should -Be 0
            @($config.modules['B']).Count | Should -Be 0
        }

        It 'throws when a dependency target is not declared' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @('B') } } | Should -BeLike '*not declared in configuration*'
        }

        It 'throws on a two-way cycle' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @('B'); B = @('A') } } | Should -BeLike '*dependency cycle: A -> B -> A*'
        }

        It 'throws on a longer cycle' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @('B'); B = @('C'); C = @('A') } } | Should -BeLike '*cycle*'
        }

        It 'throws on a self-dependency' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @('A') } } | Should -BeLike '*itself*'
        }

        It 'throws when a module maps to a single string instead of a list' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = 'B'; B = @() } } | Should -BeLike '*must map to a list*'
        }

        It 'throws when the modules key is missing' {
            Get-ViolationMessage @{} | Should -BeLike "*'modules'*"
        }

        It 'throws on an unknown top-level key' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @() }; widget = 1 } | Should -BeLike "*unknown top-level key 'widget'*"
        }

        It 'throws when an entry in a list is not a name' {
            Get-ViolationMessage @{ modules = [ordered]@{ A = @('B', ''); B = @() } } | Should -BeLike '*not a name*'
        }

        It 'reports every violation in one throw' {
            $message = Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = @('M1') }
                    modules = [ordered]@{ A = @('A'); B = 'C'; D = @('Nope') }
                })
            $message | Should -BeLike '*map of member modules*'
            $message | Should -BeLike "*module 'A' declares a dependency on itself*"
            $message | Should -BeLike "*module 'B' must map to a list*"
            $message | Should -BeLike "*'Nope', which is not declared*"
        }
    }

    Context 'groups (fixture configs)' -Tag 'logic' {
        It 'passes a valid config with a group and a module pinning it' {
            $config = New-DependenciesConfig ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @(); M2 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                })
            $config.groups['G'].name | Should -Be 'G'
            @($config.groups['G'].members.Keys) | Should -Be @('M1', 'M2')
            @($config.groups['G'].members['M2']) | Should -Be @('M1')
        }

        It 'lets a module pin a group name as a dependency target' {
            { New-DependenciesConfig ([ordered]@{
                        groups  = [ordered]@{ G = [ordered]@{ M1 = @() } }
                        modules = [ordered]@{ A = @('G', 'B'); B = @() }
                    }) } | Should -Not -Throw
        }

        It 'throws when a group member depends on a non-member' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('Outsider') } }
                    modules = [ordered]@{ A = @('G') }
                }) | Should -BeLike '*not a member of group*'
        }

        It 'throws on a self-dependency inside a group' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                }) | Should -BeLike '*itself*'
        }

        It 'throws on a cycle inside a group' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @('M2'); M2 = @('M1') } }
                    modules = [ordered]@{ A = @('G') }
                }) | Should -BeLike "*group 'G' dependency cycle*"
        }

        It 'throws when a group maps to a list instead of a member map' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = @('M1', 'M2') }
                    modules = [ordered]@{ A = @('G') }
                }) | Should -BeLike '*map of member modules*'
        }

        It 'throws when a group member maps to a single string' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @(); M2 = 'M1' } }
                    modules = [ordered]@{ A = @('G') }
                }) | Should -BeLike "*member 'M2' must map to a list of member modules*"
        }

        It 'throws when a module depends on a name that is neither a module nor a group' {
            Get-ViolationMessage ([ordered]@{
                    groups  = [ordered]@{ G = [ordered]@{ M1 = @() } }
                    modules = [ordered]@{ A = @('Nope') }
                }) | Should -BeLike '*not declared in configuration*'
        }
    }

    Context 'integrity (shipped config)' -Tag 'integrity' {
        It 'the shipped dependencies.yml loads and validates' {
            $config = Get-Config -Config dependencies
            $config | Should -BeOfType ([Catzc.Base.ModuleSystem.DependenciesConfig])
            $config.modules.Count | Should -BeGreaterThan 0
        }
    }
}
