Describe 'CanNotDelete locks: every compiled slot' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real builds below run only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        # The resources each slot deploys, by the compliance quality gate's evaluator, for a template's compiled main.json and slot parameters.
        function script:Get-SlotResource {
            param([string] $Template)
            InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $Template } {
                param($Template)
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep $Template -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root $Template))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                $environments = (Get-Config -Config azure).environments
                foreach ($slot in @((Get-BicepTemplate $Template).slots)) {
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
                    [pscustomobject]@{
                        Slot      = $slot.name
                        Values    = $values
                        # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                        Resources = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region |
                                Where-Object { -not $_.Conditional })
                    }
                }
            }
        }

        if ($script:bicepReady) {
            $script:discoverySlots = @(Get-SlotResource -Template discovery)
            $script:foundationSlots = @(Get-SlotResource -Template foundation)
        }
    }

    It 'locks the hub''s virtual network and each of its private DNS zones' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $hubs = @($script:discoverySlots | Where-Object { $_.Values.network.kind -eq 'hub' })
        $hubs.Count | Should -BeGreaterThan 0
        foreach ($slot in $hubs) {
            $locks = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/locks')
            $zones = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Network/privateDnsZones')
            $zones.Count | Should -BeGreaterThan 0 -Because "hub slot $($slot.Slot) deploys its private DNS zones"
            @($locks | Where-Object Path -Like '*/lock-virtual-network/*').Count | Should -Be 1 -Because "hub slot $($slot.Slot) locks its network"
            @($locks | Where-Object Path -NotLike '*/lock-virtual-network/*').Count | Should -Be $zones.Count -Because "hub slot $($slot.Slot) locks each zone"
        }
    }

    It 'locks nothing in a spoke' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in @($script:discoverySlots | Where-Object { $_.Values.network.kind -ne 'hub' })) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/locks').Count | Should -Be 0 -Because "spoke slot $($slot.Slot) locks nothing"
        }
    }

    It 'locks foundation''s Key Vault in every slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $slots = @($script:foundationSlots)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            @($slot.Resources | Where-Object { $_.Type -eq 'Microsoft.Authorization/locks' -and $_.Path -like '*/key-vault-lock/*' }).Count |
                Should -Be 1 -Because "slot $($slot.Slot) locks its vault"
        }
    }
}
