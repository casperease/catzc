Describe 'discovery flow logs: every compiled slot' -Tag 'L1', 'integrity' {
    It 'deploys a flow log on the slot''s virtual network, under the region''s Network Watcher' {
        InModuleScope Catzc.Azure.Templates {
            # Its own folder, so a concurrent build of the same template never swaps the files read here.
            $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'discovery'))[-1]
            $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
            $slots = @((Get-BicepTemplate discovery).slots)
            $slots.Count | Should -BeGreaterThan 0
            $environments = (Get-Config -Config azure).environments
            foreach ($slot in $slots) {
                $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                $values = @{}
                foreach ($name in @($parameters.Keys)) {
                    $values[$name] = if ($parameters[$name].Contains('value')) {
                        $parameters[$name].value
                    }
                    else {
                        [Catzc.Azure.Templates.ArmExpression]::Unresolved
                    }
                }
                $values.flowLogStorageAccountName | Should -Not -BeNullOrEmpty -Because "slot $($slot.name) names its flow-log storage"
                # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                $flowLogs = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region | Where-Object {
                        $_.Type -eq 'Microsoft.Network/networkWatchers/flowLogs' -and -not $_.Conditional
                    })
                $flowLogs.Count | Should -Be 1 -Because "slot $($slot.name) deploys one flow log on its network"
            }
        }
    }
}
