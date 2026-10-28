Describe 'Health model: every compiled expedition slot' -Tag 'L2', 'integrity' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:slots = @(if ($script:bicepReady) {
                InModuleScope Catzc.Azure.Templates {
                    # Its own folder, so a concurrent build of the same template never swaps the files read here.
                    $outputFolder = @(Build-Bicep expedition -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'expedition'))[-1]
                    $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                    foreach ($slot in @((Get-BicepTemplate expedition).slots)) {
                        $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                        $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                        $values = @{}
                        foreach ($name in @($parameters.Keys)) {
                            $values[$name] = if ($parameters[$name].Contains('value')) {
                                $parameters[$name].value
                            }
                            else {
                                [Catzc.Azure.Templates.ArmExpression]::Unresolved
                            }
                        }
                        [pscustomobject]@{
                            Name      = $slot.name
                            Values    = $values
                            Main      = $main
                            Resources = @(Get-ArmDeployedResource -Template $main -Values $values | Where-Object { -not $_.Conditional })
                        }
                    }
                }
            })
    }

    It 'deploys one health workbook per slot, displayed by its derived wb name, with its health queries' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            $slot.Values.healthWorkbookName | Should -Match '-hlt-wb$' -Because "slot $($slot.Name) derives the workbook's display name with the wb type"
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/workbooks').Count | Should -Be 1 -Because "slot $($slot.Name) has its health workbook"
        }
        $resources = $script:slots[0].Main.resources
        $module = @(if ($resources -is [System.Collections.IDictionary]) {
                $resources.Values
            }
            else {
                $resources
            }) |
            Where-Object { $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -eq 'health-workbook' }
        @($module).Count | Should -Be 1
        $queries = $module.properties.template.variables.healthQueries | ConvertTo-Json -Depth 5
        foreach ($table in 'HealthResources', 'AzureActivity', 'AlertsManagementResources') {
            $queries | Should -BeLike "*$table*" -Because "the health workbook queries $table"
        }
    }
}
