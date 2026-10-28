Describe 'Remove-BicepOrphanResources' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:groupId = '/subscriptions/00000000-0000-0000-0000-00000000000a/resourceGroups/widget-rg/providers'
        $script:widgetTemplate = @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = @{ widgetName = @{ type = 'string' } }
            resources  = @(
                @{ type = 'Microsoft.Storage/storageAccounts'; name = "[parameters('widgetName')]" }
                @{ type = 'Microsoft.KeyVault/vaults'; name = 'widget-kv' }
            )
        }
        $script:gadgetTemplate = @{
            parameters = @{ widgetName = @{ type = 'string' } }
            resources  = @(
                @{ type = 'Microsoft.Storage/storageAccounts'; name = "[parameters('widgetName')]" }
                @{ type = 'Microsoft.Network/networkSecurityGroups'; name = "[format('{0}-nsg', uniqueString(parameters('widgetName')))]" }
            )
        }
        $script:parametersFile = Join-Path $TestDrive 'parameters.widget.json'
        [System.IO.File]::WriteAllText($script:parametersFile, '{ "parameters": { "widgetName": { "value": "widget-account" } } }')
        $script:widgetFile = Join-Path $TestDrive 'widget.json'
        [System.IO.File]::WriteAllText($script:widgetFile, ($script:widgetTemplate | ConvertTo-Json -Depth 10))
        $script:gadgetFile = Join-Path $TestDrive 'gadget.json'
        [System.IO.File]::WriteAllText($script:gadgetFile, ($script:gadgetTemplate | ConvertTo-Json -Depth 10))
        # The widget template with further resources, written beside it, for the cases a listing never returns.
        $script:writeWidgetTemplate = {
            param([string] $Name, [object[]] $Resources)
            $template = @{
                parameters = @{ widgetName = @{ type = 'string' } }
                resources  = @($script:widgetTemplate.resources) + $Resources
            }
            $file = Join-Path $TestDrive "$Name.json"
            [System.IO.File]::WriteAllText($file, ($template | ConvertTo-Json -Depth 10))
            $file
        }
        $script:unresolvedName = "[format('{0}-gadget', uniqueString(parameters('widgetName')))]"
    }

    BeforeEach {
        $script:calls = [System.Collections.Generic.List[string]]::new()
        $script:messages = [System.Collections.Generic.List[string]]::new()
        $script:templateFile = $script:widgetFile
        $script:target = 'ResourceGroup'
        $script:listExitCode = 0
        $script:listed = @(
            @{ id = "$groupId/Microsoft.Storage/storageAccounts/widget-account"; name = 'widget-account'; type = 'Microsoft.Storage/storageAccounts' }
            @{ id = "$groupId/Microsoft.KeyVault/vaults/widget-kv"; name = 'widget-kv'; type = 'Microsoft.KeyVault/vaults' }
        )
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'azure' } {
            [pscustomobject]@{ environments = @{ widget = @{} } }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'orphan-removal' } {
            [Catzc.Azure.Templates.OrphanRemovalConfig]::new($null)
        }
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Azure.Templates { $false }
        Mock Get-BicepDeploymentContext -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Environment, Template {
            [ordered]@{
                deployment  = [ordered]@{ target = $script:target; resource_group = 'widget-rg' }
                artifacts   = [ordered]@{ template_file = $script:templateFile; parameters_file = $script:parametersFile }
                environment = [ordered]@{
                    subscription = [ordered]@{ id = '00000000-0000-0000-0000-00000000000a' }
                    region       = 'widget-north'
                }
            }
        }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { $script:messages.Add("$Message") }
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Templates {
            $script:calls.Add($Arguments)
            if ($Arguments -like 'resource list *') {
                [pscustomobject]@{ ExitCode = $script:listExitCode; Output = (ConvertTo-Json -InputObject @($script:listed) -Depth 5); Errors = 'widget denied' }
            }
            else {
                [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' }
            }
        }
    }

    It 'lists the slot''s resource group in the session''s subscription' {
        Remove-BicepOrphanResources widget widget -DryRun | Out-Null
        $calls[0] | Should -BeExactly 'resource list --subscription 00000000-0000-0000-0000-00000000000a --resource-group widget-rg --output json'
    }

    It 'returns an orphan on a dry run and deletes nothing' {
        $script:listed += @{ id = "$groupId/Microsoft.Web/sites/gadget-old"; name = 'gadget-old'; type = 'Microsoft.Web/sites' }
        $orphans = @(Remove-BicepOrphanResources widget widget -DryRun)
        $orphans | Should -BeExactly @("$groupId/Microsoft.Web/sites/gadget-old")
        @($calls | Where-Object { $_ -like 'resource delete *' }).Count | Should -Be 0
    }

    It 'deletes an orphan by its id and returns it' {
        $script:listed += @{ id = "$groupId/Microsoft.Web/sites/gadget-old"; name = 'gadget-old'; type = 'Microsoft.Web/sites' }
        $deleted = @(Remove-BicepOrphanResources widget widget)
        $deleted | Should -BeExactly @("$groupId/Microsoft.Web/sites/gadget-old")
        $calls[1] | Should -BeExactly "resource delete --ids `"$groupId/Microsoft.Web/sites/gadget-old`" --output none"
        $messages | Should -Match 'Deleted .*gadget-old'
    }

    It 'keeps a resource whose name and type match the template, whatever their case' {
        $script:listed = @(@{ id = "$groupId/microsoft.storage/storageAccounts/WIDGET-ACCOUNT"; name = 'WIDGET-ACCOUNT'; type = 'microsoft.storage/storageAccounts' })
        @(Remove-BicepOrphanResources widget widget).Count | Should -Be 0
    }

    It 'treats a resource of the same name but another type as an orphan' {
        $script:listed += @{ id = "$groupId/Microsoft.Web/sites/widget-kv"; name = 'widget-kv'; type = 'Microsoft.Web/sites' }
        @(Remove-BicepOrphanResources widget widget -DryRun) | Should -BeExactly @("$groupId/Microsoft.Web/sites/widget-kv")
    }

    It 'does nothing when the group holds only what the template declares' {
        @(Remove-BicepOrphanResources widget widget).Count | Should -Be 0
        $calls.Count | Should -Be 1
        $messages | Should -Match 'holds nothing the template .widget. no longer declares'
    }

    It 'refuses to delete when a name does not resolve, lists the candidates and names the unresolved resource' {
        $script:templateFile = $script:gadgetFile
        $script:listed += @{ id = "$groupId/Microsoft.Network/networkSecurityGroups/widget-account-nsg"; name = 'widget-account-nsg'; type = 'Microsoft.Network/networkSecurityGroups' }
        $seen = [System.Collections.Generic.List[string]]::new()
        { Remove-BicepOrphanResources widget widget | ForEach-Object { $seen.Add($_) } } |
            Should -Throw '*deletes none*1 listable resources*main/networkSecurityGroups (Microsoft.Network/networkSecurityGroups)*'
        $seen | Should -Contain "$groupId/Microsoft.Network/networkSecurityGroups/widget-account-nsg"
        @($calls | Where-Object { $_ -like 'resource delete *' }).Count | Should -Be 0
    }

    It 'leaves an extension resource out of the comparison, and still deletes a listed orphan' {
        $script:templateFile = & $writeWidgetTemplate 'extension' @(
            @{ type = 'Microsoft.Insights/diagnosticSettings'; name = 'widget-diagnostics'; scope = "[resourceId('Microsoft.KeyVault/vaults', 'widget-kv')]" }
        )
        $script:listed += @{ id = "$groupId/Microsoft.Web/sites/gadget-old"; name = 'gadget-old'; type = 'Microsoft.Web/sites' }
        @(Remove-BicepOrphanResources widget widget) | Should -BeExactly @("$groupId/Microsoft.Web/sites/gadget-old")
        @($calls | Where-Object { $_ -like 'resource delete *' }).Count | Should -Be 1
    }

    It 'deletes despite an unresolved name on an extension resource' {
        $script:templateFile = & $writeWidgetTemplate 'extension-unresolved' @(
            @{ type = 'Microsoft.Authorization/locks'; name = $unresolvedName; scope = "[resourceId('Microsoft.KeyVault/vaults', 'widget-kv')]" }
        )
        $script:listed += @{ id = "$groupId/Microsoft.Web/sites/gadget-old"; name = 'gadget-old'; type = 'Microsoft.Web/sites' }
        @(Remove-BicepOrphanResources widget widget) | Should -BeExactly @("$groupId/Microsoft.Web/sites/gadget-old")
    }

    It 'leaves a child proxy out, unresolved name and all, but still refuses on an unresolved child with a location' {
        $script:templateFile = & $writeWidgetTemplate 'child-proxy' @(
            @{ type = 'Microsoft.Storage/storageAccounts/blobServices'; name = $unresolvedName }
        )
        @(Remove-BicepOrphanResources widget widget).Count | Should -Be 0
        $script:templateFile = & $writeWidgetTemplate 'child-located' @(
            @{ type = 'Microsoft.Sql/servers/databases'; name = $unresolvedName; location = 'westeurope' }
        )
        { Remove-BicepOrphanResources widget widget -DryRun } | Should -Throw '*1 listable resources*main/databases (Microsoft.Sql/servers/databases)*'
    }

    It 'resolves a name built from resourceId() in the listed group and subscription, so the deployed resource is kept' {
        # guid() of the workspace's id in widget-rg of subscription ...0a, as Bicep's own evaluator gives it (bicep snapshot 0.48.1).
        $workbook = '9ce68b74-0af1-5971-bdd4-430f34b1e23c'
        $template = @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            parameters = @{ widgetName = @{ type = 'string' } }
            resources  = @($script:widgetTemplate.resources) + @(
                @{ type = 'Microsoft.Insights/workbooks'; name = "[guid(resourceId('Microsoft.OperationalInsights/workspaces', 'widget-log'))]"; location = 'westeurope' }
            )
        }
        $script:templateFile = Join-Path $TestDrive 'workbook.json'
        [System.IO.File]::WriteAllText($script:templateFile, ($template | ConvertTo-Json -Depth 10))
        $script:listed += @{ id = "$groupId/Microsoft.Insights/workbooks/$workbook"; name = $workbook; type = 'Microsoft.Insights/workbooks' }
        $script:listed += @{ id = "$groupId/Microsoft.Insights/workbooks/gadget-old"; name = 'gadget-old'; type = 'Microsoft.Insights/workbooks' }
        @(Remove-BicepOrphanResources widget widget -DryRun) | Should -BeExactly @("$groupId/Microsoft.Insights/workbooks/gadget-old")
    }

    It 'skips a resource Azure creates itself, such as a SQL server''s master database' {
        $script:listed += @{ id = "$groupId/Microsoft.Sql/servers/widget-sql/databases/master"; name = 'widget-sql/master'; type = 'Microsoft.Sql/servers/databases' }
        @(Remove-BicepOrphanResources widget widget -DryRun).Count | Should -Be 0
        Should -Invoke Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'orphan-removal' }
    }

    It 'refuses a template deployed at subscription scope, before any call' {
        $script:target = 'Subscription'
        { Remove-BicepOrphanResources widget widget -DryRun } | Should -Throw '*deploys at Subscription scope*'
        $calls.Count | Should -Be 0
    }

    It 'does nothing for a DoNotRun template' {
        Mock Get-BicepDeploymentContext -ModuleName Catzc.Azure.Templates -RemoveParameterValidation Environment, Template { $null }
        @(Remove-BicepOrphanResources widget widget).Count | Should -Be 0
        $calls.Count | Should -Be 0
    }

    It 'requires -SubscriptionIdAssertIs in a pipeline' {
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Azure.Templates { $true }
        { Remove-BicepOrphanResources widget widget -DryRun } | Should -Throw '*requires -SubscriptionIdAssertIs in a pipeline*'
        $calls.Count | Should -Be 0
    }

    It 'passes the slot, the assert and the artifacts folder to the deployment context' {
        Remove-BicepOrphanResources widget widget -Slot blu -SubscriptionIdAssertIs '00000000-0000-0000-0000-00000000000a' -ArtifactsFolder $TestDrive -DryRun | Out-Null
        Should -Invoke Get-BicepDeploymentContext -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter {
            $Slot -eq 'blu' -and $SubscriptionIdAssertIs -eq '00000000-0000-0000-0000-00000000000a' -and $ArtifactsFolder -eq $TestDrive
        }
    }

    It 'reports the az exit code when the listing fails, and deletes nothing' {
        $script:listExitCode = 3
        { Remove-BicepOrphanResources widget widget } | Should -Throw '*widget-rg failed*exit code 3*widget denied*'
        $calls.Count | Should -Be 1
    }
}

Describe 'The orphan removal in the production deploy pipelines' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:pipelines = Join-Path (Get-RepositoryRoot) '.ado/pipelines'
    }

    It 'passes RemoveOrphans to every stage template of the prod and rollback path of <_>' -ForEach 'deploy-apex.yaml', 'deploy-shared.yaml' {
        $text = Get-Content -Raw (Join-Path $pipelines $_)
        $production = $text.Substring($text.IndexOf("in(parameters.Target, 'prod', 'rollback')"))
        $stages = ([regex]::Matches($production, 'template: /\.ado/pipelines/stages/deploy-unit\.yaml')).Count
        $stages | Should -BeGreaterThan 0
        ([regex]::Matches($production, 'RemoveOrphans: true')).Count | Should -Be $stages
        $release = $text.Substring(0, $text.IndexOf("in(parameters.Target, 'prod', 'rollback')"))
        $release | Should -Not -Match 'RemoveOrphans'
    }

    It 'runs the -DryRun listing, then the removal, after the deploy of every <Template> job' -ForEach @(
        @{ Template = 'foundation'; Stage = 'stages/deploy-unit.yaml' }
        @{ Template = 'expedition'; Stage = 'stages/deploy-expedition.yaml' }
    ) {
        $text = Get-Content -Raw (Join-Path $pipelines $Stage)
        $jobs = @($text -split '- deployment: ' | Where-Object { $_ -match "-Template $template " })
        $jobs.Count | Should -BeGreaterThan 0
        foreach ($job in $jobs) {
            $deploy = $job.LastIndexOf("'Deploy-Bicep -Environment")
            $deploy | Should -BeGreaterThan 0
            $preview = $job.IndexOf("'Remove-BicepOrphanResources -Environment")
            $preview | Should -BeGreaterThan $deploy
            $removal = $job.IndexOf("'Remove-BicepOrphanResources -Environment", $preview + 1)
            $removal | Should -BeGreaterThan $preview
            $job.Substring($preview, $removal - $preview) | Should -Match '-DryRun'
            $job.Substring($removal) | Should -Not -Match '-DryRun'
            $job | Should -Match '\$\{\{ if parameters\.RemoveOrphans \}\}'
        }
    }

    It 'passes RemoveOrphans on from the unit''s deploy path to its expedition stage template' {
        $text = Get-Content -Raw (Join-Path $pipelines 'stages/deploy-unit.yaml')
        $call = $text.Substring($text.IndexOf('template: /.ado/pipelines/stages/deploy-expedition.yaml'))
        $call | Should -Match 'RemoveOrphans: \$\{\{ parameters\.RemoveOrphans \}\}'
    }
}
