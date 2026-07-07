# The derived globsets (ADR-PROTGLOB:7): folder = module = set (readme-kebab name), one single-file set per
# internal .psm1 module, reserved infra scopes, one shared name space with the declared registry. Derived
# sets never enter GlobsConfig but scope protection and blast radius through the same Matches() machinery.
Describe 'Get-ModuleGlobSet' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' }
            'Catzc.Fake.Beta'  = @{ Public = 'Get-Beta' }
        } -Files @{
            'automation/.internal/Catzc.Internal.Alpha.psm1' = 'function Test-InternalAlpha {}'
            'automation/.internal/Catzc.Internal.Beta.psm1'  = 'function Test-InternalBeta {}'
        }
        # Neutral fixture globset name (widget), not the real 'automation' set (ADR-TEST:3); this declared
        # set only needs to exist so the shadow-check has a registry to compare the derived names against.
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ widget = @{ description = 'd'; layer = 'loose-fileset'; include = @('src/**') } }
            })
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'derives live/tests aspect sets per module folder, partitioning the module tree (ADR-ASPECT)' {
        $aspects = @(Get-ModuleGlobSet -Name Catzc.Base.Alpha)
        ($aspects.Name | Sort-Object) | Should -Be @('catzc-base-alpha-live', 'catzc-base-alpha-tests')
        $live = $aspects | Where-Object Name -eq 'catzc-base-alpha-live'
        $tests = $aspects | Where-Object Name -eq 'catzc-base-alpha-tests'
        # live claims the runtime surface, not the tests folder; tests is the non-live catch-all
        $live.Matches('automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        $live.Matches('automation/Catzc.Base.Alpha/tests/Get-Alpha.Tests.ps1') | Should -BeFalse
        $tests.Matches('automation/Catzc.Base.Alpha/tests/Get-Alpha.Tests.ps1') | Should -BeTrue
        $live.Matches('automation/Catzc.Fake.Beta/Get-Beta.ps1') | Should -BeFalse
    }

    It 'resolves a set by folder name and by kebab name to the same instance' {
        $byFolder = Get-ModuleGlobSet -Name Catzc.Fake.Beta
        $byKebab = Get-ModuleGlobSet -Name catzc-fake-beta
        $byKebab.Name | Should -Be $byFolder.Name
    }

    It 'derives one single-file set per internal .psm1 module, by module name and kebab name' {
        $set = Get-ModuleGlobSet -Name Catzc.Internal.Alpha
        $set.Name | Should -Be 'catzc-internal-alpha'
        $set.Matches('automation/.internal/Catzc.Internal.Alpha.psm1') | Should -BeTrue
        $set.Matches('automation/.internal/Catzc.Internal.Beta.psm1') | Should -BeFalse
        $set.Matches('automation/.internal/tests/Test-Something.Tests.ps1') | Should -BeFalse
        (Get-ModuleGlobSet -Name catzc-internal-alpha).Name | Should -Be $set.Name
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
        ($all.Name | Sort-Object) | Should -Be (@('catzc-base-alpha-live', 'catzc-base-alpha-tests', 'catzc-fake-beta-live', 'catzc-fake-beta-tests', 'catzc-internal-alpha', 'catzc-internal-beta', 'compiled', 'internal', 'module-leftovers', 'scriptanalyzer', 'vendor'))
    }

    It 'derives the module-leftovers catch-all — module layer, excluding every module folder and dot-folder' {
        $leftovers = Get-ModuleGlobSet -Name module-leftovers
        $leftovers.Layer | Should -Be 'module'
        # a file inside a real module folder is owned by that module, never the catch-all
        $leftovers.OwnMatches('automation/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeFalse
        # dot-folder infrastructure is the umbrellas' territory, not the catch-all's
        $leftovers.OwnMatches('automation/.vendor/Pester/5.7.1/Pester.psd1') | Should -BeFalse
        $leftovers.OwnMatches('automation/.internal/Catzc.Internal.Alpha.psm1') | Should -BeFalse
        # a stray file at automation/'s root is what the catch-all is for
        $leftovers.OwnMatches('automation/stray.ps1') | Should -BeTrue
    }

    It 'throws a named error on an unknown name' {
        { Get-ModuleGlobSet -Name nope } | Should -Throw "*No derived globset for 'nope'*"
    }

    It 'rejects a declared globset that shadows a derived module name' {
        $shadowing = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ 'catzc-base-alpha' = @{ description = 'd'; layer = 'loose-fileset'; include = @('docs/**') } }
            })
        Mock Get-Config { $shadowing } -ModuleName Catzc.Base.Globs
        { Get-ModuleGlobSet } | Should -Throw '*shadows the derived*'
    }
}

# The reserved-name guard lives in the registry type itself (ADR-PROTGLOB:7).
Describe 'GlobsConfig reserved names' -Tag 'L0', 'logic' {
    It 'rejects a declared set named after a reserved infra scope' {
        {
            [Catzc.Base.Globs.GlobsConfig]::new(@{
                    globsets = @{ vendor = @{ description = 'd'; layer = 'loose-fileset'; include = @('docs/**') } }
                })
        } | Should -Throw '*reserved*'
    }
}
