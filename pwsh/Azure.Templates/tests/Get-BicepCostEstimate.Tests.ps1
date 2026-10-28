Describe 'Get-BicepCostEstimate' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Azure.Templates.CostModelConfig]::new(@{
                headroom = 1.5
                meters   = @(
                    @{ id = 'widget-vault-ops'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; quantity = 10 }
                    @{ id = 'widget-endpoint-hours'; type = 'Microsoft.Network/privateEndpoints'; service = 'Virtual Network'; meter = 'Standard Private Endpoint'; quantity = 730 }
                    @{ id = 'widget-unused'; type = 'Microsoft.Compute/virtualMachines'; service = 'Virtual Machines'; meter = 'B1s'; quantity = 730 }
                )
            })
    }

    BeforeEach {
        $script:out = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        # The gadget template inlines one module holding a vault and an endpoint, and declares a second endpoint itself.
        $compiled = @{
            resources = @(
                @{ type = 'Microsoft.Network/privateEndpoints' }
                @{ type = 'Microsoft.Resources/deployments'; properties = @{ template = @{ resources = @(
                                @{ type = 'Microsoft.KeyVault/vaults' }
                                @{ type = 'Microsoft.Network/privateEndpoints' }
                            )
                        }
                    }
                }
            )
        }
        $null = New-Item -ItemType Directory -Path (Join-Path $script:out 'gadget') -Force
        Set-Content -LiteralPath (Join-Path $script:out 'gadget/main.json') -Value ($compiled | ConvertTo-Json -Depth 10)
        $script:prices = Join-Path $script:out 'cost-prices.json'
        Set-Content -LiteralPath $script:prices -Value (@{
                currency = 'USD'; region = 'westeurope'; as_of = '2026-10-27'
                prices = @{ 'widget-vault-ops' = @{ unit_price = 0.03 }; 'widget-endpoint-hours' = @{ unit_price = 0.01 } }
            } | ConvertTo-Json -Depth 5)
    }

    It 'prices each metered type by its count, quantity and unit price, inlined modules included' {
        $estimate = Get-BicepCostEstimate gadget -Config $script:config -PricesPath $script:prices -OutputRoot $script:out
        ($estimate.Lines | Where-Object Meter -EQ 'widget-endpoint-hours').Count | Should -Be 2
        ($estimate.Lines | Where-Object Meter -EQ 'widget-endpoint-hours').Monthly | Should -Be 14.6
        ($estimate.Lines | Where-Object Meter -EQ 'widget-vault-ops').Monthly | Should -Be 0.3
        $estimate.Monthly | Should -Be 14.9
        $estimate.Budget | Should -Be 22.35
        $estimate.AsOf | Should -Be '2026-10-27'
        $estimate.Lines.Meter | Should -Not -Contain 'widget-unused'
    }

    It 'names a metered type with no price as unpriced and leaves it out of the total' {
        Set-Content -LiteralPath $script:prices -Value (@{ prices = @{ 'widget-vault-ops' = @{ unit_price = 0.03 } } } | ConvertTo-Json -Depth 5)
        $estimate = Get-BicepCostEstimate gadget -Config $script:config -PricesPath $script:prices -OutputRoot $script:out
        $estimate.Unpriced | Should -Be @('widget-endpoint-hours')
        $estimate.Monthly | Should -Be 0.3
    }

    It 'throws with the remedy when the template is not compiled' {
        { Get-BicepCostEstimate sprocket -Config $script:config -PricesPath $script:prices -OutputRoot $script:out } |
            Should -Throw '*run Build-Bicep sprocket first*'
    }

    It 'refuses a meter with no quantity' {
        { [Catzc.Azure.Templates.CostModelConfig]::new(@{ meters = @(@{ id = 'widget'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations' }) }) } |
            Should -Throw '*quantity must be a positive number*'
    }

    Context 'a type whose SKU a config decides' {
        BeforeAll {
            $script:tierConfig = [Catzc.Azure.Templates.CostModelConfig]::new(@{
                    skus   = @{ 'Microsoft.Network/azureFirewalls' = 'global.widget.subscriptions.{subscription}.tier' }
                    meters = @(
                        @{ id = 'widget-basic-hours'; type = 'Microsoft.Network/azureFirewalls'; service = 'Gadget'; meter = 'Basic Deployment'; when_sku = 'Basic'; quantity = 730 }
                        @{ id = 'widget-standard-hours'; type = 'Microsoft.Network/azureFirewalls'; service = 'Gadget'; meter = 'Standard Deployment'; when_sku = 'Standard'; count = 1; quantity = 730 }
                        @{ id = 'widget-vault-ops'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; quantity = 10 }
                    )
                })
        }

        BeforeEach {
            $hub = @{ languageVersion = '2.0'; resources = @{ widget = @{ type = 'Microsoft.Network/azureFirewalls' }; gadget = @{ type = 'Microsoft.Network/azureFirewalls' }; sprocket = @{ type = 'Microsoft.KeyVault/vaults' } } }
            $null = New-Item -ItemType Directory -Path (Join-Path $script:out 'widget') -Force
            Set-Content -LiteralPath (Join-Path $script:out 'widget/main.json') -Value ($hub | ConvertTo-Json -Depth 10)
            Set-Content -LiteralPath $script:prices -Value (@{
                    prices = @{ 'widget-basic-hours' = @{ unit_price = 0.5 }; 'widget-standard-hours' = @{ unit_price = 1 }; 'widget-vault-ops' = @{ unit_price = 0.03 } }
                } | ConvertTo-Json -Depth 5)
            Mock Get-ConfigValue -ModuleName Catzc.Azure.Templates {
                @{ 'global.widget.subscriptions.gadget_hub.tier' = 'Basic'; 'global.widget.subscriptions.sprocket_hub.tier' = 'Standard'; 'global.widget.subscriptions.gadget_spoke.tier' = $null }[$Address]
            }
        }

        It 'prices the meter of the SKU the subscription''s config names, by the declarations counted' {
            $estimate = Get-BicepCostEstimate widget -Config $script:tierConfig -PricesPath $script:prices -OutputRoot $script:out -Subscription gadget_hub
            $estimate.Subscription | Should -Be 'gadget_hub'
            $estimate.Lines.Meter | Should -Be @('widget-basic-hours', 'widget-vault-ops')
            ($estimate.Lines | Where-Object Meter -EQ 'widget-basic-hours').Sku | Should -Be 'Basic'
            ($estimate.Lines | Where-Object Meter -EQ 'widget-basic-hours').Monthly | Should -Be 730
        }

        It 'prices a meter with a count for that many resources, not the declarations' {
            $estimate = Get-BicepCostEstimate widget -Config $script:tierConfig -PricesPath $script:prices -OutputRoot $script:out -Subscription sprocket_hub
            $estimate.Lines.Meter | Should -Be @('widget-standard-hours', 'widget-vault-ops')
            ($estimate.Lines | Where-Object Meter -EQ 'widget-standard-hours').Monthly | Should -Be 730
            Should -Invoke Get-ConfigValue -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter { $Address -eq 'global.widget.subscriptions.sprocket_hub.tier' }
        }

        It 'applies no SKU-bound meter where the config names no SKU, or with no subscription to read it for' {
            (Get-BicepCostEstimate widget -Config $script:tierConfig -PricesPath $script:prices -OutputRoot $script:out -Subscription gadget_spoke).Lines.Meter |
                Should -Be @('widget-vault-ops')
            (Get-BicepCostEstimate widget -Config $script:tierConfig -PricesPath $script:prices -OutputRoot $script:out).Lines.Meter | Should -Be @('widget-vault-ops')
            Should -Invoke Get-ConfigValue -ModuleName Catzc.Azure.Templates -Times 1 -Exactly
        }

        It 'refuses a when_sku on a type skus does not name' {
            { [Catzc.Azure.Templates.CostModelConfig]::new(@{ meters = @(@{ id = 'widget'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; when_sku = 'Basic'; quantity = 1 }) }) } |
                Should -Throw '*when_sku needs skus to name where the SKU of*'
        }

        It 'refuses a skus entry that is not a resource type mapped to a global address' {
            { [Catzc.Azure.Templates.CostModelConfig]::new(@{ skus = @{ 'Microsoft.Network/azureFirewalls' = 'widget.tier' } }) } | Should -Throw '*must map to a global address*'
            { [Catzc.Azure.Templates.CostModelConfig]::new(@{ skus = @{ widget = 'global.widget.tier' } }) } | Should -Throw '*must be a resource type*'
            { [Catzc.Azure.Templates.CostModelConfig]::new(@{ skus = 'global.widget.tier' }) } | Should -Throw '*skus must be a mapping*'
        }

        It 'refuses a count that is not a whole number of at least 1' {
            { [Catzc.Azure.Templates.CostModelConfig]::new(@{ meters = @(@{ id = 'widget'; type = 'Microsoft.KeyVault/vaults'; service = 'Key Vault'; meter = 'Operations'; count = 0; quantity = 1 }) }) } |
                Should -Throw '*count must be a whole number of at least 1*'
        }
    }
}

Describe 'Get-BicepCostEstimate — shipped assets/cost-prices.json' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    BeforeAll {
        # The default price table is the one shipped in the loaded module; the compiled template is a fixture.
        $script:out = Join-Path $TestDrive 'compiled'
        $script:shipped = ConvertFrom-Json -AsHashtable -InputObject ([System.IO.File]::ReadAllText(
                (Get-CatzcModuleRoot 'assets/cost-prices.json' -Module Catzc.Azure.Templates)))
        $script:model = Get-Config -Config cost-model
        # Every type the shipped model meters without a SKU condition, so each line is priced without a subscription.
        $types = @($script:model.meters | Where-Object { -not $_.when_sku } | ForEach-Object type | Sort-Object -Unique)
        $null = New-Item -ItemType Directory -Path (Join-Path $script:out 'widget') -Force
        Set-Content -LiteralPath (Join-Path $script:out 'widget/main.json') -Value (@{
                resources = @($types | ForEach-Object { @{ type = $_ } })
            } | ConvertTo-Json -Depth 5)
    }

    It 'prices every line from the shipped table when no prices path is given' {
        $estimate = Get-BicepCostEstimate widget -OutputRoot $script:out
        $script:shipped['as_of'] | Should -Not -BeNullOrEmpty
        $estimate.AsOf | Should -Be $script:shipped['as_of']
        @($estimate.Lines).Count | Should -BeGreaterThan 0
        foreach ($line in $estimate.Lines) {
            $line.UnitPrice | Should -Be ([double] $script:shipped['prices'][$line.Meter]['unit_price']) -Because $line.Meter
        }
    }
}
