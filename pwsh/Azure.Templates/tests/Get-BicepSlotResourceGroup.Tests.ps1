Describe 'Get-BicepSlotResourceGroup' -Tag 'L0', 'logic' {
    BeforeEach {
        # A mock keeps the typed parameters of the command it replaces, so the descriptor is the real template type.
        $script:slot = [Catzc.Azure.Templates.BicepSlot]::new('widget', 'widget', '', 'gadget_sub', '', 'TestDrive:/configuration/widget.yml')
        $script:descriptor = [Catzc.Azure.Templates.BicepTemplate]::new([ordered]@{
                name = 'gadget'; folder = 'TestDrive:/'; main = 'TestDrive:/main.bicep'; configuration_folder = 'TestDrive:/configuration'
                output_folder = 'TestDrive:/out'; deployment_mode = 'Incremental'; deployment_target = 'ResourceGroup'
                short_name = 'gdg'; slots = @($script:slot)
            })
        # The function is private, so it runs inside its module.
        $script:invoke = {
            param([hashtable] $Splat)
            & (Get-Module Catzc.Azure.Templates) { param($s) Get-BicepSlotResourceGroup @s } $Splat
        }
        # The mock of Get-BicepTemplateConfiguration keeps its -Template validation, which asks for the template names.
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'gadget' }
        Mock Resolve-BicepSlot -ModuleName Catzc.Azure.Templates { $script:slot }
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates { [ordered]@{ ResourceGroup = 'widget-gadget-rg' } }
        Mock Resolve-BicepRuntimeSlotNames -ModuleName Catzc.Azure.Templates { @{ ResourceGroup = "widget-$RuntimeSlot-gadget-rg" } }
    }

    It 'returns the group the slot declares' {
        & $script:invoke @{ TemplateDescriptor = $script:descriptor; Environment = 'widget' } | Should -BeExactly 'widget-gadget-rg'
        Should -Invoke Resolve-BicepRuntimeSlotNames -ModuleName Catzc.Azure.Templates -Times 0
    }

    It 're-renders the base slot''s group for a runtime slot' {
        Mock Resolve-BicepSlot -ModuleName Catzc.Azure.Templates { [pscustomobject]@{ name = 'widget'; file = 'TestDrive:/configuration/widget.yml' } }
        & $script:invoke @{ TemplateDescriptor = $script:descriptor; Environment = 'widget'; Slot = 't1' } | Should -BeExactly 'widget-t1-gadget-rg'
    }

    It 'names the file and the key when the slot declares no group' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates { [ordered]@{} }
        { & $script:invoke @{ TemplateDescriptor = $script:descriptor; Environment = 'widget' } } |
            Should -Throw "*config 'TestDrive:/configuration/widget.yml' declares no top-level 'ResourceGroup' key*"
    }

    It 'names the sibling yml of a bicepparam slot' {
        Mock Get-BicepTemplateConfiguration -ModuleName Catzc.Azure.Templates { [ordered]@{ BicepParamFile = 'TestDrive:/configuration/widget.bicepparam' } }
        { & $script:invoke @{ TemplateDescriptor = $script:descriptor; Environment = 'widget' } } | Should -Throw '*widget.yml*'
    }

    It 'refuses a slot the template does not have' {
        Mock Resolve-BicepSlot -ModuleName Catzc.Azure.Templates { $null }
        { & $script:invoke @{ TemplateDescriptor = $script:descriptor; Environment = 'widget'; Slot = 't1'; Customer = 'sprocket' } } |
            Should -Throw "*no slot*customer 'sprocket'*"
    }
}
