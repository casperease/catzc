Describe 'Get-BicepPreparedConfiguration: slot addresses, facts and runtime slot names' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:slot = [Catzc.Azure.Templates.BicepSlot]::new('alpha', 'alpha', '', 'widget_sub', '', 'C:/widget/configuration/alpha.yml')
        $script:template = [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                name = 'widget'; folder = 'C:/widget'; main = 'C:/widget/main.bicep'; configuration_folder = 'C:/widget/configuration'
                output_folder = 'C:/out/widget'; deployment_mode = 'Incremental'; deployment_target = 'ResourceGroup'
                short_name = 'wdg'; slots = @($slot)
            })
    }

    BeforeEach {
        # A mock keeps Get-BicepTemplateConfiguration's own -Template validation, so the fixture template is a known name.
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
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

    It 'resolves the slot''s own { address: } entries and keeps its plain values' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{
                        widgetName   = [ordered]@{ value = 'widget' }
                        gadgetRoleId = [ordered]@{ address = 'global.roles.gadget.id' }
                    }
                }
            }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $parameters.gadgetRoleId.value | Should -Be 'resolved:global.roles.gadget.id'
            $parameters.widgetName.value | Should -Be 'widget'
            @($parameters.Keys) | Should -Be @('widgetName', 'gadgetRoleId')
        }
    }

    It 'resolves the slot''s own { fact: } entries, naming the slot file' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetZoned = [ordered]@{ fact = 'subscription_production' } } } }
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $configFile = Join-Path 'C:/widget/configuration' 'alpha.yml'
            $parameters.widgetZoned.value | Should -Be "fact:subscription_production@$configFile"
            @($parameters.Keys) | Should -Be @('widgetZoned')
        }
    }

    It 'renders a runtime slot''s names from its base slot''s with Resolve-BicepRuntimeSlotNames' -Tag 'ADR-AZ-NAMING-DETERMINISTICNAMES' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = [ordered]@{ value = 'widget' } } } }
        }
        Mock Resolve-BicepRuntimeSlotNames -ModuleName Catzc.Azure.Templates -RemoveParameterType TemplateDescriptor {
            [ordered]@{
                Parameters    = [ordered]@{ widgetName = [ordered]@{ value = "$($Parameters.widgetName.value)@$Environment-$RuntimeSlot" } }
                ResourceGroup = ''
            }
        }
        $runtime = [Catzc.Azure.Templates.BicepSlot]::new('alpha-red', 'alpha', 'red', 'widget_sub', '', 'C:/widget/configuration/alpha.yml')
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $runtime } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $parameters.widgetName.value | Should -Be 'widget@alpha-red'
        }
    }

    It 'uses a declared slot''s names as written, never the runtime slot names' -Tag 'ADR-AZ-NAMING-DETERMINISTICNAMES' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates {
            [ordered]@{ ParametersFile = [ordered]@{ parameters = [ordered]@{ widgetName = [ordered]@{ value = 'widget' } } } }
        }
        Mock Resolve-BicepRuntimeSlotNames -ModuleName Catzc.Azure.Templates -RemoveParameterType TemplateDescriptor { throw 'not a runtime slot' }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Slot = $slot } {
            param($Template, $Slot)
            $parameters = (Get-BicepPreparedConfiguration -TemplateDescriptor $Template -Slot $Slot).ParametersFile.parameters
            $parameters.widgetName.value | Should -BeExactly 'widget'
            @($parameters.Keys) | Should -Be @('widgetName')
        }
    }
}
