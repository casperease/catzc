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
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
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
            # temp, not out/ (docs/adr/repository/dedicated-output-directory.md, ADR-REPO-OUTDIR:3).
            # Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: ~15x faster per tree here.
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Clear the caches ONCE so discovery re-derives against the fresh copy, then WARM them here in
            # BeforeAll — not on the first test. The -Template [ValidateScript] runs Get-BicepTemplateNames
            # (-> Get-BicepTemplates) at parameter binding, so an unwarmed cache makes the first It pay a
            # full cold discovery (~6x inflated under Mock interception); warming here keeps that off the L0
            # gate. These tests never mutate the tree, so the cache stays valid for all of them (ADR-AUTO-TEST#19).
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
            Get-BicepTemplates | Out-Null
        }

        It 'DryRun returns the planned content without writing' {
            $result = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'z' } -DryRun
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

        It 'throws when -Customer is not a customer key in the catalogue' {
            { Set-BicepTemplateConfiguration sample-customer alpha -Customer zzz -Parameters @{ a = 'b' } } | Should -Throw '*not a customer key*'
        }

        It 'throws when the coordinate resolves to no subscription' {
            # globex is a defined customer but has no subscription in the fixture azure.yml.
            { Set-BicepTemplateConfiguration sample-customer alpha -Customer globex -Parameters @{ a = 'b' } } |
                Should -Throw '*cannot be resolved*'
        }
    }

    Context 'writes' {
        # Each test writes to a DISTINCT path (sample/gamma, sample/delta, sample/alpha,
        # sample-customer/acme/alpha), so a single shared writable copy never causes interference and the
        # order of the tests does not matter. One copy + ONE discovery (BeforeAll) keeps the discovery
        # cache warm — a fresh per-test root would defeat the cache and pay a full cold re-discovery every
        # test (discovery is filesystem-bound — see Get-BicepTemplates). See the read-only BeforeAll for
        # the unique-dir / AV-race rationale.
        BeforeAll {
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            # Clear the caches ONCE so discovery re-derives against the fresh copy, then WARM them here so the
            # first It in this context does not pay the cold parameter-binding discovery (see the read-only
            # context's BeforeAll). Writes target distinct config paths and never invalidate the templates
            # cache (session-scoped, ADR-AUTO-CACHE:6), so one warm-up serves every test.
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
            Get-BicepTemplates | Out-Null
        }

        It 'creates a new configuration-root config file for a new environment' {
            # gamma resolves to core_upper (the one non-customer subscription serving it).
            $result = Set-BicepTemplateConfiguration sample gamma -Parameters @{ storageAccountName = 'gmweutstsmplst' }
            $result.Written | Should -BeTrue
            $result.Path | Should -Exist
            $result.Path | Should -Match 'configuration[\\/]gamma\.yml'
            $configuration = Get-Content $result.Path -Raw | ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'gmweutstsmplst'
        }

        It 'merges into an existing config, preserving other parameters' {
            Set-BicepTemplateConfiguration sample alpha -Parameters @{ keyVaultName = 'al-weu-kv' } | Out-Null
            $configuration = Get-Content (Join-Path $script:templatesRoot 'sample/configuration/alpha.yml') -Raw | ConvertFrom-Yaml -Ordered
            $configuration.ParametersFile.parameters.keyVaultName.value | Should -Be 'al-weu-kv'
            $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweutstsmplst'
        }

        It 'is idempotent — two identical writes leave identical content' {
            # delta (not gamma) so this shares the BeforeAll tree with the 'creates' test without colliding.
            $first = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'x' }
            $second = Set-BicepTemplateConfiguration sample delta -Parameters @{ storageAccountName = 'x' }
            $second.Content | Should -Be $first.Content
        }

        It 'writes under the customer subfolder when -Customer is given' {
            $result = Set-BicepTemplateConfiguration sample-customer alpha -Customer acme -Parameters @{ storageAccountName = 'y' }
            $result.Path | Should -Match 'configuration[\\/]acme[\\/]alpha\.yml'
            $result.Path | Should -Exist
        }
    }
}
