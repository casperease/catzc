Describe 'discovery security: every compiled slot' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:slots = @(InModuleScope Catzc.Azure.Templates {
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep discovery -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'discovery'))[-1]
                $main = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json')) | ConvertFrom-Json -AsHashtable
                foreach ($slot in @((Get-BicepTemplate discovery).slots)) {
                    $file = Join-Path $outputFolder (Get-BicepParametersFileName -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer)
                    $parameters = ([System.IO.File]::ReadAllText($file) | ConvertFrom-Json -AsHashtable).parameters
                    $values = @{}
                    foreach ($name in @($parameters.Keys)) {
                        $values[$name] = if ($parameters[$name].Contains('value')) { $parameters[$name].value } else { [Catzc.Azure.Templates.ArmExpression]::Unresolved }
                    }
                    [pscustomobject]@{
                        Name      = $slot.name
                        Resources = @(Get-ArmDeployedResource -Template $main -Values $values | Where-Object { -not $_.Conditional })
                    }
                }
            })
    }

    It 'turns on Defender for Cloud plans in every slot' {
        $script:slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $script:slots) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Security/pricings').Count | Should -BeGreaterThan 0 -Because "slot $($slot.Name) turns on Defender plans"
        }
    }

    It 'assigns the Microsoft cloud security benchmark in audit mode in every slot' {
        foreach ($slot in $script:slots) {
            $benchmark = @($slot.Resources | Where-Object Type -EQ 'Microsoft.Authorization/policyAssignments' | Where-Object {
                    "$([Catzc.Azure.Templates.ArmExpression]::Evaluate($_.Resource.properties.policyDefinitionId, $_.Scope, $_.Variables))" -like '*1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
                })
            $benchmark.Count | Should -Be 1 -Because "slot $($slot.Name) assigns the benchmark once"
            [Catzc.Azure.Templates.ArmExpression]::Evaluate($benchmark[0].Resource.properties.enforcementMode, $benchmark[0].Scope, $benchmark[0].Variables) |
                Should -Be 'DoNotEnforce' -Because "slot $($slot.Name)'s benchmark audits and never denies"
        }
    }
}
