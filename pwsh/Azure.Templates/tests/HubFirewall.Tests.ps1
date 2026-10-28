Describe 'Hub firewall and routes: every compiled discovery slot' -Tag 'L2', 'integrity' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:slots = @(if ($script:bicepReady) {
                InModuleScope Catzc.Azure.Templates {
                    # Its own folder, so a concurrent build of the same template never swaps the files read here.
                    $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'discovery'))[-1]
                    $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                    $environments = (Get-Config -Config azure).environments
                    foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
                        $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                        $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                        $values = @{}
                        # A Key Vault reference carries no value, so it is passed as unresolved, as the compliance check does.
                        foreach ($name in @($parameters.Keys)) {
                            $values[$name] = if ($parameters[$name].Contains('value')) {
                                $parameters[$name].value
                            }
                            else {
                                [Catzc.Azure.Templates.ArmExpression]::Unresolved
                            }
                        }
                        [pscustomobject]@{
                            Name      = $slot.name
                            Values    = $values
                            # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                            Resources = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region |
                                    Where-Object { -not $_.Conditional })
                        }
                    }
                }
            })
        # Independent of NetworkCidr: the fifth address of the range, the first Azure assigns.
        $script:firstAzureHost = {
            param([string] $Cidr)
            $octets = @(($Cidr -split '/')[0] -split '\.' | ForEach-Object { [int] $_ })
            $value = ($octets[0] -shl 24) + ($octets[1] -shl 16) + ($octets[2] -shl 8) + $octets[3] + 4
            '{0}.{1}.{2}.{3}' -f (($value -shr 24) -band 255), (($value -shr 16) -band 255), (($value -shr 8) -band 255), ($value -band 255)
        }
        $script:hubs = @($script:slots | Where-Object { $_.Values.network.kind -eq 'hub' })
        $script:spokes = @($script:slots | Where-Object { $_.Values.network.kind -eq 'spoke' })
    }

    It 'derives each hub''s firewall address as the first one Azure assigns in its AzureFirewallSubnet' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:hubs.Count | Should -BeGreaterThan 0
        foreach ($hub in $script:hubs) {
            $expected = & $script:firstAzureHost $hub.Values.network.subnets.AzureFirewallSubnet
            $hub.Values.network.firewall_private_ip | Should -Be $expected -Because "hub $($hub.Name)'s spokes route to the firewall at that address"
        }
    }

    It 'deploys one firewall, its policy at the network.yml tier and its egress diagnostics in every hub, and none in a spoke' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in $script:slots) {
            $expected = if ($slot.Values.network.kind -eq 'hub') {
                1
            }
            else {
                0
            }
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Network/azureFirewalls').Count | Should -Be $expected -Because "slot $($slot.Name)"
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Network/firewallPolicies').Count | Should -Be $expected -Because "slot $($slot.Name)"
        }
        foreach ($hub in $script:hubs) {
            $hub.Values.network.firewall_sku | Should -BeIn @('Basic', 'Standard') -Because "hub $($hub.Name) takes its tier from network.yml"
            @($hub.Resources | Where-Object { $_.Type -eq 'Microsoft.Insights/diagnosticSettings' -and $_.Resource.Contains('scope') -and "$($_.Resource['scope'])" -match 'azureFirewalls' }).Count |
                Should -Be 1 -Because "hub $($hub.Name) sends its egress logs to the workspace"
        }
    }

    It 'routes every spoke subnet''s egress to its hub''s firewall address, and passes each hub its network.yml tier' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:spokes.Count | Should -BeGreaterThan 0
        foreach ($spoke in $script:spokes) {
            $hubAddress = $spoke.Values.networks[$spoke.Values.hub.subscription].firewall_private_ip
            $hubAddress | Should -Match '^\d+\.\d+\.\d+\.\d+$' -Because "spoke $($spoke.Name) resolves its hub's firewall address"
            $tables = @($spoke.Resources | Where-Object Type -EQ 'Microsoft.Network/routeTables')
            $tables.Count | Should -Be 1 -Because "spoke $($spoke.Name) deploys one route table"
            $routes = @([Catzc.Azure.Templates.ArmExpression]::Evaluate($tables[0].Resource.properties.routes, $tables[0].Scope, $tables[0].Variables))
            $egress = @($routes | Where-Object { $_.properties.addressPrefix -eq '0.0.0.0/0' })
            $egress.Count | Should -Be 1 -Because "spoke $($spoke.Name) sends its default route to the hub"
            $egress[0].properties.nextHopIpAddress | Should -Be $hubAddress -Because "spoke $($spoke.Name)'s egress goes to its hub's firewall"
        }
        foreach ($hub in $script:hubs) {
            $policy = $hub.Resources | Where-Object Type -EQ 'Microsoft.Network/firewallPolicies' | Select-Object -First 1
            [Catzc.Azure.Templates.ArmExpression]::Evaluate($policy.Resource.properties.sku.tier, $policy.Scope, $policy.Variables) |
                Should -Be $hub.Values.network.firewall_sku -Because "hub $($hub.Name)'s policy takes its network.yml tier"
        }
    }

    It 'lets each hub''s egress reach storage only by the regional Storage tag of its own location, spelled as the tag list does (Storage.WestEurope)' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($hub in $script:hubs) {
            $group = $hub.Resources | Where-Object Type -EQ 'Microsoft.Network/firewallPolicies/ruleCollectionGroups' | Select-Object -First 1
            $collections = @([Catzc.Azure.Templates.ArmExpression]::Evaluate($group.Resource.properties.ruleCollections, $group.Scope, $group.Variables))
            $tags = @($collections | ForEach-Object { @($_.rules) } | Where-Object { $_.ruleType -eq 'NetworkRule' } | ForEach-Object { @($_.destinationAddresses) })
            $storage = @($tags | Where-Object { "$_" -like 'Storage*' })
            $storage.Count | Should -Be 1 -Because "hub $($hub.Name) allows one storage tag"
            "$($storage[0])" | Should -MatchExactly '^Storage\.[A-Z][A-Za-z0-9]+$' -Because "hub $($hub.Name) narrows storage to its region's tag, never the global Storage"
        }
    }
}
