Describe 'CanNotDelete locks: every compiled slot' -Tag 'L1', 'integrity' {
    BeforeAll {
        # The resources each slot deploys, by the compliance gate's evaluator, for a template's compiled main.json and slot parameters.
        function script:Get-SlotResource {
            param([string] $Template)
            InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $Template } {
                param($Template)
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep $Template -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root $Template))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
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
                        Resources = @(Get-ArmDeployedResource -Template $main -Values $values | Where-Object { -not $_.Conditional })
                    }
                }
            }
        }
    }

    It 'locks the hub''s virtual network and each of its private DNS zones' {
        $hubs = @(Get-SlotResource -Template discovery | Where-Object { $_.Values.network.kind -eq 'hub' })
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
        foreach ($slot in @(Get-SlotResource -Template discovery | Where-Object { $_.Values.network.kind -ne 'hub' })) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/locks').Count | Should -Be 0 -Because "spoke slot $($slot.Slot) locks nothing"
        }
    }

    It 'locks foundation''s Key Vault in every slot' {
        $slots = @(Get-SlotResource -Template foundation)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            @($slot.Resources | Where-Object { $_.Type -eq 'Microsoft.Authorization/locks' -and $_.Path -like '*/key-vault-lock/*' }).Count |
                Should -Be 1 -Because "slot $($slot.Slot) locks its vault"
        }
    }
}
