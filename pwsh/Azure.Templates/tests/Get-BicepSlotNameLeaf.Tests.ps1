Describe 'Get-BicepSlotNameLeaf' -Tag 'L0', 'logic' {
    It 'walks maps and lists to every non-empty string leaf, each with its dotted location' {
        InModuleScope Catzc.Azure.Templates {
            $value = [ordered]@{ widget = [ordered]@{ gadget = 'alpha'; empty = '' }; gadgets = @('beta', [ordered]@{ label = 'gamma' }); count = 3 }
            $leaves = @(Get-BicepSlotNameLeaf -Value $value -Location '')
            @($leaves | ForEach-Object location) | Should -Be @('widget.gadget', 'gadgets[0]', 'gadgets[1].label')
            @($leaves | ForEach-Object value) | Should -Be @('alpha', 'beta', 'gamma')
        }
    }

    It 'marks a leaf named under a key ending in Name or Names, and keeps it named down the path' {
        InModuleScope Catzc.Azure.Templates {
            $value = [ordered]@{ widgetName = 'alpha'; gadgetNames = [ordered]@{ first = 'beta'; list = @('gamma') }; label = 'delta' }
            $leaves = @(Get-BicepSlotNameLeaf -Value $value -Location 'root')
            @($leaves | ForEach-Object location) | Should -Be @('root.widgetName', 'root.gadgetNames.first', 'root.gadgetNames.list[0]', 'root.label')
            @($leaves | ForEach-Object named) | Should -Be @($true, $true, $true, $false)
        }
    }

    It 'unmarks a key ending in a not_names suffix, and no later Name key undoes it' {
        InModuleScope Catzc.Azure.Templates {
            $value = [ordered]@{ widgetSkuName = 'Standard'; gadgetSubnetName = [ordered]@{ widgetName = 'alpha' }; gadgetName = 'beta' }
            $leaves = @(Get-BicepSlotNameLeaf -Value $value -Location '' -NotNames 'SkuName', 'SubnetName')
            @($leaves | ForEach-Object named) | Should -Be @($false, $false, $true)
        }
    }

    It 'returns nothing for a null value or an empty string' {
        InModuleScope Catzc.Azure.Templates {
            @(Get-BicepSlotNameLeaf -Value $null -Location '').Count | Should -Be 0
            @(Get-BicepSlotNameLeaf -Value '' -Location 'widget').Count | Should -Be 0
        }
    }

    It 'refuses a state outside -1 to 1' {
        InModuleScope Catzc.Azure.Templates {
            { Get-BicepSlotNameLeaf -Value 'alpha' -Location '' -State 2 } | Should -Throw '*State*'
        }
    }
}
