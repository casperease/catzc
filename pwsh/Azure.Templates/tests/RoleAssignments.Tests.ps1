Describe 'Role assignments: every compiled discovery and expedition slot assigns the declared set' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real builds run only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        # Its own folder, so a concurrent build of the same template never swaps the files read here.
        $script:root = Join-Path (Get-PSDrive TestDrive).Root 'role-plan'
        $script:slots = @(if ($script:bicepReady) {
                InModuleScope Catzc.Azure.Templates -Parameters @{ Root = $script:root } {
                    param($Root)
                    $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path $Root 'discovery'))[-1]
                    foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
                        $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                        [pscustomobject]@{
                            Coordinate = (@($slot.customer, $slot.environment, $slot.slot) | Where-Object { $_ }) -join '.'
                            Groups     = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters.groups.value
                        }
                    }
                }
            })
        $script:plan = @(if ($script:bicepReady) {
                Get-BicepRoleAssignmentPlan discovery -OutputRoot $script:root
            })
    }

    It 'assigns each slot exactly the readers'' and operators'' roles' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
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

    It 'assigns each expedition slot the data roles of the groups it declares, on its account and on foundation''s vault' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $root = Join-Path (Get-PSDrive TestDrive).Root 'role-plan-expedition'
        $slots = @(InModuleScope Catzc.Azure.Templates -Parameters @{ Root = $root } {
                param($Root)
                $outputFolder = @(Build-Bicep expedition -OutputFolder (Join-Path $Root 'expedition'))[-1]
                foreach ($slot in @((Get-BicepTemplate expedition).slots)) {
                    $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                    [pscustomobject]@{
                        Coordinate = (@($slot.customer, $slot.environment, $slot.slot) | Where-Object { $_ }) -join '.'
                        Groups     = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters.groups.value
                    }
                }
            })
        $plan = @(Get-BicepRoleAssignmentPlan expedition -OutputRoot $root)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            $groupOf = @{}
            $expected = [System.Collections.Generic.List[string]]::new()
            foreach ($key in @($slot.Groups.Keys)) {
                $groupOf["$($slot.Groups[$key])"] = $key
            }
            if ($slot.Groups['data_readers']) {
                $expected.Add('data_readers storage_blob_data_reader storageAccount')
            }
            if ($slot.Groups['data_writers']) {
                $expected.Add('data_writers key_vault_secrets_user keyVault')
                $expected.Add('data_writers storage_blob_data_contributor storageAccount')
            }
            $actual = @($plan | Where-Object slot -EQ $slot.Coordinate | ForEach-Object {
                    $scope = if ($_.scope -like 'Microsoft.Storage/storageAccounts/*') {
                        'storageAccount'
                    }
                    elseif ($_.scope -like 'Microsoft.KeyVault/vaults/*') {
                        'keyVault'
                    }
                    else {
                        $_.scope
                    }
                    "$($groupOf[$_.principal]) $($_.role) $scope"
                } | Sort-Object)
            $actual | Should -BeExactly @($expected | Sort-Object) -Because "slot $($slot.Coordinate) assigns the data roles of its declared groups"
        }
    }
}
