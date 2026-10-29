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
            'widget/main.bicep'              = "targetScope = 'resourceGroup'"
            'widget/options.yml'             = @(
                'short_name: widg'
                'deployment_target: ResourceGroup'
                'names:'
                '  logName: { type: log, role: ops }'
                '  storageName: { type: st }'
            ) -join "`n"
            'widget/configuration/alpha.yml' = 'ParametersFile: {}'
            'gadget/main.bicep'              = "targetScope = 'subscription'"
            'gadget/options.yml'             = @(
                'short_name: gadg'
                'deployment_target: Subscription'
            ) -join "`n"
            'gadget/configuration/alpha.yml' = 'ParametersFile: {}'
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
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -RuntimeSlot red
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
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate gadget) -Parameters $parameters -RuntimeSlot red
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
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -RuntimeSlot red
        }
        $result.Parameters.legacyName.value | Should -BeExactly 'hand-written-legacy'
        $result.Parameters.legacyName.naming_exception | Should -BeExactly 'an imported name kept as it is'
    }

    It 're-renders the declared resource group with the runtime slot' {
        $result = InModuleScope Catzc.Azure.Templates {
            $group = Get-BicepResourceName -Template widget -Environment alpha -Type rg
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -ResourceGroup $group -RuntimeSlot red
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
            Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -RuntimeSlot red
        }
        $result.Parameters.logNames.value.ops | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type log -Role ops)
        $result.Parameters.spokes.value[0].subscription | Should -BeExactly 'widget_sub'
        $result.Parameters.spokes.value[0].resourceGroupName | Should -BeExactly (Get-BicepResourceName -Template widget -Environment alpha -Slot red -Type rg)
    }

    It 'throws on a name with no single canonical match, naming its location' {
        {
            InModuleScope Catzc.Azure.Templates {
                $parameters = [ordered]@{ oddName = [ordered]@{ value = 'not-a-canonical-name' } }
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters $parameters -RuntimeSlot red
            }
        } | Should -Throw "*oddName of template 'widget': 'not-a-canonical-name' has no single canonical match*"
    }

    It 'throws on an unmatched resource group' {
        {
            InModuleScope Catzc.Azure.Templates {
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -ResourceGroup 'some-guessed-rg' -RuntimeSlot red
            }
        } | Should -Throw "*ResourceGroup of template 'widget'*"
    }

    It 'refuses a runtime slot the namer cannot render' {
        {
            InModuleScope Catzc.Azure.Templates {
                Resolve-BicepRuntimeSlotNames -TemplateDescriptor (Get-BicepTemplate widget) -Parameters @{} -RuntimeSlot 'Too-long'
            }
        } | Should -Throw '*RuntimeSlot*'
    }

    It 'gives the names the derived-names resolver gives for the same runtime slot' {
        $pair = InModuleScope Catzc.Azure.Templates {
            $descriptor = Get-BicepTemplate widget
            $base = $descriptor.slots | Where-Object { $_.environment -eq 'alpha' -and $_.slot -eq '' } | Select-Object -First 1
            $declared = Resolve-BicepDerivedNames -TemplateDescriptor $descriptor -Slot $base
            $parameters = [ordered]@{}
            foreach ($key in @($declared.Keys)) {
                $parameters[$key] = [ordered]@{ value = $declared[$key] }
            }
            $runtime = [Catzc.Azure.Templates.BicepSlot]::new('alpha-red', 'alpha', 'red', $base.subscription, '', $base.file)
            @{
                Old = Resolve-BicepDerivedNames -TemplateDescriptor $descriptor -Slot $runtime
                New = Resolve-BicepRuntimeSlotNames -TemplateDescriptor $descriptor -Parameters $parameters -RuntimeSlot red
            }
        }
        @($pair.New.Parameters.Keys) | Should -Be @($pair.Old.Keys)
        foreach ($key in @($pair.Old.Keys)) {
            $pair.New.Parameters[$key].value | Should -BeExactly $pair.Old[$key]
        }
    }
}
