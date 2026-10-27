Describe 'Resolve-BicepSlot' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:base = [Catzc.Azure.Templates.BicepSlot]::new('alpha', 'alpha', '', 'widget_sub', 'gadget', 'C:/widget/configuration/gadget/alpha.yml')
        $script:declared = [Catzc.Azure.Templates.BicepSlot]::new('alpha-red', 'alpha', 'red', 'widget_sub', 'gadget', 'C:/widget/configuration/gadget/alpha-red.yml')
        $script:template = [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                name = 'widget'; folder = 'C:/widget'; main = 'C:/widget/main.bicep'; configuration_folder = 'C:/widget/configuration'
                output_folder = 'C:/out/widget'; deployment_mode = 'Incremental'; deployment_target = 'ResourceGroup'; environment_kind = 'standard'
                short_name = 'wdg'; slots = @($base, $declared)
            })
    }

    It 'returns the declared slot of a coordinate' {
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            (Resolve-BicepSlot -TemplateDescriptor $Template -Environment alpha -Customer gadget).file | Should -Be 'C:/widget/configuration/gadget/alpha.yml'
            (Resolve-BicepSlot -TemplateDescriptor $Template -Environment alpha -Slot red -Customer gadget).name | Should -Be 'alpha-red'
        }
    }

    It 'returns an ephemeral slot for a named slot with no file: the base slot''s config under the runtime segment' {
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            $ephemeral = Resolve-BicepSlot -TemplateDescriptor $Template -Environment alpha -Slot l3 -Customer gadget
            $ephemeral.name | Should -Be 'alpha-l3'
            $ephemeral.slot | Should -Be 'l3'
            $ephemeral.subscription | Should -Be 'widget_sub'
            $ephemeral.customer | Should -Be 'gadget'
            $ephemeral.file | Should -Be 'C:/widget/configuration/gadget/alpha.yml'
        }
    }

    It 'returns nothing for a coordinate with no base slot' {
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            Resolve-BicepSlot -TemplateDescriptor $Template -Environment beta -Slot l3 -Customer gadget | Should -BeNullOrEmpty
            Resolve-BicepSlot -TemplateDescriptor $Template -Environment alpha -Slot l3 -Customer sprocket | Should -BeNullOrEmpty
        }
    }
}
