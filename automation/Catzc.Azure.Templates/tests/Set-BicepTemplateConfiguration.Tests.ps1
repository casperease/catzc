# cspell:ignore toolong gmweutstsmplst alweutstsmplst
# These are L0 'logic' tests (mocked config/discovery, no real az/cspell) — they are NOT L2 and should not
# be: nothing here launches an external tool. They were merely SLOW for an L0 tier, because the original
# BeforeEach gave EVERY test a fresh root ([Guid] dir). Discovery keys its session cache on the root, so a
# new root per test was a guaranteed cache miss — a full 8-template re-discovery every test, triggered at
# parameter binding ([ValidateScript] on -Template runs Get-BicepTemplateNames) before the body ever runs.
# That cold discovery costs ~1s here because Pester's Mock interception of Get-BicepTemplatesRoot inflates it
# ~6x (165ms unmocked -> ~1s mocked). Both contexts now share ONE copy + ONE discovery (BeforeAll), keeping
# the cache warm:
#   - 'validation and read-only' tests never mutate the tree.
#   - 'writes' tests each target a DISTINCT config path, so the shared tree never causes interference.
Describe 'Set-BicepTemplateConfiguration' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureTemplates = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'

        # The tool/config boundary is mocked once for the whole block — Get-BicepTemplatesRoot reads the
        # current $script:templatesRoot at call time, so each context just repoints that variable.
        Mock Get-BicepTemplatesRoot { $script:templatesRoot } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'validation and read-only' {
        # None of these write to the tree, so one copy + one discovery is shared across all of them.
        BeforeAll {
            # FRESH, UNIQUE root under $TestDrive (Pester auto-cleans it): a unique dir is never re-deleted
            # mid-run, so it can't race a concurrent file scanner (on-access AV / the search indexer) holding
            # a just-copied file open and intermittently throwing "used by another process". Scratch lives in
            # temp, not out/ (docs/adr/repository/dedicated-output-directory.md, ADR-OUTDIR:3).
            # Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: ~15x faster per tree here.
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Clear the caches ONCE so discovery re-derives against the fresh copy; then leave them warm —
            # these tests never mutate the tree, so re-discovering per test would be wasted work.
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
        }

        It 'DryRun returns the planned content without writing' {
            $result = Set-BicepTemplateConfiguration sample delta -Subscription core_upper -Parameters @{ storageAccountName = 'z' } -DryRun
            $result.Written | Should -BeFalse
            $result.Content | Should -Match 'z'
            $result.Path | Should -Not -Exist
        }

        It 'throws on an undefined environment' {
            { Set-BicepTemplateConfiguration sample zzz -Parameters @{ a = 'b' } } | Should -Throw '*not defined in azure.yml*'
        }

        It 'throws on empty parameters' {
            { Set-BicepTemplateConfiguration sample alpha -Parameters @{} } | Should -Throw '*cannot be empty*'
        }

        It 'throws on an invalid slot' {
            { Set-BicepTemplateConfiguration sample alpha -Slot 'toolong' -Parameters @{ a = 'b' } } | Should -Throw '*1-3 lowercase*'
        }

        It 'throws on an undefined subscription' {
            { Set-BicepTemplateConfiguration sample-customer alpha -Subscription zzz -Parameters @{ a = 'b' } } | Should -Throw '*not a defined subscription*'
        }

        It 'throws when the subscription does not serve the environment' {
            # core_lower serves alpha/beta/subn — not gamma.
            { Set-BicepTemplateConfiguration sample gamma -Subscription core_lower -Parameters @{ a = 'b' } } | Should -Throw '*does not serve*'
        }
    }

    Context 'writes' {
        # Each test writes to a DISTINCT path (sample/core_upper/gamma, sample/core_upper/delta,
        # sample/core_lower/alpha, sample-customer/acme_lower/alpha), so a single shared writable copy never
        # causes interference and the order of the tests does not matter. One copy + ONE discovery (BeforeAll)
        # keeps the discovery cache warm — a fresh per-test root would defeat the cache and pay a full cold
        # re-discovery every test (discovery is filesystem-bound — see Get-BicepTemplates). See the read-only
        # BeforeAll for the unique-dir / AV-race rationale.
        BeforeAll {
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Clear the caches ONCE so discovery re-derives against the fresh copy, then leave them warm.
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
        }

        It 'creates a new config file for a new environment under the subscription folder' {
            # core_upper serves gamma.
            $result = Set-BicepTemplateConfiguration sample gamma -Subscription core_upper -Parameters @{ storageAccountName = 'gmweutstsmplst' }
            $result.Written | Should -BeTrue
            $result.Path | Should -Exist
            $result.Path | Should -Match 'configuration[\\/]core_upper[\\/]gamma\.yml'
            $configuration = Get-Content $result.Path -Raw | ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'gmweutstsmplst'
        }

        It 'merges into an existing config, preserving other parameters' {
            Set-BicepTemplateConfiguration sample alpha -Subscription core_lower -Parameters @{ keyVaultName = 'al-weu-kv' } | Out-Null
            $configuration = Get-Content (Join-Path $script:templatesRoot 'sample/configuration/core_lower/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.keyVaultName.value | Should -Be 'al-weu-kv'
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweutstsmplst'
        }

        It 'is idempotent — two identical writes leave identical content' {
            # delta (not gamma) so this shares the BeforeAll tree with the 'creates' test without colliding.
            $first = Set-BicepTemplateConfiguration sample delta -Subscription core_upper -Parameters @{ storageAccountName = 'x' }
            $second = Set-BicepTemplateConfiguration sample delta -Subscription core_upper -Parameters @{ storageAccountName = 'x' }
            $second.Content | Should -Be $first.Content
        }

        It 'writes under the subscription subdir' {
            $result = Set-BicepTemplateConfiguration sample-customer alpha -Subscription acme_lower -Parameters @{ storageAccountName = 'y' }
            $result.Path | Should -Match 'configuration[\\/]acme_lower[\\/]alpha\.yml'
            $result.Path | Should -Exist
        }
    }
}
