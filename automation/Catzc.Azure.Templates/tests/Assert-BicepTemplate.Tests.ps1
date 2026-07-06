# cspell:ignore brkn
Describe 'Assert-BicepTemplate' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixtureTemplates = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'

        # Reset the caches ONCE (not per test): the mocked config is the SAME fixture azure.yml for every
        # test, so clearing $configCache in BeforeEach only forced a needless cold re-parse (~65ms/test).
        # Cleared once here drops any real-config entry a prior test file may have left; the fixture config
        # then stays warm across this block. (Assert-BicepTemplate never calls Get-BicepTemplates, but we
        # drop any stale template-cache entry too, for good measure.)
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }

        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'valid templates (read-only)' {
        # These never mutate the tree, so they validate the COMMITTED fixtures directly — no per-test
        # Copy-Directory (~41ms each, ADR-TEST:19). Assert-BicepTemplate only reads; it cannot corrupt them.
        BeforeAll {
            Mock Get-BicepTemplatesRoot { $script:fixtureTemplates } -ModuleName Catzc.Azure.Templates
        }

        It 'passes for a valid non-slotted template' {
            { Assert-BicepTemplate sample } | Should -Not -Throw
        }

        It 'passes for a template whose configs all carry slots' {
            { Assert-BicepTemplate sample-indexed } | Should -Not -Throw
        }

        It 'passes for a valid subscription-kind template' {
            { Assert-BicepTemplate sample-subenv } | Should -Not -Throw
        }

        It 'throws for an unknown template' {
            { Assert-BicepTemplate does-not-exist } | Should -Throw '*not found*'
        }
    }

    Context 'violations (each corrupts the tree)' {
        BeforeEach {
            # Validate against a writable COPY of the fixtures so a test can introduce a deliberate violation
            # without touching the committed fixtures. Each of these tests corrupts 'sample' (or adds a broken
            # template) differently and expects a specific throw, so they collide — a FRESH, UNIQUE root per
            # test under $TestDrive (Pester auto-cleans it) is required. A unique dir is also never re-deleted
            # mid-run, so it cannot race a concurrent file scanner (on-access AV / search indexer) holding the
            # just-copied PrePost.psm1 open and intermittently throwing "used by another process". Scratch
            # lives in temp, not out/ (docs/adr/repository/dedicated-output-directory.md, ADR-OUTDIR:3).
            # Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: ~15x faster per tree here.
            $script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())
            Copy-Directory $script:fixtureTemplates $script:templatesRoot

            Mock Get-BicepTemplatesRoot { $script:templatesRoot } -ModuleName Catzc.Azure.Templates
        }

        It 'accepts a template that MIXES slotted and non-slotted configs (slot is per-config)' {
            # Add a slotted config beside sample's existing non-slotted ones — no longer a violation.
            # beta resolves to core_lower, so beta-001 is a valid slotted root config.
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/beta-001.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Not -Throw
        }

        It 'reports an env-class violation (per-subscription env on a standard template)' {
            # subn is a per-subscription env; placing it on a standard template trips the env-class rule.
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/subn.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*environment_kind*'
        }

        It 'reports a config whose coordinate resolves to no subscription' {
            # globex is a defined customer with NO subscription in the fixture azure.yml, so a
            # configuration/globex/ config can never resolve to a subscription id.
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'sample/configuration/globex')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/globex/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*cannot be resolved*'
        }

        It 'reports a parameter the template does not declare' {
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/beta-001.yml'), "ParametersFile:`n  parameters:`n    bogusParam:`n      value: 1")
            { Assert-BicepTemplate sample } | Should -Throw '*bogusParam*'
        }

        It 'reports a subfolder that is not a customer key' {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'sample/configuration/zzz')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/zzz/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate sample } | Should -Throw '*not a customer key*'
        }

        It 'reports a missing main.bicep' {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:templatesRoot 'broken/configuration')) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'broken/options.yml'), 'short_name: brkn')
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'broken/configuration/alpha.yml'), "ParametersFile:`n  parameters: {}")
            { Assert-BicepTemplate broken } | Should -Throw '*main.bicep*'
        }

        It 'collects multiple violations into one consolidated error' {
            # One config trips two rules at once: a per-subscription env on a standard template (env-class)
            # AND a parameter main.bicep does not declare.
            [System.IO.File]::WriteAllText((Join-Path $script:templatesRoot 'sample/configuration/subn.yml'), "ParametersFile:`n  parameters:`n    bogusParam:`n      value: 1")
            $err = $null
            try {
                Assert-BicepTemplate sample
            }
            catch {
                $err = $_.Exception.Message
            }
            $err | Should -Match 'environment_kind'
            $err | Should -Match 'bogusParam'
        }
    }
}
