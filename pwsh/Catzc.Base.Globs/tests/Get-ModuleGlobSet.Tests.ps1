<#
---
catzc:
  immutable:
    with_body_sha: a0c6957a1a68
  edges:
    docs: "[Get-ModuleGlobSet.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
    cites:
      - ADR-AUTO-BASH-ONEBASHROOT
      - ADR-AUTO-GO-ONEGOROOT
      - ADR-AUTO-PY-ONEPYTHONROOT
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-PROTGLOB-DERIVEDMODULEGLOBSETS
      - DDR-ASPECT
---
#>

Describe 'Get-ModuleGlobSet' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:fake = New-FakeRepositoryRoot -Modules @{
            'Catzc.Base.Alpha' = @{ Public = 'Get-Alpha' }
            'Catzc.Fake.Beta'  = @{ Public = 'Get-Beta' }
        } -Files @{
            ((Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Alpha.psm1') = 'function Test-InternalAlpha {}'
            ((Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Beta.psm1')  = 'function Test-InternalBeta {}'
        }
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = @{ widget = @{ description = 'd'; layer = 'loose-fileset'; include = @('src/**') } }
            })
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-Config { [Catzc.Base.Languages.GoConfig]::new(@{ root = 'go' }) } -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'go' }
        Mock Get-Config {
            [Catzc.Base.Languages.PythonConfig]::new(@{ root = 'python'; dependencies = @{ pyright = '1.1.414'; pytest = '9.1.1'; ruff = '0.17.0' } })
        } -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'python' }
        Mock Get-Config {
            [Catzc.Base.Languages.BashConfig]::new(@{ root = 'bash'; bats_version = '1.2.3'; bats_sha256 = ('a' * 64) })
        } -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'bash' }
        Mock Get-Config {
            [Catzc.Base.Languages.LanguagesConfig]::new([ordered]@{ languages = [ordered]@{
                        python = [ordered]@{ extensions = @('.py'); no_formatter = 'never'; naming = [ordered]@{ folder = 'snake' } }
                        go     = [ordered]@{ extensions = @('.go'); no_formatter = 'never'; naming = [ordered]@{ folder = 'flat' } }
                        bash   = [ordered]@{ extensions = @('.sh'); no_formatter = 'never'; naming = [ordered]@{ folder = 'kebab' } }
                    }
                })
        } -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'languages' }
        # The fake root is not the loaded code root, so the run mode reads 'build'; the guard is the seam.
        Mock Assert-SourceTree -ModuleName Catzc.Base.Globs { }
    }

    It 'derives live/tests aspect sets per module folder, partitioning the module tree (DDR-ASPECT)' {
        $aspects = @(Get-ModuleGlobSet -Name Catzc.Base.Alpha)
        ($aspects.Name | Sort-Object) | Should -Be @('catzc-base-alpha-live', 'catzc-base-alpha-tests')
        $live = $aspects | Where-Object Name -eq 'catzc-base-alpha-live'
        $tests = $aspects | Where-Object Name -eq 'catzc-base-alpha-tests'
        # live claims the runtime surface, not the tests folder; tests is the non-live catch-all
        $live.Matches((Get-CatzcModulesFolder) + '/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeTrue
        $live.Matches((Get-CatzcModulesFolder) + '/Catzc.Base.Alpha/tests/Get-Alpha.Tests.ps1') | Should -BeFalse
        $tests.Matches((Get-CatzcModulesFolder) + '/Catzc.Base.Alpha/tests/Get-Alpha.Tests.ps1') | Should -BeTrue
        $live.Matches((Get-CatzcModulesFolder) + '/Catzc.Fake.Beta/Get-Beta.ps1') | Should -BeFalse
    }

    It 'puts the module''s Go, Python and Bash test folders in its tests aspect, each in its language''s folder case, never in live (ADR-AUTO-GO-ONEGOROOT, ADR-AUTO-PY-ONEPYTHONROOT, ADR-AUTO-BASH-ONEBASHROOT)' {
        $aspects = @(Get-ModuleGlobSet -Name Catzc.Base.Alpha)
        $live = $aspects | Where-Object Name -eq 'catzc-base-alpha-live'
        $tests = $aspects | Where-Object Name -eq 'catzc-base-alpha-tests'
        $tests.Matches('go/tests/catzcbasealpha/alpha_test.go') | Should -BeTrue
        $live.Matches('go/tests/catzcbasealpha/alpha_test.go') | Should -BeFalse
        $tests.Matches('python/tests/catzc_base_alpha/test_alpha.py') | Should -BeTrue
        $live.Matches('python/tests/catzc_base_alpha/test_alpha.py') | Should -BeFalse
        $tests.Matches('bash/tests/catzc-base-alpha/alpha.bats') | Should -BeTrue
        $live.Matches('bash/tests/catzc-base-alpha/alpha.bats') | Should -BeFalse
        $tests.Matches('go/tests/catzcfakebeta/beta_test.go') | Should -BeFalse
        $tests.Matches('python/tests/catzc-base-alpha/test_alpha.py') | Should -BeFalse
    }

    It 'resolves a set by folder name and by kebab name to the same instance' {
        $byFolder = Get-ModuleGlobSet -Name Catzc.Fake.Beta
        $byKebab = Get-ModuleGlobSet -Name catzc-fake-beta
        $byKebab.Name | Should -Be $byFolder.Name
    }

    It 'derives one single-file set per internal .psm1 module, by module name and kebab name' {
        $set = Get-ModuleGlobSet -Name Catzc.Internal.Alpha
        $set.Name | Should -Be 'catzc-internal-alpha'
        $set.Matches((Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Alpha.psm1') | Should -BeTrue
        $set.Matches((Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Beta.psm1') | Should -BeFalse
        $set.Matches((Get-CatzcModulesFolder) + '/.internal/tests/Test-Something.Tests.ps1') | Should -BeFalse
        (Get-ModuleGlobSet -Name catzc-internal-alpha).Name | Should -Be $set.Name
    }

    It 'derives the reserved infra scopes' -ForEach @(
        @{ reserved = 'internal'; sample = (Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Loader.psm1' }
        @{ reserved = 'vendor'; sample = (Get-CatzcModulesFolder) + '/.vendor/Pester/5.7.1/Pester.psd1' }
        @{ reserved = 'compiled'; sample = (Get-CatzcModulesFolder) + '/.compiled/Catzc.Types.abc12345.dll' }
        @{ reserved = 'scriptanalyzer'; sample = (Get-CatzcModulesFolder) + '/.scriptanalyzer/NoRawVsoCommand.psm1' }
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
        $leftovers.OwnMatches((Get-CatzcModulesFolder) + '/Catzc.Base.Alpha/Get-Alpha.ps1') | Should -BeFalse
        # dot-folder infrastructure is the umbrellas' territory, not the catch-all's
        $leftovers.OwnMatches((Get-CatzcModulesFolder) + '/.vendor/Pester/5.7.1/Pester.psd1') | Should -BeFalse
        $leftovers.OwnMatches((Get-CatzcModulesFolder) + '/.internal/Catzc.Internal.Alpha.psm1') | Should -BeFalse
        # a stray file at pwsh/'s root is what the catch-all is for
        $leftovers.OwnMatches((Get-CatzcModulesFolder) + '/stray.ps1') | Should -BeTrue
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

Describe 'GlobsConfig reserved names' -Tag 'L0', 'logic' {
    It 'rejects a declared set named after a reserved infra scope' {
        {
            [Catzc.Base.Globs.GlobsConfig]::new(@{
                    globsets = @{ vendor = @{ description = 'd'; layer = 'loose-fileset'; include = @('docs/**') } }
                })
        } | Should -Throw '*reserved*'
    }
}

Describe 'Get-ModuleGlobSet — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        { Get-ModuleGlobSet } | Should -Throw '*Get-ModuleGlobSet operates on the catzc source tree*'
    }
}
