Describe 'Production database alerts: every compiled expedition and discovery slot' -Tag 'L2', 'integrity' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real builds run only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:slotsOf = {
            param([string] $Template)
            InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $Template } {
                param($Template)
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep $Template -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root $Template))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                $environments = (Get-Config -Config azure).environments
                foreach ($slot in @((Get-BicepTemplate $Template).slots)) {
                    $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                    $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                    $values = @{}
                    # A Key Vault reference carries no value, so it is passed as unresolved, as the compliance check does.
                    foreach ($name in @($parameters.Keys)) {
                        $values[$name] = if ($parameters[$name].Contains('value')) {
                            $parameters[$name].value
                        }
                        else {
                            [Catzc.Azure.Templates.ArmExpression]::Unresolved
                        }
                    }
                    [pscustomobject]@{
                        Name       = $slot.name
                        Production = [bool]$environments[$slot.environment].production
                        Values     = $values
                        # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                        Resources  = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region |
                                Where-Object { -not $_.Conditional })
                    }
                }
            }
        }
        # The evaluator labels each resource by its resolved name, the last segment of its path.
        $script:nameOf = { param($Resource) ($Resource.Path -split '/')[-1] }
        $script:expedition = @(if ($script:bicepReady) {
                & $script:slotsOf expedition
            })
        $script:discovery = @(if ($script:bicepReady) {
                & $script:slotsOf discovery
            })
    }

    It 'deploys the five database metric and capacity alerts in every production slot, and in no other slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        @($script:expedition | Where-Object Production).Count | Should -BeGreaterThan 0 -Because 'a production expedition slot exists to prove it'
        foreach ($slot in $script:expedition) {
            $alerts = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/metricAlerts')
            $expected = if ($slot.Production) {
                5
            }
            else {
                0
            }
            $alerts.Count | Should -Be $expected -Because "slot $($slot.Name) is $(if ($slot.Production) { 'production' } else { 'not production' })"
        }
    }

    It 'names each database alert through the namer: every deployed alert carries one of the slot''s derived alert names' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in $script:expedition) {
            @($slot.Values.databaseMetricAlertNames.Keys | Sort-Object) | Should -Be @('cpu', 'deadlock', 'failedConnection')
            @($slot.Values.databaseCapacityAlertNames.Keys | Sort-Object) | Should -Be @('compute', 'storage')
            $derived = @(@($slot.Values.databaseMetricAlertNames.Values) + @($slot.Values.databaseCapacityAlertNames.Values))
            foreach ($name in $derived) {
                $name | Should -Match '-alert$' -Because "slot $($slot.Name) derives its alert names with the alert type"
            }
            # The evaluator follows the object parameters into the alert modules, so each deployed name is its resolved value.
            $deployed = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/metricAlerts' | ForEach-Object Name)
            foreach ($name in $deployed) {
                $name | Should -BeIn $derived -Because "slot $($slot.Name) names each deployed alert from its derived names"
            }
            @($deployed | Sort-Object -Unique).Count | Should -Be $deployed.Count -Because "slot $($slot.Name) names each alert once"
        }
    }

    It 'names the break-glass login alert through the namer in every slot with a break-glass login' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in @($script:expedition | Where-Object { $_.Values.administratorLogin })) {
            @($slot.Resources | Where-Object { $_.Type -eq 'Microsoft.Insights/scheduledQueryRules' -and (& $script:nameOf $_) -eq $slot.Values.breakGlassLoginAlertName }).Count |
                Should -Be 1 -Because "slot $($slot.Name) names its login alert"
        }
    }

    It 'names the two health alerts through the namer in every discovery slot, bound by category' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in $script:discovery) {
            @($slot.Values.healthAlertNames.Keys | Sort-Object) | Should -Be @('ResourceHealth', 'ServiceHealth')
            foreach ($name in @($slot.Values.healthAlertNames.Values)) {
                $name | Should -Match '-alert$' -Because "slot $($slot.Name) derives its health alert names with the alert type"
            }
            # The health alerts are a copy over their categories; each instance's name resolves to that category's derived name.
            $deployed = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/activityLogAlerts' | ForEach-Object Name | Sort-Object)
            $deployed | Should -Be @($slot.Values.healthAlertNames.Values | Sort-Object) -Because "slot $($slot.Name) names one health alert per category"
        }
    }
}
