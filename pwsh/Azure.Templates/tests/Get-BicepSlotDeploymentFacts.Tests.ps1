Describe 'Get-BicepSlotDeploymentFacts' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            [pscustomobject]@{
                environments  = @{ widget = @{ region = 'widget-north' } }
                subscriptions = @{ widget_sub = @{ id = '00000000-0000-0000-0000-00000000000a' } }
            }
        }
        Mock Get-BicepSlotResourceGroup -ModuleName Catzc.Azure.Templates { "rg-$($TemplateDescriptor.name)-$Environment-$Slot-$Customer" }
    }

    It 'reads a resource-group slot''s region, subscription id and declared resource group' {
        InModuleScope Catzc.Azure.Templates {
            $facts = Get-BicepSlotDeploymentFacts -Template @{ name = 'gadget'; deployment_target = 'ResourceGroup' } -Slot ([pscustomobject]@{
                    environment = 'widget'; slot = 'blue'; customer = 'sprocket'; subscription = 'widget_sub'
                })
            $facts.Location | Should -BeExactly 'widget-north'
            $facts.SubscriptionId | Should -BeExactly '00000000-0000-0000-0000-00000000000a'
            $facts.ResourceGroupName | Should -BeExactly 'rg-gadget-widget-blue-sprocket'
        }
    }

    It 'leaves the group empty for a subscription template, and every fact azure.yml does not declare empty' {
        InModuleScope Catzc.Azure.Templates {
            $facts = Get-BicepSlotDeploymentFacts -Template @{ name = 'gadget'; deployment_target = 'Subscription' } -Slot ([pscustomobject]@{
                    environment = 'gadget'; slot = ''; customer = ''; subscription = 'gadget_sub'
                })
            $facts.Location | Should -BeExactly ''
            $facts.SubscriptionId | Should -BeExactly ''
            $facts.ResourceGroupName | Should -BeExactly ''
            Should -Invoke Get-BicepSlotResourceGroup -ModuleName Catzc.Azure.Templates -Times 0
        }
    }
}
