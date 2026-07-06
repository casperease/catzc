Describe 'Get-AzureFamilySubscription' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
    # identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves the family member that serves a standard environment' {
        Get-AzureFamilySubscription core alpha | Should -Be 'core_lower'
        Get-AzureFamilySubscription core gamma | Should -Be 'core_upper'
    }

    It 'resolves the family member that serves an identity environment' {
        Get-AzureFamilySubscription core subn | Should -Be 'core_lower'
        Get-AzureFamilySubscription core subp | Should -Be 'core_upper'
        Get-AzureFamilySubscription acme subn | Should -Be 'acme_lower'
    }

    It 'resolves a one-member family to that member' {
        Get-AzureFamilySubscription cross_shared alpha | Should -Be 'cross_shared'
    }

    It 'throws when no family member serves the environment, naming what they do serve' {
        # globex has one member serving alpha + subn only.
        { Get-AzureFamilySubscription globex gamma } |
            Should -Throw "*no subscription serving environment 'gamma'*"
    }

    It 'throws on an unknown family' {
        { Get-AzureFamilySubscription nonexistent alpha } | Should -Throw '*Unknown family*'
    }
}
