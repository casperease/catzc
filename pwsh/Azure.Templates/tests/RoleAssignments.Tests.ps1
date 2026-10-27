Describe 'Role assignments: every compiled discovery slot assigns the declared set' -Tag 'L1', 'integrity' {
    BeforeAll {
        # Its own folder, so a concurrent build of the same template never swaps the files read here.
        $script:root = Join-Path (Get-PSDrive TestDrive).Root 'role-plan'
        $script:slots = @(InModuleScope Catzc.Azure.Templates -Parameters @{ Root = $script:root } {
                param($Root)
                $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path $Root 'discovery'))[-1]
                foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
                    $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                    [pscustomobject]@{
                        Coordinate = (@($slot.customer, $slot.environment, $slot.slot) | Where-Object { $_ }) -join '.'
                        Groups     = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters.groups.value
                    }
                }
            })
        $script:plan = @(Get-BicepRoleAssignmentPlan discovery -OutputRoot $script:root)
    }

    It 'assigns each slot exactly the readers'' and operators'' roles' {
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            $groupOf = @{}
            foreach ($key in @($slot.Groups.Keys)) {
                $groupOf["$($slot.Groups[$key])"] = $key
            }
            $actual = @($script:plan | Where-Object slot -EQ $slot.Coordinate | ForEach-Object {
                    $scope = if ($_.scope -like 'Microsoft.OperationalInsights/workspaces/*') {
                        'workspace'
                    }
                    else {
                        $_.scope
                    }
                    "$($groupOf[$_.principal]) $($_.role) $scope $([bool] $_.condition)"
                } | Sort-Object)
            $actual | Should -BeExactly @(
                'operators contributor subscription False'
                'operators rbac_administrator subscription True'
                'readers log_analytics_reader workspace False'
                'readers reader subscription False'
            ) -Because "slot $($slot.Coordinate) assigns the declared set"
        }
    }
}
