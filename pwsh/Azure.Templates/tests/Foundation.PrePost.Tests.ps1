Describe 'foundation PrePost: the vault endpoint subnet' -Tag 'L0', 'logic' {
    BeforeAll {
        # Every template's hook is a module named PrePost, and a build earlier in the session leaves one loaded; a mock needs exactly one.
        Get-Module PrePost -All | Remove-Module -Force
        $script:hook = Import-Module (Join-Path (Get-RepositoryRoot) 'infrastructure/templates/foundation/PrePost.psm1') -Force -PassThru
        Mock Get-Config -ModuleName $hook.Name -ParameterFilter { $Config -eq 'network' } {
            @{ subscriptions = @{ widget_hub = @{ kind = 'hub' }; widget_spoke = @{ kind = 'spoke' } } }
        }

        function script:Invoke-Hook {
            param([string] $Subscription, [string] $Customer, [System.Collections.IDictionary] $Parameters = [ordered]@{})
            $descriptor = [ordered]@{ ParametersFile = [ordered]@{ parameters = $Parameters } }
            $invocation = [ordered]@{ Template = 'widget'; Environment = 'gadget'; Slot = ''; Subscription = $Subscription; Customer = $Customer }
            (Invoke-BicepPrepareParameterSet -BuildInvocation $invocation -TemplateDescriptor ([ordered]@{ name = 'widget' }) -ConfigurationDescriptor $descriptor).ParametersFile.parameters
        }
    }
    AfterAll {
        Remove-Module $script:hook.Name -Force -ErrorAction SilentlyContinue
    }

    It 'puts a spoke slot''s endpoint in its private-endpoints subnet, and derives no name, since options.yml names does' {
        $parameters = Invoke-Hook -Subscription widget_spoke -Customer sprocket
        $parameters.privateEndpointSubnetName.value | Should -BeExactly 'private-endpoints'
        @($parameters.Keys) | Should -Be @('privateEndpointSubnetName')
    }

    It 'puts a hub slot''s endpoint in the shared-services subnet' {
        (Invoke-Hook -Subscription widget_hub).privateEndpointSubnetName.value | Should -BeExactly 'shared-services'
    }

    It 'keeps a subnet the slot sets' {
        $parameters = Invoke-Hook -Subscription widget_spoke -Customer sprocket -Parameters ([ordered]@{ privateEndpointSubnetName = @{ value = 'own-subnet' } })
        $parameters.privateEndpointSubnetName.value | Should -BeExactly 'own-subnet'
    }
}

Describe 'foundation PrePost: every compiled slot' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:compiled = if (-not $script:bicepReady) {
            [pscustomobject]@{ Main = $null; Slots = @() }
        }
        else {
            InModuleScope Catzc.Azure.Templates {
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep foundation -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'foundation'))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                $slots = foreach ($slot in @((Get-BicepTemplate foundation).slots)) {
                    $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                    $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                    $values = @{}
                    foreach ($name in @($parameters.Keys)) {
                        $values[$name] = $parameters[$name].value
                    }
                    [pscustomobject]@{ Name = $slot.name; Values = $values }
                }
                [pscustomobject]@{ Main = $main; Slots = @($slots) }
            }
        }
        $script:endpoints = {
            param($Values)
            @(InModuleScope Catzc.Azure.Templates -Parameters @{ Main = $script:compiled.Main; Values = $Values } {
                    param($Main, $Values)
                    Get-ArmDeployedResource -Template $Main -Values $Values | Where-Object Type -EQ 'Microsoft.Network/privateEndpoints'
                })
        }
    }

    It 'deploys the vault''s private endpoint, under its derived name, in every foundation slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:compiled.Slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:compiled.Slots) {
            $expected = "main/key-vault-private-endpoint/$($slot.Values.keyVaultPrivateEndpointName)"
            @(& $script:endpoints $slot.Values | Where-Object Path -EQ $expected).Count | Should -Be 1 -Because "slot $($slot.Name) deploys one vault endpoint"
        }
    }

    It 'deploys no endpoint on the bootstrap pass, a slot that sets deployKeyVaultPrivateEndpoint to false' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in $script:compiled.Slots) {
            $bootstrap = @{} + $slot.Values
            $bootstrap.deployKeyVaultPrivateEndpoint = $false
            @(& $script:endpoints $bootstrap).Count | Should -Be 0 -Because "slot $($slot.Name)'s bootstrap pass deploys no endpoint"
        }
    }
}
