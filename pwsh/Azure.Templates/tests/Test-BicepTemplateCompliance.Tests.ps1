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
            [pscustomobject]@{ slots = @([pscustomobject]@{ name = 'prod'; environment = 'prod'; slot = ''; customer = '' }) }
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
        $untaggable = [Catzc.Azure.Templates.TemplateComplianceConfig]::new(@{ untaggable_types = @('Microsoft.Storage/storageAccounts') })
        $result = Test-BicepTemplateCompliance -Template widget -Config $untaggable -OutputFolder $out -PassThru
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
        InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $template } {
            param($Template)
            $widget = @(Get-ArmDeployedResource -Template $Template -Values @{ gadgets = @(@{ size = 'small' }, @{ size = 'large' }) } -Location 'widgetnorth')
            $widget.Count | Should -Be 1
            $widget[0].Name | Should -BeExactly 'widget-widgetnorth'
            $widget[0].Scope.sizes | Should -BeExactly @('small', 'large')
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved([Catzc.Azure.Templates.ArmExpression]::Evaluate(
                    $widget[0].Resource.location, $widget[0].Scope, $widget[0].Variables, $widget[0].Indexes, $widget[0].Deployment)) | Should -BeTrue
            $unplaced = @(Get-ArmDeployedResource -Template $Template -Values @{ gadgets = @() })
            [Catzc.Azure.Templates.ArmExpression]::IsUnresolved($unplaced[0].Name) | Should -BeTrue
            @($unplaced[0].Scope.sizes).Count | Should -Be 0
        }
    }
}

Describe 'Test-BicepTemplateCompliance (real templates)' -Tag 'L1', 'integrity' {
    It 'every compiled template slot holds to the compliance rules, but for the known findings, and every known finding still occurs' {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $known = (Get-Config -Config template-compliance).known_findings
        $result = Test-BicepTemplateCompliance -PassThru -OutputFolder (Join-Path $TestDrive 'compliance')
        $result.Facts['Resources'] | Should -BeGreaterThan 0
        $new = @($result.Issues | Where-Object { -not $known.ContainsKey($_) })
        $new | Should -BeNullOrEmpty -Because 'a finding not in known_findings is a regression (template-compliance.yml)'
        $stale = @($known.Keys | Where-Object { $_ -notin $result.Issues })
        $stale | Should -BeNullOrEmpty -Because 'a known finding that no longer occurs is closed: delete its known_findings entry'
    }
}
