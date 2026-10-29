Describe 'Discovery budget: every compiled slot against its cost model' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:slots = @(if ($script:bicepReady) {
                InModuleScope Catzc.Azure.Templates {
                    # Its own folder, so a concurrent build of the same template never swaps the files read here; offline, from the checked-in prices.
                    $root = Join-Path (Get-PSDrive TestDrive).Root 'budget'
                    $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path $root 'discovery'))[-1]
                    foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
                        $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                        $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                        # The slot's network.yml subscription is the one whose plan it deploys.
                        $network = $parameters.network.value
                        $subscription = @($parameters.networks.value.Keys | Where-Object { $parameters.networks.value[$_].vnet_address_space -eq $network.vnet_address_space })
                        [pscustomobject]@{
                            Name         = $slot.name
                            Subscription = $subscription
                            Amount       = [double] $parameters.budgetAmount.value
                            Estimate     = Get-BicepCostEstimate discovery -OutputRoot $root -Subscription $subscription[0]
                        }
                    }
                }
            })
    }

    It 'finds each slot''s network.yml subscription' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            $slot.Subscription.Count | Should -Be 1 -Because "slot $($slot.Name) deploys one network.yml subscription's plan"
        }
    }

    It 'sets every budgetAmount at least the estimate times the cost model''s headroom' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $short = @(foreach ($slot in $script:slots) {
                if ($slot.Amount -lt $slot.Estimate.Budget) {
                    "$($slot.Name) ($($slot.Subscription)): budgetAmount $($slot.Amount) is below $($slot.Estimate.Budget)"
                }
            })
        $short | Should -BeNullOrEmpty
    }

    It 'prices each hub''s firewall by its network.yml tier' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in @($script:slots | Where-Object { $_.Estimate.Lines.Type -contains 'Microsoft.Network/azureFirewalls' })) {
            $tier = (Get-ConfigValue "global.network.subscriptions.$($slot.Subscription[0]).firewall_sku")
            if ($tier) {
                $slot.Estimate.Lines.Meter | Should -Contain "firewall-$($tier.ToLowerInvariant())-deployment" -Because "hub $($slot.Subscription[0]) runs a $tier firewall"
            }
        }
    }
}
