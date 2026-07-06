# The derived globsets (ADR-PROTGLOB:7): folder = module = set (readme-kebab name), reserved infra scopes,
# one shared name space with the declared registry, no trigger files (they never enter GlobsConfig).
Describe 'Get-ModuleGlobSet' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' }
            'Catzc.Fake.Beta'  = @{ Public = 'Get-Beta' }
        }
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ automation = @{ description = 'd'; include = @('automation/**'); exclude = @('.sha-markers/**') } }
            })
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'derives one kebab-named set per module folder, matching the module tree' {
        $set = Get-ModuleGlobSet -Name Catzc.Base.Alpha
        $set.Name | Should -Be 'catzc-base-alpha'
        $set.Matches('automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        $set.Matches('automation/Catzc.Base.Alpha/tests/Get-Alpha.Tests.ps1') | Should -BeTrue
        $set.Matches('automation/Catzc.Fake.Beta/Get-Beta.ps1') | Should -BeFalse
    }

    It 'resolves a set by folder name and by kebab name to the same instance' {
        $byFolder = Get-ModuleGlobSet -Name Catzc.Fake.Beta
        $byKebab = Get-ModuleGlobSet -Name catzc-fake-beta
        $byKebab.Name | Should -Be $byFolder.Name
    }

    It 'derives the reserved infra scopes' -ForEach @(
        @{ reserved = 'internal'; sample = 'automation/.internal/Catzc.Internal.Loader.psm1' }
        @{ reserved = 'vendor'; sample = 'automation/.vendor/Pester/5.7.1/Pester.psd1' }
        @{ reserved = 'compiled'; sample = 'automation/.compiled/Catzc.Types.abc12345.dll' }
        @{ reserved = 'scriptanalyzer'; sample = 'automation/.scriptanalyzer/NoRawVsoCommand.psm1' }
    ) {
        $set = Get-ModuleGlobSet -Name $reserved
        $set.Name | Should -Be $reserved
        $set.Matches($sample) | Should -BeTrue
    }

    It 'returns every derived set exactly once when no name is given' {
        $all = @(Get-ModuleGlobSet)
        ($all.Name | Sort-Object) | Should -Be (@('catzc-base-alpha', 'catzc-fake-beta', 'compiled', 'internal', 'scriptanalyzer', 'vendor'))
    }

    It 'throws a named error on an unknown name' {
        { Get-ModuleGlobSet -Name nope } | Should -Throw "*No derived globset for 'nope'*"
    }

    It 'rejects a declared globset that shadows a derived module name' {
        $shadowing = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ 'catzc-base-alpha' = @{ description = 'd'; include = @('docs/**') } }
            })
        Mock Get-Config { $shadowing } -ModuleName Catzc.Base.Globs
        { Get-ModuleGlobSet } | Should -Throw '*shadows the derived set*'
    }
}

# The reserved-name guard lives in the registry type itself (ADR-PROTGLOB:7).
Describe 'GlobsConfig reserved names' -Tag 'L0', 'logic' {
    It 'rejects a declared set named after a reserved infra scope' {
        {
            [Catzc.Base.Globs.GlobsConfig]::new(@{
                    globsets = @{ vendor = @{ description = 'd'; include = @('docs/**') } }
                })
        } | Should -Throw '*reserved*'
    }
}
