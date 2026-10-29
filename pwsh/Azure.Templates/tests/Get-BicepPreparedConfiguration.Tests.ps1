Describe 'Get-BicepPreparedConfiguration: addresses and facts' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:slot = [Catzc.Azure.Templates.BicepSlot]::new('alpha', 'alpha', '', 'widget_sub', '', 'C:/widget/configuration/alpha.yml')
        $script:template = [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                name = 'widget'; folder = 'C:/widget'; main = 'C:/widget/main.bicep'; configuration_folder = 'C:/widget/configuration'
                output_folder = 'C:/out/widget'; deployment_mode = 'Incremental'; deployment_target = 'ResourceGroup'; environment_kind = 'standard'
                short_name = 'wdg'; slots = @($slot); addresses = [ordered]@{ gadgetRoleId = 'global.roles.gadget.id' }
                facts = [ordered]@{ gadgetEnforcement = 'policy_enforcement' }
            })
    }

    BeforeEach {
        # A mock keeps Get-BicepTemplateConfiguration's own -Template validation, so the fixture template is a known name.
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
        Mock Resolve-BicepDerivedNames -ModuleName Catzc.Azure.Templates { [ordered]@{} }
        # The fact resolution itself is Resolve-BicepEnvironmentFacts's; here it reports the field it was handed and the file it names.
        Mock Resolve-BicepEnvironmentFacts -ModuleName Catzc.Azure.Templates {
            $resolved = [ordered]@{}
            foreach ($key in @($Parameters.Keys)) {
                $resolved[$key] = if ($Parameters[$key].Contains('fact')) {
                    [ordered]@{ value = "fact:$($Parameters[$key].fact)@$ConfigFile" }
                }
                else {
                    $Parameters[$key]
                }
            }
            $resolved
        }
        # The address resolution itself is Resolve-BicepParameterAddresses's; here it reports the address it was handed.
        Mock Resolve-BicepParameterAddresses -ModuleName Catzc.Azure.Templates {
            $resolved = [ordered]@{}
            foreach ($key in @($Parameters.Keys)) {
                $resolved[$key] = if ($Parameters[$key].Contains('address')) {
                    [ordered]@{ value = "resolved:$($Parameters[$key].address)" }
                }
                else {
                    $Parameters[$key]
                }
            }
            $resolved
        }
    }

    It 'gives every slot the declared address, resolved with the slot''s own addresses' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = [ordered]@{ value = 'widget' } } } }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $parameters.gadgetRoleId.value | Should -Be 'resolved:global.roles.gadget.id'
            $parameters.widgetName.value | Should -Be 'widget'
        }
    }

    It 'refuses a slot that sets a parameter the template addresses' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ gadgetRoleId = [ordered]@{ value = 'hand-typed' } } } }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $arguments = @{ TemplateDescriptor = $Template; Slot = $Slot }
            { Get-BicepPreparedConfiguration @arguments } |
                Should -Throw "*writes 'gadgetRoleId', a shared value of the template (options.yml addresses)*"
        }
    }

    It 'resolves the options.yml facts and the slot''s own { fact: } entries in one pass, naming the slot file' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetZoned = [ordered]@{ fact = 'subscription_production' } } } }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $configFile = Join-Path 'C:/widget/configuration' 'alpha.yml'
            $parameters.widgetZoned.value | Should -Be "fact:subscription_production@$configFile"
            $parameters.gadgetEnforcement.value | Should -Be "fact:policy_enforcement@$configFile"
        }
    }

    It 'refuses a slot that sets a parameter the template''s options.yml facts declare' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ gadgetEnforcement = [ordered]@{ value = 'hand-typed' } } } }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $arguments = @{ TemplateDescriptor = $Template; Slot = $Slot }
            { Get-BicepPreparedConfiguration @arguments } |
                Should -Throw "*writes 'gadgetEnforcement', a fact of its environment (options.yml facts)*"
        }
    }
}
