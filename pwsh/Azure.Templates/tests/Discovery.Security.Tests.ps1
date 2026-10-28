Describe 'discovery security: every compiled slot' -Tag 'L2', 'integrity' {
    BeforeAll {
        # The bicep binary is resolved once for the file; the real build runs only when it is there.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk

        $script:slots = @(if ($script:bicepReady) {
                InModuleScope Catzc.Azure.Templates {
                    # Its own folder, so a concurrent build of the same template never swaps the files read here.
                    $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'discovery'))[-1]
                    $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                    $environments = (Get-Config -Config azure).environments
                    foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
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
                            # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                            Resources = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region |
                                    Where-Object { -not $_.Conditional })
                        }
                    }
                }
            })
    }

    It 'turns on Defender for Cloud plans in every slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Security/pricings').Count | Should -BeGreaterThan 0 -Because "slot $($slot.Name) turns on Defender plans"
        }
    }

    It 'assigns the Microsoft cloud security benchmark in audit mode in every slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        foreach ($slot in $script:slots) {
            $benchmark = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/policyAssignments' | Where-Object {
                    "$([Catzc.Azure.Templates.ArmExpression]::Evaluate($_.Resource.properties.policyDefinitionId, $_.Scope, $_.Variables))" -like '*1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
                })
            $benchmark.Count | Should -Be 1 -Because "slot $($slot.Name) assigns the benchmark once"
            [Catzc.Azure.Templates.ArmExpression]::Evaluate($benchmark[0].Resource.properties.enforcementMode, $benchmark[0].Scope, $benchmark[0].Variables) |
                Should -Be 'DoNotEnforce' -Because "slot $($slot.Name)'s benchmark audits and never denies"
        }
    }

    It 'allows exactly the resource types the shared modules declare in every slot' {
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        $declared = @(InModuleScope Catzc.Azure.Templates { Get-BicepModuleResourceTypes })
        $declared.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            $allowed = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/policyAssignments' | Where-Object {
                    "$([Catzc.Azure.Templates.ArmExpression]::Evaluate($_.Resource.properties.policyDefinitionId, $_.Scope, $_.Variables))" -like '*a08ec900-254a-4555-9bf5-e42af04b5c5c'
                })
            $allowed.Count | Should -Be 1 -Because "slot $($slot.Name) assigns the allowed resource types once"
            $parameters = [Catzc.Azure.Templates.ArmExpression]::Evaluate($allowed[0].Resource.properties.parameters, $allowed[0].Scope, $allowed[0].Variables)
            @($parameters.listOfResourceTypesAllowed.value) | Should -Be $declared -Because "slot $($slot.Name) allows the modules' types, derived at build time"
        }
    }
}
