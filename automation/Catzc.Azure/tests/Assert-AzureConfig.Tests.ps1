# cspell:ignore toolong
Describe 'Assert-AzureConfig' -Tag 'L0' {
    BeforeAll {
        # Fixture identity — deliberately-distinct tokens (org tst, tenant fixtenant, Greek envs, core_*
        # subscriptions) so this logic test owns its inputs and editing the shipped azure.yml can never
        # change its outcome (ADR-TEST:1, ADR-TEST:3). Assert-AzureConfig validates the passed dict
        # standalone, so the fixture needs no shipped config.
        $script:baseConfig = [ordered]@{
            org               = 'tst'
            bicep_min_version = '0.30.0'
            tenants           = [ordered]@{
                fixtenant = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' }
            }
            subscriptions     = [ordered]@{
                core_lower = [ordered]@{
                    id           = '50a0ed00-de00-50b0-0000-000000000000'
                    tenant       = 'fixtenant'
                    environments = @('alpha')
                }
            }
            environments      = [ordered]@{
                alpha = [ordered]@{ shortcode = 'al'; region = 'westeurope'; region_code = 'weu' }
            }
        }
    }

    Context 'integrity (shipped azure.yml)' -Tag 'integrity' {
        It 'passes for the shipped azure.yml' {
            $config = Get-Config -Config azure
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $config } | Should -Not -Throw
        }

        It 'every shipped subscription customer resolves in customer.yml (by key or shortcode)' {
            $azure = Get-Config -Config azure
            foreach ($name in $azure.subscriptions.Keys) {
                $token = & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $azure.subscriptions[$name]
                if (-not [string]::IsNullOrEmpty($token)) {
                    { Get-AzureCustomer $token } | Should -Not -Throw -Because "shipped subscription '$name' references customer '$token'"
                }
            }
        }

        # The load-time validator groups customer subscriptions by their RAW customer token (it must not
        # read customer.yml — see customer-model.md); this is the NORMALIZED counterpart: with shortcode
        # bindings resolved to canonical keys, every shipped customer still serves each env exactly once,
        # and so does the non-customer (shared) set — the uniqueness every configuration file resolution
        # rests on (docs/adr/azure/data-model.md).
        It 'every shipped customer — and the non-customer set — serves each environment through exactly one subscription' {
            $azure = Get-Config -Config azure
            $servedBy = @{}
            foreach ($name in $azure.subscriptions.Keys) {
                $token = & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $azure.subscriptions[$name]
                $group = if ([string]::IsNullOrEmpty($token)) {
                    ''
                }
                else {
                    (Get-AzureCustomer $token).key
                }
                foreach ($environment in @($azure.subscriptions[$name].environments)) {
                    $key = "$group|$environment"
                    $servedBy.ContainsKey($key) |
                        Should -BeFalse -Because "'$(if ($group) { "customer $group" } else { 'the non-customer set' })' must serve '$environment' through exactly one subscription ($($servedBy[$key]) vs $name)"
                    $servedBy[$key] = $name
                }
            }
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for minimal valid config' {
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } (Copy-Object $baseConfig) } | Should -Not -Throw
        }

        It 'throws when missing required top-level key' {
            $bad = [ordered]@{ tenants = [ordered]@{} }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*Missing required*'
        }

        It 'throws when subscription references unknown tenant' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions = [ordered]@{
                s1 = [ordered]@{ id = '10570000-7e0a-0700-50b0-000000000000'; tenant = 'nonexistent'; environments = @('alpha') }
            }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*unknown tenant*'
        }

        It 'throws when subscription references unknown environment' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.environments = @('bogus')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*unknown environment*'
        }

        It 'throws when tenant has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.tenants.fixtenant.id = 'not-a-guid'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when subscription has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.id = 'not-a-guid'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when per_subscription is not a boolean' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.per_subscription = 'yes'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid per_subscription*'
        }

        It 'throws when a subscription lists more than one per-subscription env' {
            $bad = Copy-Object $baseConfig
            $bad.environments.subn = [ordered]@{ shortcode = 'sn'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.environments.subp = [ordered]@{ shortcode = 'sp'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.subscriptions.core_lower.environments = @('alpha', 'subn', 'subp')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*more than one per-subscription*'
        }

        It 'passes with exactly one per-subscription env per subscription' {
            $ok = Copy-Object $baseConfig
            $ok.environments.subn = [ordered]@{ shortcode = 'sn'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $ok.subscriptions.core_lower.environments = @('alpha', 'subn')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when environment is missing shortcode' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('shortcode')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'shortcode'*"
        }

        It 'throws when environment is missing region' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('region')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'region'*"
        }

        It 'throws when environment is missing region_code' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('region_code')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'region_code'*"
        }

        It 'throws when region_code is not 3 lowercase letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.region_code = 'westeurope'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid region_code*'
        }

        It 'throws when org is missing' {
            $bad = Copy-Object $baseConfig
            $bad.Remove('org')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*Missing required top-level key: 'org'*"
        }

        It 'throws when org is invalid (too long / not lowercase alnum)' {
            $bad = Copy-Object $baseConfig
            $bad.org = 'TOOLONG'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*org*is invalid*'
        }

        It 'throws when bicep_min_version is missing' {
            $bad = Copy-Object $baseConfig
            $bad.Remove('bicep_min_version')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*Missing required top-level key: 'bicep_min_version'*"
        }

        It 'throws when bicep_min_version is not MAJOR.MINOR.PATCH' {
            $bad = Copy-Object $baseConfig
            $bad.bicep_min_version = '0.30'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*bicep_min_version*is invalid*'
        }

        It 'does not require every environment to be served (completeness is a deploy-time concern)' {
            $ok = Copy-Object $baseConfig
            $ok.environments.Add('orphan', [ordered]@{ shortcode = 'oo'; region = 'westeurope'; region_code = 'weu' })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'allows more than one subscription to serve the same environment (resolution is by config folder, not uniqueness)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions = [ordered]@{
                c1 = [ordered]@{ id = '50a0ed00-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
                c2 = [ordered]@{ id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
            }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when environment name is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments = [ordered]@{ 'Bad-Env' = [ordered]@{ shortcode = 'bb'; region = 'westeurope'; region_code = 'weu' } }
            $bad.subscriptions.core_lower.environments = @('Bad-Env')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*is invalid*'
        }

        It 'throws when a shortcode is not 2 letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.shortcode = 'd'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid shortcode*'
        }

        It 'throws for duplicate environment shortcodes' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('beta', [ordered]@{ shortcode = 'al'; region = 'westeurope'; region_code = 'weu' })
            $bad.subscriptions.core_lower.environments = @('alpha', 'beta')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*Duplicate environment shortcode*'
        }

        # A subscription's `customer` field is a cross-asset reference into customer.yml (by key or
        # shortcode); it is NOT validated at azure-load time (that is enforced by the integrity test above
        # and at runtime by Get-AzureCustomer). So a customer token in a fixture azure config does not need
        # customer.yml here — Assert-AzureConfig ignores it.
        It 'ignores a subscription customer field (not validated at load)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.core_lower.customer = 'acme'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'passes for a customer pair with disjoint environments' {
            $ok = Copy-Object $baseConfig
            $ok.environments.Add('gamma', [ordered]@{ shortcode = 'gm'; region = 'westeurope'; region_code = 'weu' })
            $ok.subscriptions.core_lower.customer = 'acme'
            $ok.subscriptions.Add('core_upper', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    customer = 'acme'; environments = @('gamma')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when two subscriptions of one customer serve the same environment' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.customer = 'acme'
            $bad.subscriptions.Add('core_second', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    customer = 'acme'; environments = @('alpha')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } |
                Should -Throw '*more than one subscription serving environment*'
        }

        It 'allows two NON-customer subscriptions to serve the same env at load (root-config uniqueness is a discovery/integrity concern)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.Add('core_second', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    environments = @('alpha')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }
    }
}
