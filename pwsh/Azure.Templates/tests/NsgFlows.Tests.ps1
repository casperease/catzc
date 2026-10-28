Describe 'Security-group flows: every compiled discovery slot' -Tag 'L2', 'integrity' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:groups = @(if ($script:bicepReady) {
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
                        # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                        $deployed = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region)
                        foreach ($group in @($deployed | Where-Object Type -EQ 'Microsoft.Network/networkSecurityGroups')) {
                            [pscustomobject]@{
                                Name  = "$($slot.name) $($group.Path)"
                                Rules = @([Catzc.Azure.Templates.ArmExpression]::Evaluate($group.Resource.properties.securityRules, $group.Scope, $group.Variables, $group.Indexes))
                            }
                        }
                    }
                }
            })
        $script:declared = @((Get-Config -Config network).nsg_flows)
    }

    It 'evaluates every security group''s rules in every slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:groups.Count | Should -BeGreaterThan 0
        foreach ($group in $script:groups) {
            $group.Rules.Count | Should -BeGreaterThan 1 -Because "$($group.Name) resolves to its rules"
            foreach ($rule in $group.Rules) {
                [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($rule) | Should -BeFalse -Because "$($group.Name) holds no unresolved rule"
            }
        }
    }

    It 'allows only the declared flows, each from its role''s prefixes, then denies the network and the internet' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($group in $script:groups) {
            $allows = @($group.Rules | Select-Object -SkipLast 2)
            $denies = @($group.Rules | Select-Object -Last 2)
            $denies | ForEach-Object name | Should -Be @('deny-virtual-network-inbound', 'deny-internet-inbound') -Because "$($group.Name) ends with the two denies"
            $denies | ForEach-Object { $_.properties.access } | Should -Be @('Deny', 'Deny') -Because "$($group.Name) denies what no flow allows"
            foreach ($rule in $allows) {
                $flow = @($script:declared | Where-Object name -EQ $rule.name)
                $flow.Count | Should -Be 1 -Because "$($group.Name) allows $($rule.name) only as a network.yml flow"
                $rule.properties.access | Should -Be 'Allow'
                $rule.properties.priority | Should -BeLessThan 4000 -Because "$($group.Name) puts $($rule.name) before the denies"
                @($rule.properties.destinationPortRanges) | Should -Be @($flow[0].ports) -Because "$($group.Name) opens the declared ports of $($rule.name)"
                @($rule.properties.sourceAddressPrefixes).Count | Should -BeGreaterThan 0 -Because "$($group.Name) names the sources of $($rule.name)"
                foreach ($prefix in @($rule.properties.sourceAddressPrefixes)) {
                    $prefix | Should -Match '^\d+\.\d+\.\d+\.\d+/\d+$' -Because "$($group.Name) allows $($rule.name) from a role's range, never a tag or the whole network"
                }
            }
        }
    }
}
