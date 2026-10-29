Describe 'Test-BicepTemplateCompliance' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'
        $script:built = Join-Path $TestDrive 'built'
        $null = New-Item -ItemType Directory -Path $built -Force
        $script:tags = [ordered]@{ workload = 'w'; environment = 'prod'; owner = 'o'; 'cost-center' = 'c'; criticality = 'high'; 'data-classification' = 'internal' }
        $script:config = [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{})

        # A widget store in a nested deployment, its diagnostic setting picked by condition like diagnostic-setting.bicep.
        $script:writeTemplate = {
            param([string] $Access = "[parameters('publicNetworkAccess')]", [object] $ResourceTags = "[parameters('tags')]", [string] $Kind = 'storageAccount')
            $storage = [ordered]@{
                type = 'Microsoft.Storage/storageAccounts'; name = "[parameters('name')]"; tags = $ResourceTags
                properties = [ordered]@{ publicNetworkAccess = $Access; minimumTlsVersion = 'TLS1_2' }
            }
            $diagnostics = [ordered]@{
                type = 'Microsoft.Insights/diagnosticSettings'; name = 'widget-diag'; condition = "[equals(parameters('resourceKind'), 'storageAccount')]"
                scope = "[resourceId('Microsoft.Storage/storageAccounts', parameters('resourceName'))]"
            }
            $main = [ordered]@{
                parameters = [ordered]@{ tags = @{ type = 'object' } }
                resources  = @(
                    [ordered]@{
                        type = 'Microsoft.Resources/deployments'; name = 'widget-store'
                        properties = [ordered]@{
                            parameters = [ordered]@{ tags = @{ value = "[parameters('tags')]" }; name = @{ value = 'widgetstore' } }
                            template   = [ordered]@{
                                parameters = [ordered]@{ tags = @{ type = 'object' }; name = @{ type = 'string' }; publicNetworkAccess = @{ type = 'string'; defaultValue = 'Disabled' } }
                                resources  = @($storage)
                            }
                        }
                    }
                    [ordered]@{
                        type = 'Microsoft.Resources/deployments'; name = 'widget-diagnostics'
                        properties = [ordered]@{
                            parameters = [ordered]@{ resourceKind = @{ value = $Kind }; resourceName = @{ value = 'widgetstore' } }
                            template   = [ordered]@{ parameters = [ordered]@{ resourceKind = @{ type = 'string' }; resourceName = @{ type = 'string' } }; resources = @($diagnostics) }
                        }
                    }
                )
            }
            Set-Content (Join-Path $built 'main.json') ($main | ConvertTo-Json -Depth 20)
            Set-Content (Join-Path $built 'parameters.prod.json') (@{ parameters = @{ tags = @{ value = $tags } } } | ConvertTo-Json -Depth 10)
        }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        # A mock keeps Build-Bicep's own -Template validation, so the fixture template is a known name.
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
        Mock Build-Bicep -ModuleName Catzc.Azure.Templates { $built }
        Mock Get-BicepTemplate -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{
                name              = 'widget'
                deployment_target = 'Subscription'
                slots             = @([pscustomobject]@{ name = 'prod'; environment = 'prod'; slot = ''; customer = ''; subscription = '' })
            }
        }
        Mock Get-BicepParametersFileName -ModuleName Catzc.Azure.Templates { 'parameters.prod.json' }
    }

    It 'passes a store with its CAF tags, access off by default, TLS 1.2 and a diagnostic setting' {
        & $writeTemplate
        $result = Test-BicepTemplateCompliance -Template widget -Config $config -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Resources'] | Should -Be 2
    }

    It 'reports public access on, a missing tag and a kind with no diagnostic setting' {
        $partial = [ordered]@{ workload = 'w' }
        & $writeTemplate -Access 'Enabled' -ResourceTags $partial -Kind 'keyVault'
        $result = Test-BicepTemplateCompliance -Template widget -Config $config -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 3
        ($result.Issues -join "`n") | Should -BeLike '*publicNetworkAccess is Enabled*'
        ($result.Issues -join "`n") | Should -BeLike '*misses the CAF tag(s) environment, owner*'
        ($result.Issues -join "`n") | Should -BeLike '*no diagnostic setting is scoped to this resource kind*'
    }

    It 'checks the tags of every kind not declared untaggable, so a new kind is checked from its first compile' {
        & $writeTemplate -ResourceTags $null
        $result = Test-BicepTemplateCompliance -Template widget -Config $config -OutputFolder $out -PassThru
        $result.Issues | Should -BeLike '*(Microsoft.Storage/storageAccounts): *tags*'
        $storageWithoutTags = [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ untaggable_types = @('Microsoft.Storage/storageAccounts') })
        $result = Test-BicepTemplateCompliance -Template widget -Config $storageWithoutTags -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }

    It 'holds every resource of a type to its declared property rules, a copy loop''s input for every instance: <case>' -ForEach @(
        @{ case = 'held'; outbound = $false; withPublicIp = $false; expected = @() }
        @{ case = 'broken'; outbound = $true; withPublicIp = $true; expected = @(
                '*properties.subnets`[`*`].properties.defaultOutboundAccess is ''True'', not ''False''*'
                '*properties.ipConfigurations`[`*`].properties.publicIPAddress is set*'
            )
        }
    ) {
        $ipConfiguration = [ordered]@{ properties = [ordered]@{ subnet = @{ id = 'widget-subnet' } } }
        if ($withPublicIp) {
            $ipConfiguration.properties.publicIPAddress = @{ id = 'widget-ip' }
        }
        $main = [ordered]@{
            parameters = [ordered]@{ tags = @{ type = 'object' } }
            resources  = @(
                [ordered]@{
                    type = 'Microsoft.Network/virtualNetworks'; name = 'widget-net'; tags = "[parameters('tags')]"
                    properties = [ordered]@{
                        copy = @([ordered]@{ name = 'subnets'; count = 2; input = [ordered]@{ name = "[format('gadget-{0}', copyIndex('subnets'))]"; properties = [ordered]@{ defaultOutboundAccess = $outbound } } })
                    }
                }
                [ordered]@{
                    type = 'Microsoft.Network/networkInterfaces'; name = 'widget-nic'; tags = "[parameters('tags')]"
                    properties = [ordered]@{ ipConfigurations = @($ipConfiguration) }
                }
            )
        }
        Set-Content (Join-Path $built 'main.json') ($main | ConvertTo-Json -Depth 20)
        Set-Content (Join-Path $built 'parameters.prod.json') (@{ parameters = @{ tags = @{ value = $tags } } } | ConvertTo-Json -Depth 10)
        $rules = [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ diagnostic_types = @('Microsoft.Storage/storageAccounts') })
        $result = Test-BicepTemplateCompliance -Template widget -Config $rules -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be $expected.Count -Because ($result.Issues -join "`n")
        foreach ($pattern in $expected) {
            ($result.Issues -join "`n") | Should -BeLike $pattern
        }
    }

    It 'rejects a property rule without its reason, or with both equals and absent' {
        { [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ property_rules = @(@{ type = 'widget'; path = 'gadget' ; equals = 1 }) }) } |
            Should -Throw '*property_rules`[0`] must name a type, a path and a reason*'
        { [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ property_rules = @(@{ type = 'widget'; path = 'gadget'; equals = 1; absent = $true; reason = 'r' }) }) } |
            Should -Throw '*exactly one of equals and absent*'
    }

    It 'reports a value outside the evaluator as unresolved, never as a pass' {
        & $writeTemplate -Access "[reference('gadget').outputs.access.value]"
        $result = Test-BicepTemplateCompliance -Template widget -Config $config -OutputFolder $out -PassThru
        $result.Issues | Should -Be @('widget/prod: main/widget-store/widgetstore (Microsoft.Storage/storageAccounts): publicNetworkAccess does not resolve')
    }

    It 'rejects a config with an unknown key, or a known finding without its step or listed twice' {
        { [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ widget = 1 }) } | Should -Throw "*unknown top-level key 'widget'*"
        { [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ known_findings = @(@{ finding = 'widget' }) }) } |
            Should -Throw '*known_findings`[0`] must hold exactly a finding and the step*'
        $twice = @(@{ finding = 'widget'; step = 'gadget' }, @{ finding = 'widget'; step = 'gadget' })
        { [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ known_findings = $twice }) } | Should -Throw "*duplicate finding 'widget'*"
    }
}

Describe 'Get-ArmDeployedResource' -Tag 'L0', 'logic' {
    BeforeAll {
        # A hub-only zone list, as Bicep compiles `for zone in (isHub ? zones : [])`, and a hub-only nested deployment.
        $script:template = [ordered]@{
            parameters = [ordered]@{ networkKind = @{ type = 'string' }; widgetKind = @{ type = 'string' } }
            variables  = [ordered]@{ isHub = "[equals(parameters('networkKind'), 'hub')]"; zoneNames = "[createArray('widget', 'gadget')]" }
            resources  = @(
                [ordered]@{
                    type = 'Microsoft.Network/privateDnsZones'; name = "[variables('zoneNames')[copyIndex()]]"
                    copy = [ordered]@{ name = 'zones'; count = "[length(if(variables('isHub'), variables('zoneNames'), createArray()))]" }
                }
                [ordered]@{
                    type = 'Microsoft.Resources/deployments'; name = 'sprocket-lock'; condition = "[equals(parameters('widgetKind'), 'locked')]"
                    properties = [ordered]@{ template = [ordered]@{ resources = @([ordered]@{ type = 'Microsoft.Authorization/locks'; name = 'do-not-delete' }) } }
                }
            )
        }
    }

    It 'deploys a copy over an empty array not at all, and a copy over a non-empty one once per instance, named by its copyIndex()' {
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            @(Get-ArmDeployedResource -Template $Template -Values @{ networkKind = 'spoke'; widgetKind = 'open' } |
                    Where-Object Type -EQ 'Microsoft.Network/privateDnsZones').Count | Should -Be 0
            $hub = @(Get-ArmDeployedResource -Template $Template -Values @{ networkKind = 'hub'; widgetKind = 'open' } |
                    Where-Object Type -EQ 'Microsoft.Network/privateDnsZones')
            @($hub.Name) | Should -Be @('widget', 'gadget')
            @($hub | Where-Object Conditional).Count | Should -Be 0
        }
    }

    It 'carries a nested deployment''s unresolved condition into its resources' {
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            $locks = @(Get-ArmDeployedResource -Template $Template -Values @{ networkKind = 'hub' } |
                    Where-Object Type -EQ 'Microsoft.Authorization/locks')
            $locks.Count | Should -Be 1
            $locks[0].Conditional | Should -BeTrue
            @(Get-ArmDeployedResource -Template $Template -Values @{ networkKind = 'hub'; widgetKind = 'open' } |
                    Where-Object Type -EQ 'Microsoft.Authorization/locks').Count | Should -Be 0
        }
    }

    It 'reads deployment().location from -Location above resource-group scope, and passes a for-expression module parameter as its array' {
        # A subscription template whose location defaults to deployment().location, passed with a looped list to a resource-group module.
        $nested = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = [ordered]@{ location = @{ type = 'string' }; sizes = @{ type = 'array' } }
            resources  = @([ordered]@{ type = 'Widget.Parts/widgets'; name = "[concat('widget-', parameters('location'))]"; location = '[deployment().location]' })
        }
        $template = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = [ordered]@{ location = @{ type = 'string'; defaultValue = '[deployment().location]' }; gadgets = @{ type = 'array' } }
            resources  = @([ordered]@{
                    type       = 'Microsoft.Resources/deployments'; name = 'widgets'; resourceGroup = 'widget-rg'
                    properties = [ordered]@{
                        template   = $nested
                        parameters = [ordered]@{
                            location = @{ value = "[parameters('location')]" }
                            sizes    = @{ copy = @(@{ name = 'value'; count = "[length(parameters('gadgets'))]"; input = "[parameters('gadgets')[copyIndex('value')].size]" }) }
                        }
                    }
                })
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Nested = $nested } {
            param($Template, $Nested)
            $widget = @(Get-ArmDeployedResource -Template $Template -Values @{ gadgets = @(@{ size = 'small' }, @{ size = 'large' }) } -Location 'widget-north')
            $widget.Count | Should -Be 1
            $widget[0].Name | Should -BeExactly 'widget-widget-north'
            $widget[0].Scope.sizes | Should -BeExactly @('small', 'large')
            # The nested deployment's resource group rides on each of its records; a top-level record has the deployment's own, ''.
            $widget[0].ResourceGroup | Should -BeExactly 'widget-rg'
            (Get-ArmDeployedResource -Template $Nested -Values @{ location = 'widget-north' } | Select-Object -First 1).ResourceGroup | Should -BeExactly ''
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved([Catzc.Azure.Templates.ArmExpression]::Evaluate(
                    $widget[0].Resource.location, $widget[0].Scope, $widget[0].Variables, $widget[0].Indexes, $widget[0].Deployment)) | Should -BeTrue
            $unplaced = @(Get-ArmDeployedResource -Template $Template -Values @{ gadgets = @() })
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($unplaced[0].Name) | Should -BeTrue
            @($unplaced[0].Scope.sizes).Count | Should -Be 0
        }
    }

    It 'threads -SubscriptionId and -ResourceGroupName into resourceId(), a nested deployment''s group and subscription overriding them' {
        # The expected ids are Bicep's own evaluator's (bicep snapshot 0.48.1 with --subscription-id and --resource-group), not this type's.
        $leaf = [ordered]@{
            '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            resources = @([ordered]@{ type = 'Microsoft.Insights/workbooks'; name = "[guid(resourceId('Microsoft.OperationalInsights/workspaces', 'widget-log'))]" })
        }
        $template = [ordered]@{
            '$schema' = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            resources = @(
                [ordered]@{ type = 'Widget.Parts/widgets'; name = "[resourceId('Widget.Parts/widgets', 'gadget')]" }
                [ordered]@{ type = 'Microsoft.Resources/deployments'; name = 'grouped'; resourceGroup = 'widget-group'; properties = [ordered]@{ template = $leaf } }
                [ordered]@{ type = 'Microsoft.Resources/deployments'; name = 'elsewhere'; resourceGroup = 'widget-rg'; subscriptionId = '00000000-0000-0000-0000-00000000000a'; properties = [ordered]@{ template = $leaf } }
                [ordered]@{ type = 'Microsoft.Resources/deployments'; name = 'unplaced'; resourceGroup = "[parameters('missing')]"; properties = [ordered]@{ template = $leaf } }
            )
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template; Leaf = $leaf } {
            param($Template, $Leaf)
            $items = @(Get-ArmDeployedResource -Template $Template -Values @{} -SubscriptionId '50a0ed00-de00-50b0-0000-000000000000' -ResourceGroupName 'widget-ignored')
            $items.Count | Should -Be 4
            # A subscription template has no resource group of its own, so its resourceId() stays unresolved, never guessed.
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($items[0].Name) | Should -BeTrue
            $items[1].Name | Should -BeExactly 'd61bf936-8844-5b06-b159-3f2725eb4720'
            $items[2].Name | Should -BeExactly '9ce68b74-0af1-5971-bdd4-430f34b1e23c'
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($items[3].Name) | Should -BeTrue
            $scoped = Get-ArmDeployedResource -Template $Leaf -Values @{} -SubscriptionId '00000000-0000-0000-0000-00000000000a' -ResourceGroupName 'widget-rg' |
                Select-Object -First 1
            $scoped.Name | Should -BeExactly '9ce68b74-0af1-5971-bdd4-430f34b1e23c'
            $withoutSubscription = Get-ArmDeployedResource -Template $Leaf -Values @{} -ResourceGroupName 'widget-rg' | Select-Object -First 1
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($withoutSubscription.Name) | Should -BeTrue
        }
    }

    It 'reads a module output a parent passes on, as Bicep compiles it, from the nested deployment''s evaluated outputs, and never a runtime one' {
        # The expected values are Bicep's own evaluator's (bicep snapshot 0.48.1 with --subscription-id and --resource-group), not this type's.
        $dependency = '[resourceId(''Microsoft.Resources/deployments'', ''{0}'')]'
        $output = '[reference(resourceId(''Microsoft.Resources/deployments'', ''gadget''), ''2025-04-01'').outputs.{0}.value]'
        $gadget = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = [ordered]@{ name = @{ type = 'string' } }
            resources  = @([ordered]@{ type = 'Microsoft.OperationalInsights/workspaces'; name = "[parameters('name')]"; location = 'westeurope' })
            outputs    = [ordered]@{
                id         = @{ type = 'string'; value = "[resourceId('Microsoft.OperationalInsights/workspaces', parameters('name'))]" }
                name       = @{ type = 'string'; value = "[parameters('name')]" }
                customerId = @{ type = 'string'; value = "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('name')), '2025-02-01').customerId]" }
            }
        }
        $gizmo = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = [ordered]@{ workspaceId = @{ type = 'string' }; owner = @{ type = 'string' }; sourceId = @{ type = 'string' } }
            resources  = @([ordered]@{
                    type = 'Microsoft.Insights/workbooks'; name = "[guid(parameters('workspaceId'))]"; tags = @{ owner = "[parameters('owner')]" }
                    properties = [ordered]@{ sourceId = "[parameters('sourceId')]" }
                })
        }
        $template = [ordered]@{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = [ordered]@{ withSprocket = @{ type = 'bool'; defaultValue = $true } }
            resources  = @(
                [ordered]@{ type = 'Microsoft.Resources/deployments'; name = 'gadget'; properties = [ordered]@{ template = $gadget; parameters = @{ name = @{ value = 'widget-log' } } } }
                [ordered]@{
                    condition = "[parameters('withSprocket')]"; type = 'Microsoft.Resources/deployments'; name = 'sprocket'
                    properties = [ordered]@{ template = $gadget; parameters = @{ name = @{ value = 'sprocket-log' } } }
                }
                [ordered]@{
                    type = 'Microsoft.Resources/deployments'; name = 'by-id'; dependsOn = @(($dependency -f 'gadget'), ($dependency -f 'sprocket'))
                    properties = [ordered]@{
                        template   = $gizmo
                        parameters = [ordered]@{
                            workspaceId = @{ value = $output -f 'id' }
                            owner       = @{ value = $output -f 'name' }
                            sourceId    = @{ value = "[coalesce(tryGet(if(parameters('withSprocket'), reference(resourceId('Microsoft.Resources/deployments', 'sprocket'), '2025-04-01'), null()), 'outputs', 'id', 'value'), '')]" }
                        }
                    }
                }
                [ordered]@{
                    type = 'Microsoft.Resources/deployments'; name = 'by-runtime'; dependsOn = @($dependency -f 'gadget')
                    properties = [ordered]@{
                        template   = $gizmo
                        parameters = [ordered]@{ workspaceId = @{ value = $output -f 'customerId' }; owner = @{ value = 'widget' }; sourceId = @{ value = '' } }
                    }
                }
            )
        }
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            $facts = @{ SubscriptionId = '50a0ed00-de00-50b0-0000-000000000000'; ResourceGroupName = 'widget-group' }
            $workbooks = @(Get-ArmDeployedResource -Template $Template -Values @{} @facts | Where-Object Type -EQ 'Microsoft.Insights/workbooks')
            $workbooks.Count | Should -Be 2
            $workbooks[0].Name | Should -BeExactly 'd61bf936-8844-5b06-b159-3f2725eb4720'
            $workbooks[0].Scope.owner | Should -BeExactly 'widget-log'
            $workbooks[0].Scope.sourceId | Should -BeExactly '/subscriptions/50a0ed00-de00-50b0-0000-000000000000/resourceGroups/widget-group/providers/Microsoft.OperationalInsights/workspaces/sprocket-log'
            # The workspace's customerId exists only once it is deployed, so the name over it stays unresolved.
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($workbooks[1].Name) | Should -BeTrue
            $without = @(Get-ArmDeployedResource -Template $Template -Values @{ withSprocket = $false } @facts | Where-Object Type -EQ 'Microsoft.Insights/workbooks')
            $without[0].Scope.sourceId | Should -BeExactly ''
            # Without the slot's facts the deployments have no id, so no output is read.
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved(@(Get-ArmDeployedResource -Template $Template -Values @{})[2].Name) | Should -BeTrue
        }
    }
}

Describe 'Test-BicepTemplateCompliance (real templates)' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk
        if ($script:bicepReady) {
            $script:result = Test-BicepTemplateCompliance -PassThru -OutputFolder (Join-Path $TestDrive 'compliance')
        }
    }

    It 'every compiled template slot holds to the compliance rules, but for the known findings, and every known finding still occurs' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $known = (Get-Config -Config template-compliance).known_findings
        $result = $script:result
        $result.Facts['Resources'] | Should -BeGreaterThan 0
        $new = @($result.Issues | Where-Object { -not $known.ContainsKey($_) })
        $new | Should -BeNullOrEmpty -Because 'a finding not in known_findings is a regression (template-compliance.yml)'
        $stale = @($known.Keys | Where-Object { $_ -notin $result.Issues })
        $stale | Should -BeNullOrEmpty -Because 'a known finding that no longer occurs is closed: delete its known_findings entry'
    }
}
