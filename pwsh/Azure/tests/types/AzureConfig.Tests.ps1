# cspell:ignore toolong
Describe 'AzureConfig' -Tag 'L0' {
    BeforeAll {
        # Fixture identities distinct from the shipped azure.yml, so editing it never changes these outcomes.
        $script:baseConfig = [ordered]@{
            org           = 'fxo'
            tenants       = [ordered]@{
                fixtenant = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' }
            }
            subscriptions = [ordered]@{
                core_lower = [ordered]@{
                    id           = '50a0ed00-de00-50b0-0000-000000000000'
                    tenant       = 'fixtenant'
                    environments = @('alpha')
                }
            }
            environments  = [ordered]@{
                alpha = [ordered]@{ shortcode = 'al'; region = 'westeurope'; region_code = 'weu' }
            }
        }
        $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.AzureConfig]::new($raw) }
    }

    Context 'integrity (shipped azure.yml)' -Tag 'integrity' {
        It 'passes for the shipped azure.yml' {
            Get-Config -Config azure | Should -BeOfType [Catzc.Azure.AzureConfig]
        }

        It 'every shipped subscription customer resolves in customer.yml (by key or shortcode)' {
            $azure = Get-Config -Config azure
            foreach ($name in $azure.subscriptions.Keys) {
                $token = & (Get-Module Catzc.Azure) { Get-AzureSubscriptionCustomer $args[0] } $azure.subscriptions[$name]
                if (-not [string]::IsNullOrEmpty($token)) {
                    { Get-AzureCustomer $token } |
                        Should -Not -Throw -Because "shipped subscription '$name' references customer '$token'"
                }
            }
        }

        # The normalised counterpart of the load-time check: shortcode bindings resolve to customer keys first.
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
            $config = & $script:make (Copy-Object $baseConfig)
            $config.org | Should -Be 'fxo'
            $config.tenants['fixtenant'].id | Should -Be 'fa0e0000-7e0a-0700-1d00-000000000000'
            $config.subscriptions['core_lower'] | Should -BeOfType [Catzc.Azure.AzureSubscriptionRecord]
            $config.subscriptions['core_lower'].environments | Should -Be @('alpha')
            $config.subscriptions['core_lower'].Contains('customer') | Should -BeFalse
            $config.environments['alpha'].region_code | Should -Be 'weu'
            $config.environments['alpha'].per_subscription | Should -BeFalse
        }

        It 'throws when missing required top-level key' {
            $bad = [ordered]@{ tenants = [ordered]@{} }
            { & $script:make $bad } | Should -Throw '*Missing required*'
        }

        It 'throws when subscription references unknown tenant' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions = [ordered]@{
                s1 = [ordered]@{ id = '10570000-7e0a-0700-50b0-000000000000'; tenant = 'nonexistent'; environments = @('alpha') }
            }
            { & $script:make $bad } | Should -Throw '*unknown tenant*'
        }

        It 'throws when subscription references unknown environment' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.environments = @('bogus')
            { & $script:make $bad } | Should -Throw '*unknown environment*'
        }

        It 'throws when tenant has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.tenants.fixtenant.id = 'not-a-guid'
            { & $script:make $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when subscription has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.id = 'not-a-guid'
            { & $script:make $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when per_subscription is not a boolean' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.per_subscription = 'yes'
            { & $script:make $bad } | Should -Throw '*invalid per_subscription*'
        }

        It 'throws when a subscription lists more than one per-subscription env' {
            $bad = Copy-Object $baseConfig
            $bad.environments.nsub = [ordered]@{ shortcode = 'ns'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.environments.psub = [ordered]@{ shortcode = 'ps'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.subscriptions.core_lower.environments = @('alpha', 'nsub', 'psub')
            { & $script:make $bad } | Should -Throw '*more than one per-subscription*'
        }

        It 'passes with exactly one per-subscription env per subscription' {
            $ok = Copy-Object $baseConfig
            $ok.environments.nsub = [ordered]@{ shortcode = 'ns'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $ok.subscriptions.core_lower.environments = @('alpha', 'nsub')
            (& $script:make $ok).environments['nsub'].per_subscription | Should -BeTrue
        }

        Context 'staging_for' {
            BeforeEach {
                $script:staged = Copy-Object $baseConfig
                $script:staged.environments.beta = [ordered]@{ shortcode = 'be'; region = 'westeurope'; region_code = 'weu'; staging_for = 'alpha' }
                $script:staged.subscriptions.core_lower.environments = @('alpha', 'beta')
            }

            It 'accepts an environment that stages another served by the same subscriptions' {
                $config = & $script:make $script:staged
                $config.environments['beta'].staging_for | Should -Be 'alpha'
                $config.environments['alpha'].staging_for | Should -BeNullOrEmpty
            }

            It 'throws when the staged environment does not exist' {
                $script:staged.environments.beta.staging_for = 'gamma'
                { & $script:make $script:staged } |
                    Should -Throw "*environment 'beta' stages unknown environment 'gamma'*"
            }

            It 'throws when a per-subscription environment stages or is staged' {
                $script:staged.environments.alpha.per_subscription = $true
                { & $script:make $script:staged } |
                    Should -Throw '*a per-subscription environment cannot stage or be staged*'
            }

            It 'throws when a subscription serves the staging environment but not its target' {
                $script:staged.environments.gamma = [ordered]@{ shortcode = 'ga'; region = 'westeurope'; region_code = 'weu' }
                $script:staged.subscriptions.core_lower.environments = @('gamma', 'beta')
                { & $script:make $script:staged } |
                    Should -Throw "*subscription 'core_lower' serves staging environment 'beta' but not the 'alpha' it stages*"
            }
        }

        It 'throws when environment is missing shortcode' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('shortcode')
            { & $script:make $bad } | Should -Throw "*missing 'shortcode'*"
        }

        It 'throws when environment is missing region' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('region')
            { & $script:make $bad } | Should -Throw "*missing 'region'*"
        }

        It 'throws when environment is missing region_code' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('region_code')
            { & $script:make $bad } | Should -Throw "*missing 'region_code'*"
        }

        It 'throws when region_code is not 3 lowercase letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.region_code = 'westeurope'
            { & $script:make $bad } | Should -Throw '*invalid region_code*'
        }

        It 'throws when org is missing' {
            $bad = Copy-Object $baseConfig
            $bad.Remove('org')
            { & $script:make $bad } | Should -Throw "*Missing required top-level key: 'org'*"
        }

        It 'throws when org is invalid (too long / not lowercase alnum)' {
            $bad = Copy-Object $baseConfig
            $bad.org = 'TOOLONG'
            { & $script:make $bad } | Should -Throw '*org*is invalid*'
        }

        It 'rejects bicep_min_version as an unknown key: the bicep pin lives in tools.yml' {
            $bad = Copy-Object $baseConfig
            $bad.bicep_min_version = '0.30.0'
            { & $script:make $bad } | Should -Throw '*bicep_min_version*'
        }

        It 'does not require every environment to be served (completeness is a deploy-time concern)' {
            $ok = Copy-Object $baseConfig
            $ok.environments.Add('orphan', [ordered]@{ shortcode = 'oo'; region = 'westeurope'; region_code = 'weu' })
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'allows more than one subscription to serve the same environment (resolution is by config folder, not uniqueness)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions = [ordered]@{
                c1 = [ordered]@{ id = '50a0ed00-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
                c2 = [ordered]@{ id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
            }
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'throws when environment name is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments = [ordered]@{ 'Bad-Env' = [ordered]@{ shortcode = 'bb'; region = 'westeurope'; region_code = 'weu' } }
            $bad.subscriptions.core_lower.environments = @('Bad-Env')
            { & $script:make $bad } | Should -Throw '*is invalid*'
        }

        It 'throws when a shortcode is not 2 letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.shortcode = 'd'
            { & $script:make $bad } | Should -Throw '*invalid shortcode*'
        }

        It 'throws for duplicate environment shortcodes' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('beta', [ordered]@{ shortcode = 'al'; region = 'westeurope'; region_code = 'weu' })
            $bad.subscriptions.core_lower.environments = @('alpha', 'beta')
            { & $script:make $bad } | Should -Throw '*Duplicate environment shortcode*'
        }

        # A customer field is a cross-asset reference, checked by the integrity test and Get-AzureCustomer, never at load.
        It 'ignores a subscription customer field (not validated at load)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.core_lower.customer = 'acme'
            (& $script:make $ok).subscriptions['core_lower'].customer | Should -Be 'acme'
        }

        It 'passes for a customer pair with disjoint environments' {
            $ok = Copy-Object $baseConfig
            $ok.environments.Add('gamma', [ordered]@{ shortcode = 'gm'; region = 'westeurope'; region_code = 'weu' })
            $ok.subscriptions.core_lower.customer = 'acme'
            $ok.subscriptions.Add('core_upper', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    customer = 'acme'; environments = @('gamma')
                })
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'throws when two subscriptions of one customer serve the same environment' -Tag 'ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.core_lower.customer = 'acme'
            $bad.subscriptions.Add('core_second', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    customer = 'acme'; environments = @('alpha')
                })
            { & $script:make $bad } | Should -Throw '*more than one subscription serving environment*'
        }

        It 'allows two NON-customer subscriptions to serve the same env at load (root-config uniqueness is a discovery/integrity concern)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.Add('core_second', [ordered]@{
                    id = '50a0ed00-000d-50b0-0000-000000000000'; tenant = 'fixtenant'
                    environments = @('alpha')
                })
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'throws on an unknown top-level or entry key' {
            $bad = Copy-Object $baseConfig
            $bad.customers = [ordered]@{}
            $bad.environments.alpha.colour = 'blue'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*unknown key 'customers'*"
            $err.Exception.Message | Should -BeLike "*environment 'alpha': unknown key 'colour'*"
        }

        It 'throws when a tenant or subscription name is not lower-snake_case' {
            $bad = Copy-Object $baseConfig
            $bad.tenants.Add('OtherTenant', [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' })
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*tenant name 'OtherTenant' is not a valid identifier*"
        }

        It 'defaults policy_enforcement when the file omits it' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $config = & $script:make (Copy-Object $baseConfig)
            $config.policy_enforcement['production'] | Should -Be 'Default'
            $config.policy_enforcement['nonproduction'] | Should -Be 'DoNotEnforce'
        }

        It 'keeps the policy_enforcement keys a file sets and defaults the rest' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $ok = Copy-Object $baseConfig
            $ok.policy_enforcement = [ordered]@{ nonproduction = 'Default' }
            $config = & $script:make $ok
            $config.policy_enforcement['production'] | Should -Be 'Default'
            $config.policy_enforcement['nonproduction'] | Should -Be 'Default'
        }

        It 'takes a full policy_enforcement map as given' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $ok = Copy-Object $baseConfig
            $ok.policy_enforcement = [ordered]@{ production = 'DoNotEnforce'; nonproduction = 'DoNotEnforce' }
            $config = & $script:make $ok
            $config.policy_enforcement['production'] | Should -Be 'DoNotEnforce'
            $config.policy_enforcement['nonproduction'] | Should -Be 'DoNotEnforce'
        }

        It 'resolves policy_enforcement by config address on the typed record' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $config = & $script:make (Copy-Object $baseConfig)
            $mode = & (Get-Module Catzc.Base.Config) { Resolve-ConfigKeyPath -Node $args[0] -Segment 'policy_enforcement', 'production' -Address 'global.azure.policy_enforcement.production' } $config
            $mode | Should -Be 'Default'
        }

        It 'rejects an unknown policy_enforcement key and mode in one throw' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $bad = Copy-Object $baseConfig
            $bad.policy_enforcement = [ordered]@{ production = 'Enforce'; staging = 'Default' }
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*policy_enforcement: unknown key 'staging'*"
            $err.Exception.Message | Should -BeLike "*policy_enforcement.production: unknown mode 'Enforce'*"
        }

        It 'rejects a policy_enforcement that is not a map' -Tag 'ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE' {
            $bad = Copy-Object $baseConfig
            $bad.policy_enforcement = 'Default'
            { & $script:make $bad } | Should -Throw '*policy_enforcement must be a map*'
        }

        It 'defaults groups to empty when the file omits them' -Tag 'ADR-AZ-LZ-CAFIDENTITY' {
            $config = & $script:make (Copy-Object $baseConfig)
            $config.groups.Count | Should -Be 0
        }

        It 'reads groups by owner and environment class, an absent role null' -Tag 'ADR-AZ-LZ-CAFIDENTITY' {
            $ok = Copy-Object $baseConfig
            $ok.groups = [ordered]@{ widget = [ordered]@{ production = [ordered]@{ readers = '0a000000-0000-0000-0000-00000000000a' } } }
            $config = & $script:make $ok
            $config.groups['widget']['production'].readers | Should -Be '0a000000-0000-0000-0000-00000000000a'
            $config.groups['widget']['production'].operators | Should -BeNullOrEmpty
            $config.groups['widget'].ContainsKey('nonproduction') | Should -BeFalse
        }

        It 'rejects an unknown class, an unknown role and a non-GUID id in one throw' -Tag 'ADR-AZ-LZ-CAFIDENTITY' {
            $bad = Copy-Object $baseConfig
            $bad.groups = [ordered]@{ widget = [ordered]@{ staging = @{}; production = [ordered]@{ owners = '0a000000-0000-0000-0000-00000000000a'; readers = 'gadget' } } }
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*groups.widget: unknown key 'staging'*"
            $err.Exception.Message | Should -BeLike "*groups.widget.production: unknown key 'owners'*"
            $err.Exception.Message | Should -BeLike "*groups.widget.production.readers: 'gadget' is not an Entra group object id*"
        }

        It 'rejects groups that are not a map, and an invalid owner' -Tag 'ADR-AZ-LZ-CAFIDENTITY' {
            $bad = Copy-Object $baseConfig
            $bad.groups = 'widget'
            { & $script:make $bad } | Should -Throw '*groups must be a map*'
            $bad.groups = [ordered]@{ 'Widget-1' = @{} }
            { & $script:make $bad } | Should -Throw "*groups: owner 'Widget-1' is invalid*"
        }

        It 'reports every violation in one throw' {
            $bad = Copy-Object $baseConfig
            $bad.org = 'TOOLONG'
            $bad.tenants.fixtenant.id = 'not-a-guid'
            $bad.environments.alpha.region_code = 'westeurope'
            $bad.subscriptions.core_lower.environments = @('bogus')
            $err = { & $script:make $bad } | Should -Throw -PassThru
            foreach ($expected in '*org*is invalid*', "*tenant 'fixtenant' has invalid id*", '*invalid region_code*',
                '*unknown environment*') {
                $err.Exception.Message | Should -BeLike $expected
            }
        }
    }
}
