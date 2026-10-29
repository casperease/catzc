# cspell:ignore widg gadg
Describe 'Resolve-BicepRuntimeSlotNames' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'templates'
        Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates { $script:root }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        $files = [ordered]@{
            'widget/main.bicep'                  = "targetScope = 'resourceGroup'"
            'widget/options.yml'                 = @(
                'short_name: widg'
                'deployment_target: ResourceGroup'
            ) -join "`n"
            'widget/configuration/alpha.yml'     = 'ParametersFile: {}'
            # A declared slot puts 001 in the candidate set, so a name of that sibling slot matches.
            'widget/configuration/alpha-001.yml' = 'ParametersFile: {}'
            'gadget/main.bicep'                  = "targetScope = 'subscription'"
            'gadget/options.yml'                 = @(
                'short_name: gadg'
                'deployment_target: Subscription'
            ) -join "`n"
            'gadget/configuration/alpha.yml'     = 'ParametersFile: {}'
        }
        foreach ($relative in $files.Keys) {
            $path = Join-Path $script:root $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $path -Parent) -Force
            [System.IO.File]::WriteAllText($path, $files[$relative] + "`n")
        }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = @{} }
    }

    It 're-renders a name of the template''s own with the runtime slot and keeps a non-name parameter' -Tag 'ADR-AZ-NAMING-DETERMINISTICNAMES' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                logName = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Type log -Role ops) }
                tags    = [ordered]@{ value = [ordered]@{ workload = 'widget' } }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.logName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type log -Role ops)
        $result.Parameters.tags.value.workload | Should -BeExactly 'widget'
    }

    It 'keeps a foreign name as written and re-renders the own one beside it' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                widgetGroupName   = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Type rg) }
                resourceGroupName = [ordered]@{ value = (Get-BicepResourceName -Template gadget -Environment alpha -Type rg) }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate gadget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.widgetGroupName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Type rg)
        $result.Parameters.resourceGroupName.value | Should -BeExactly (Get-BicepResourceName -Template gadget -Environment alpha -Slot red -Type rg)
        $result.ResourceGroup | Should -BeNullOrEmpty
    }

    It 'keeps a parameter with a naming_exception as written' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                legacyName = [ordered]@{ value = 'hand-written-legacy'; naming_exception = 'an imported name kept as it is' }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.legacyName.value | Should -BeExactly 'hand-written-legacy'
        $result.Parameters.legacyName.naming_exception | Should -BeExactly 'an imported name kept as it is'
    }

    It 're-renders the declared resource group with the runtime slot' {
        $result = InModuleScope Catzc.Azure.Templates {
            $group = Get-BicepResourceName -Template widget -Environment alpha -Type rg
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -ResourceGroup $group -Environment alpha -RuntimeSlot red
        }
        $result.ResourceGroup | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type rg)
        $result.Parameters.Count | Should -Be 0
    }

    It 'walks the leaves of an object and of a list of names, and keeps a leaf whose key is no name' {
        $result = InModuleScope Catzc.Azure.Templates {
            $own = Get-BicepResourceName -Template widget -Environment alpha -Type rg
            $parameters = [ordered]@{
                logNames = [ordered]@{ value = [ordered]@{ ops = (Get-BicepResourceName -Template widget -Environment alpha -Type log -Role ops) } }
                spokes   = [ordered]@{ value = @([ordered]@{ subscription = 'widget_sub'; resourceGroupName = $own }) }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.logNames.value.ops | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type log -Role ops)
        $result.Parameters.spokes.value[0].subscription | Should -BeExactly 'widget_sub'
        $result.Parameters.spokes.value[0].resourceGroupName | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type rg)
    }

    It 'throws on a name with no single canonical match, naming its location' {
        {
            InModuleScope Catzc.Azure.Templates {
                $parameters = [ordered]@{ oddName = [ordered]@{ value = 'not-a-canonical-name' } }
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
            }
        } | Should -Throw "*oddName of template 'widget': 'not-a-canonical-name' has no single canonical match*"
    }

    It 'throws on an unmatched resource group' {
        {
            InModuleScope Catzc.Azure.Templates {
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -ResourceGroup 'some-guessed-rg' -Environment alpha -RuntimeSlot red
            }
        } | Should -Throw "*ResourceGroup of template 'widget'*"
    }

    It 'refuses a runtime slot the namer cannot render' {
        {
            InModuleScope Catzc.Azure.Templates {
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -Environment alpha -RuntimeSlot 'Too-long'
            }
        } | Should -Throw '*RuntimeSlot*'
    }

    It 'keeps a name of a sibling slot or another environment of the template and re-renders the base slot''s own coordinates' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                hubGroupName   = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment beta -Type rg) }
                peerLogName    = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Slot '001' -Type log -Role ops) }
                ownStorageName = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Type st) }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.hubGroupName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment beta -Type rg)
        $result.Parameters.peerLogName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot '001' -Type log -Role ops)
        $result.Parameters.ownStorageName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type st)
    }

    It 're-renders only the names of the base slot''s customer' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                acmeLogName   = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Customer acme -Type log -Role ops) }
                sharedLogName = [ordered]@{ value = (Get-BicepResourceName -Template widget -Environment alpha -Type log -Role ops) }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -Customer acme -RuntimeSlot red
        }
        $result.Parameters.acmeLogName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Customer acme -Slot red -Type log -Role ops)
        $result.Parameters.sharedLogName.value | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Type log -Role ops)
    }

    It 'keeps a leaf under a not_names key as written, the name gate''s one predicate' {
        $result = InModuleScope Catzc.Azure.Templates {
            $parameters = [ordered]@{
                widgetSkuName = [ordered]@{ value = 'Standard_LRS' }
                gadgetNames   = [ordered]@{ value = [ordered]@{ gadgetSubnetName = 'not-a-canonical-name' } }
            }
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -Environment alpha -RuntimeSlot red
        }
        $result.Parameters.widgetSkuName.value | Should -BeExactly 'Standard_LRS'
        $result.Parameters.gadgetNames.value.gadgetSubnetName | Should -BeExactly 'not-a-canonical-name'
    }
}
