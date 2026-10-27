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
}
