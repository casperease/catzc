Describe 'Alerts: every compiled slot' -Tag 'L1', 'integrity' {
    BeforeAll {
        # The compiled main.json of a template and, per slot, the resources it deploys by the compliance quality gate's evaluator.
        function script:Get-SlotResource {
            param([string] $Template)
            InModuleScope Catzc.Azure.Templates -Parameters @{ Template = $Template } {
                param($Template)
                # Its own folder, so a concurrent build of the same template never swaps the files read here.
                $outputFolder = @(Build-Bicep $Template -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root $Template))[-1]
                $text = [System.IO.File]::ReadAllText((Join-Path $outputFolder 'main.json'))
                $main = $text | ConvertFrom-Json -AsHashtable
                $environments = (Get-Config -Config azure).environments
                foreach ($slot in @((Get-BicepTemplate $Template).slots)) {
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
                        Slot      = $slot.name
                        Main      = $text
                        # The slot's parameters, where a roles.yml address lands as its role definition id.
                        Values    = [System.IO.File]::ReadAllText($file)
                        # Sent to its environment's region, as Deploy-Bicep's --location sends it, so deployment().location resolves.
                        Resources = @(Get-ArmDeployedResource -Template $main -Values $values -Location $environments[$slot.environment].region |
                                Where-Object { -not $_.Conditional })
                    }
                }
            }
        }
    }

    It 'gives every foundation slot one action group, addressed to the Owner role' {
        $slots = @(Get-SlotResource -Template foundation)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/actionGroups').Count | Should -Be 1 -Because "slot $($slot.Slot) has its action group"
            # The Owner built-in role's definition id, fixed by Azure: the group's role receiver, passed by its roles.yml address.
            $slot.Values | Should -Match '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' -Because 'the action group notifies the Owner role'
        }
    }

    It 'audits every expedition SQL server into the workspace and alerts on any sign-in of its break-glass login' {
        $slots = @(Get-SlotResource -Template expedition)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Sql/servers/auditingSettings').Count | Should -Be 1 -Because "slot $($slot.Slot) audits its server"
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/scheduledQueryRules').Count | Should -Be 1 -Because "slot $($slot.Slot) alerts on a break-glass sign-in"
            $slot.Main | Should -Match 'SQLSecurityAuditEvents' -Because 'the audit log goes to the workspace and the alert queries it'
        }
    }

    It 'gives every discovery slot a Service Health and a Resource Health alert, notifying the action group' {
        $slots = @(Get-SlotResource -Template discovery)
        $slots.Count | Should -BeGreaterThan 0
        foreach ($slot in $slots) {
            @($slot.Resources | Where-Object Type -EQ 'Microsoft.Insights/activityLogAlerts').Count | Should -BeGreaterThan 0 -Because "slot $($slot.Slot) alerts on health"
            $slot.Main | Should -Match "'ServiceHealth'" -Because 'a Service Health alert is declared'
            $slot.Main | Should -Match "'ResourceHealth'" -Because 'a Resource Health alert is declared'
            $slot.Main | Should -Match 'Microsoft\.Insights/actionGroups' -Because 'the alerts notify the action group'
        }
    }
}
