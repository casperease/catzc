Describe 'Monitoring views: every compiled foundation slot' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:slots = @(InModuleScope Catzc.Azure.Templates {
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep foundation -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'foundation'))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                foreach ($slot in @((Get-BicepTemplate foundation).slots)) {
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
                        Name      = $slot.name
                        Values    = $values
                        Resources = @(Get-ArmDeployedResource -Template $main -Values $values | Where-Object { -not $_.Conditional })
                    }
                }
            })
        # The evaluator labels each resource by its resolved name, the last segment of its path.
        $script:nameOf = { param($Resource) ($Resource.Path -split '/')[-1] }
    }

    It 'deploys the capacity workbook in every slot, displayed by its derived wb name' {
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            $slot.Values.capacityWorkbookName | Should -Match '-wb$' -Because "slot $($slot.Name) derives the workbook's display name with the wb type"
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/workbooks').Count | Should -Be 1 -Because "slot $($slot.Name) has its capacity workbook"
        }
    }

    It 'deploys the saved-query pack in every slot, named by its derived pack name' {
        foreach ($slot in $script:slots) {
            $slot.Values.queryPackName | Should -Match '-pack$' -Because "slot $($slot.Name) derives the query pack's name with the pack type"
            @($slot.Resources | Where-Object { $_.Type -eq 'Microsoft.OperationalInsights/queryPacks' -and (& $script:nameOf $_) -eq $slot.Values.queryPackName }).Count |
                Should -Be 1 -Because "slot $($slot.Name) has its query pack"
        }
    }

    It 'deploys the dashboard in every slot, named by its derived dash name' {
        foreach ($slot in $script:slots) {
            $slot.Values.dashboardName | Should -Match '-dash$' -Because "slot $($slot.Name) derives the dashboard's name with the dash type"
            @($slot.Resources | Where-Object { $_.Type -eq 'Microsoft.Portal/dashboards' -and (& $script:nameOf $_) -eq $slot.Values.dashboardName }).Count |
                Should -Be 1 -Because "slot $($slot.Name) has its dashboard"
        }
    }
}
