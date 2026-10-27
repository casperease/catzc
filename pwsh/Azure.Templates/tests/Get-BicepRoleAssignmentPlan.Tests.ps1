Describe 'Get-BicepRoleAssignmentPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:readerRole = '00000000-0000-0000-0000-0000000000a1'
        $script:unnamedRole = '00000000-0000-0000-0000-0000000000b2'
        $assignment = {
            param([string] $Name, [string] $Principal, [string] $Role, [string] $Condition)
            [ordered]@{
                type       = 'Microsoft.Authorization/roleAssignments'
                name       = $Name
                properties = [ordered]@{
                    principalId      = $Principal
                    roleDefinitionId = "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', $Role)]"
                    condition        = $Condition
                }
            }
        }
        $scoped = & $assignment 'widget-store' "[parameters('principalId')]" "'$script:unnamedRole'" 'widget-condition'
        $scoped.scope = "[resourceId('Microsoft.Storage/storageAccounts', 'widgetstore')]"
        $gated = & $assignment 'gadget-gated' "[parameters('readers')]" "'$script:readerRole'" ''
        $gated.condition = "[parameters('withGadget')]"
        $template = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = [ordered]@{ readers = @{ type = 'string' }; operators = @{ type = 'string' }; withGadget = @{ type = 'bool' } }
            resources  = @(
                (& $assignment 'widget-readers' "[parameters('readers')]" "'$script:readerRole'" '')
                [ordered]@{
                    type          = 'Microsoft.Resources/deployments'
                    name          = 'widget-group'
                    resourceGroup = 'widget-rg'
                    properties    = [ordered]@{
                        parameters = [ordered]@{ principalId = @{ value = "[parameters('operators')]" } }
                        template   = [ordered]@{
                            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                            parameters = [ordered]@{ principalId = @{ type = 'string' } }
                            resources  = @(
                                $scoped
                                (& $assignment 'widget-group-readers' "[parameters('principalId')]" "'$script:readerRole'" '')
                            )
                        }
                    }
                }
                $gated
            )
        }
        $script:root = Join-Path $TestDrive 'out'
        $folder = Join-Path $script:root 'widget'
        [void](New-Item -ItemType Directory -Path $folder -Force)
        [System.IO.File]::WriteAllText((Join-Path $folder 'main.json'), ($template | ConvertTo-Json -Depth 20))
        $parameters = '{ "parameters": { "readers": { "value": "widget-readers-id" }, "operators": { "value": "widget-operators-id" }, "withGadget": { "reference": { "secretName": "gadget" } } } }'
        [System.IO.File]::WriteAllText((Join-Path $folder 'parameters.wsub.json'), $parameters)
        [System.IO.File]::WriteAllText((Join-Path $folder 'parameters.gadgetco.wsub.json'), $parameters)
    }

    BeforeEach {
        $script:warnings = [System.Collections.Generic.List[string]]::new()
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
        Mock Get-BicepTemplate -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{
                name              = 'widget'
                deployment_target = 'Subscription'
                slots             = @(
                    [pscustomobject]@{ environment = 'wsub'; slot = ''; customer = ''; subscription = 'widget_sub' }
                    [pscustomobject]@{ environment = 'wsub'; slot = ''; customer = 'gadgetco'; subscription = 'widget_sub' }
                )
            }
        }
        # The slot's subscription id, which the role definition's subscriptionResourceId() and the scope's resourceId() read.
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            [pscustomobject]@{
                environments  = @{ wsub = @{ region = 'widget-north' } }
                subscriptions = @{ widget_sub = @{ id = '00000000-0000-0000-0000-00000000000a' } }
            }
        }
        Mock Get-BicepParametersFileName -ModuleName Catzc.Azure.Templates {
            if ($Customer) {
                "parameters.$Customer.$Environment.json"
            }
            else {
                "parameters.$Environment.json"
            }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'roles' } {
            [pscustomobject]@{ roles = @{ widget_reader = @{ id = $script:readerRole } } }
        }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { $script:warnings.Add("$Message") }
        $script:plan = @(Get-BicepRoleAssignmentPlan -OutputRoot $script:root)
    }

    It 'lists every template''s assignments when -Template is omitted, as typed records' {
        $script:plan.Count | Should -Be 6
        $script:plan | ForEach-Object { $_ | Should -BeOfType ([Catzc.Azure.Templates.BicepRoleAssignment]) }
        $script:plan | ForEach-Object template | Select-Object -Unique | Should -BeExactly 'widget'
    }

    It 'lists each slot by its coordinate' {
        $script:plan | ForEach-Object slot | Select-Object -Unique | Should -BeExactly @('wsub', 'gadgetco.wsub')
    }

    It 'lists a subscription assignment with its principal and its roles.yml name' {
        $readers = @($script:plan | Where-Object { $_.slot -eq 'wsub' -and $_.scope -eq 'subscription' })
        $readers.Count | Should -Be 1
        $readers[0].principal | Should -BeExactly 'widget-readers-id'
        $readers[0].role | Should -BeExactly 'widget_reader'
        $readers[0].condition | Should -BeExactly ''
    }

    It 'lists an assignment in a resource-group template at resourceGroup, with the principal passed to it' {
        $group = @($script:plan | Where-Object { $_.slot -eq 'wsub' -and $_.scope -eq 'resourceGroup' })
        $group.Count | Should -Be 1
        $group[0].principal | Should -BeExactly 'widget-operators-id'
        $group[0].role | Should -BeExactly 'widget_reader'
    }

    It 'names the one resource a scoped assignment is on, its definition id when roles.yml names none, and its condition' {
        $store = @($script:plan | Where-Object { $_.slot -eq 'wsub' -and $_.scope -like 'Microsoft.Storage/*' })
        $store.Count | Should -Be 1
        $store[0].scope | Should -BeExactly 'Microsoft.Storage/storageAccounts/widgetstore'
        $store[0].role | Should -BeExactly $script:unnamedRole
        $store[0].condition | Should -BeExactly 'widget-condition'
    }

    It 'leaves out an assignment whose condition does not resolve offline, and says so naming it' {
        @($script:plan | Where-Object principal -EQ 'widget-readers-id').Count | Should -Be 2
        $script:warnings.Count | Should -Be 2
        $script:warnings[0] | Should -BeLike '*gadget-gated*slot wsub*'
    }

    It 'lists only the named templates' {
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget', 'gadget' }
        @(Get-BicepRoleAssignmentPlan widget -OutputRoot $script:root).Count | Should -Be 6
        { Get-BicepRoleAssignmentPlan -OutputRoot $script:root } | Should -Throw '*run Build-Bicep gadget first*'
    }

    It 'rejects a template that does not exist' {
        { Get-BicepRoleAssignmentPlan sprocket -OutputRoot $script:root } | Should -Throw '*sprocket*'
    }

    It 'fails naming the Build-Bicep call when a template has no compiled main.json' {
        { Get-BicepRoleAssignmentPlan widget -OutputRoot (Join-Path $TestDrive 'empty') } | Should -Throw '*run Build-Bicep widget first*'
    }
}
