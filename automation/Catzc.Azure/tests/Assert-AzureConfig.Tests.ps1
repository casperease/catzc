# cspell:ignore toolong
Describe 'Assert-AzureConfig' -Tag 'L0' {
    BeforeAll {
        $script:baseConfig = [ordered]@{
            org               = 'zct'
            bicep_min_version = '0.30.0'
            tenants           = [ordered]@{
                placeholder = [ordered]@{ id = '00000000-0000-0000-0000-000000000001' }
            }
            subscriptions     = [ordered]@{
                placeholder_nonprod = [ordered]@{
                    id           = '00000000-0000-0000-0000-000000000002'
                    tenant       = 'placeholder'
                    environments = @('dev')
                }
            }
            environments      = [ordered]@{
                dev = [ordered]@{ shortcode = 'de'; region = 'westeurope'; region_code = 'weu' }
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
        # bindings resolved to canonical keys, every shipped family still serves each env exactly once.
        It 'every shipped family serves each environment through exactly one subscription (normalized)' {
            $azure = Get-Config -Config azure
            foreach ($family in (Get-AzureFamilies)) {
                $servedBy = @{}
                foreach ($name in $family.subscriptions) {
                    foreach ($environment in @($azure.subscriptions[$name].environments)) {
                        $servedBy.ContainsKey($environment) |
                            Should -BeFalse -Because "family '$($family.name)' must serve '$environment' through exactly one subscription ($($servedBy[$environment]) vs $name)"
                        $servedBy[$environment] = $name
                    }
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
                s1 = [ordered]@{ id = '00000000-0000-0000-0000-000000000099'; tenant = 'nonexistent'; environments = @('dev') }
            }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*unknown tenant*'
        }

        It 'throws when subscription references unknown environment' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.environments = @('bogus')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*unknown environment*'
        }

        It 'throws when tenant has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.tenants.placeholder.id = 'not-a-guid'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when subscription has invalid GUID' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.id = 'not-a-guid'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid id*'
        }

        It 'throws when per_subscription is not a boolean' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.per_subscription = 'yes'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid per_subscription*'
        }

        It 'throws when a subscription lists more than one per-subscription env' {
            $bad = Copy-Object $baseConfig
            $bad.environments.subn = [ordered]@{ shortcode = 'sn'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.environments.subp = [ordered]@{ shortcode = 'sp'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $bad.subscriptions.placeholder_nonprod.environments = @('dev', 'subn', 'subp')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*more than one per-subscription*'
        }

        It 'passes with exactly one per-subscription env per subscription' {
            $ok = Copy-Object $baseConfig
            $ok.environments.subn = [ordered]@{ shortcode = 'sn'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
            $ok.subscriptions.placeholder_nonprod.environments = @('dev', 'subn')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when environment is missing shortcode' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.Remove('shortcode')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'shortcode'*"
        }

        It 'throws when environment is missing region' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.Remove('region')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'region'*"
        }

        It 'throws when environment is missing region_code' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.Remove('region_code')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*missing 'region_code'*"
        }

        It 'throws when region_code is not 3 lowercase letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.region_code = 'westeurope'
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
                c1 = [ordered]@{ id = '00000000-0000-0000-0000-000000000002'; tenant = 'placeholder'; environments = @('dev') }
                c2 = [ordered]@{ id = '00000000-0000-0000-0000-000000000003'; tenant = 'placeholder'; environments = @('dev') }
            }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when environment name is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments = [ordered]@{ 'Bad-Env' = [ordered]@{ shortcode = 'bb'; region = 'westeurope'; region_code = 'weu' } }
            $bad.subscriptions.placeholder_nonprod.environments = @('Bad-Env')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*is invalid*'
        }

        It 'throws when a shortcode is not 2 letters' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.shortcode = 'd'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid shortcode*'
        }

        It 'throws for duplicate environment shortcodes' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('test', [ordered]@{ shortcode = 'de'; region = 'westeurope'; region_code = 'weu' })
            $bad.subscriptions.placeholder_nonprod.environments = @('dev', 'test')
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*Duplicate environment shortcode*'
        }

        # A subscription's `customer` field is a cross-asset reference into customer.yml (by key or
        # shortcode); it is NOT validated at azure-load time (that is enforced by the integrity test above
        # and at runtime by Get-AzureCustomer). So a customer token in a fixture azure config does not need
        # customer.yml here — Assert-AzureConfig ignores it.
        It 'ignores a subscription customer field (not validated at load)' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.placeholder_nonprod.customer = 'anything'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'passes for a valid two-member family with disjoint environments' {
            $ok = Copy-Object $baseConfig
            $ok.environments.Add('prod', [ordered]@{ shortcode = 'pr'; region = 'westeurope'; region_code = 'weu' })
            $ok.subscriptions.placeholder_nonprod.family = 'placeholder'
            $ok.subscriptions.Add('placeholder_prod', [ordered]@{
                    id = '00000000-0000-0000-0000-000000000003'; tenant = 'placeholder'
                    family = 'placeholder'; environments = @('prod')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }

        It 'throws when a family key contains an underscore or invalid chars' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.family = 'place_holder'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*invalid family*'
        }

        It 'throws when a subscription declares both customer and family' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.customer = 'anything'
            $bad.subscriptions.placeholder_nonprod.family = 'placeholder'
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw "*both 'customer' and 'family'*"
        }

        It 'throws when two members of one family serve the same environment' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.family = 'placeholder'
            $bad.subscriptions.Add('placeholder_prod', [ordered]@{
                    id = '00000000-0000-0000-0000-000000000003'; tenant = 'placeholder'
                    family = 'placeholder'; environments = @('dev')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } |
                Should -Throw '*more than one subscription serving environment*'
        }

        It 'groups customer subscriptions by their raw token for the disjointness rule' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.placeholder_nonprod.customer = 'anything'
            $bad.subscriptions.Add('placeholder_second', [ordered]@{
                    id = '00000000-0000-0000-0000-000000000003'; tenant = 'placeholder'
                    customer = 'anything'; environments = @('dev')
                })
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } |
                Should -Throw '*more than one subscription serving environment*'
        }

        It 'throws when a declared families: entry has no member subscription' {
            $bad = Copy-Object $baseConfig
            $bad.families = [ordered]@{ ghost = [ordered]@{ details = 'nobody home' } }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $bad } | Should -Throw '*no member subscription*'
        }

        It 'passes when a declared families: entry matches a family: key or a subscription name' {
            $ok = Copy-Object $baseConfig
            $ok.subscriptions.placeholder_nonprod.family = 'placeholder'
            $ok.families = [ordered]@{ placeholder = [ordered]@{ details = 'configured' } }
            { & (Get-Module Catzc.Azure) { Assert-AzureConfig $args[0] } $ok } | Should -Not -Throw
        }
    }
}
