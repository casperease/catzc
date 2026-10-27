Describe 'Test-BicepOrphans' -Tag 'L0', 'logic' {
    BeforeAll {
        # The fixture templates and identities, with the az session and the resource group list mocked at the boundary.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
    }

    BeforeEach {
        $script:subscription = 'core_lower'
        Mock Get-AzCliSessionSubscription { [ordered]@{ name = $script:subscription; customer = '' } } -ModuleName Catzc.Azure.Templates
        # Every resource group the config derives for the session's subscription, so a run with no extra group is clean.
        $script:derived = @(InModuleScope Catzc.Azure.Templates -Parameters @{ Subscription = $script:subscription } {
                param($Subscription)
                foreach ($template in Get-BicepTemplateNames) {
                    $descriptor = Get-BicepTemplate $template
                    if ($descriptor.deployment_target -ne 'ResourceGroup') {
                        continue
                    }
                    foreach ($slot in @($descriptor.slots | Where-Object { $_.subscription -eq $Subscription })) {
                        Get-BicepResourceGroupName -Template $template -Environment $slot.environment -Slot $slot.slot -Customer $slot.customer
                    }
                }
            })
        $script:extra = @()
        Mock Invoke-AzCli -ParameterFilter { $Arguments -like 'group list*' } -MockWith {
            $names = @($script:derived) + @($script:extra)
            [pscustomobject]@{ Output = (ConvertTo-Json -InputObject @($names | ForEach-Object { @{ name = $_ } }) -Depth 3); ExitCode = 0 }
        } -ModuleName Catzc.Azure.Templates
    }

    It 'passes when every resource group of the org in the subscription comes from a template config' {
        $script:derived.Count | Should -BeGreaterThan 0 -Because 'the fixture subscription must serve at least one slot deployed to a resource group'
        $result = Test-BicepOrphans -PassThru -OutputFolder (Join-Path $TestDrive 'orphans')
        $result.IssueCount | Should -Be 0
        $result.Facts['Expected'] | Should -Be $script:derived.Count
    }

    It 'lists a resource group of the org that no config derives, and ignores one outside the org''s naming' {
        $org = (Get-Config -Config azure).org
        $script:extra = @("alpha-weu-$org-widget-rg", 'someone-elses-group')
        $result = Test-BicepOrphans -PassThru -OutputFolder (Join-Path $TestDrive 'orphans')
        $result.Issues | Should -Be @("resource group 'alpha-weu-$org-widget-rg' in subscription 'core_lower' has no template config — remove it, or add the config it was deployed from")
        { Test-BicepOrphans -OutputFolder (Join-Path $TestDrive 'orphans') } | Should -Throw '*Test-BicepOrphans failed: 1 issue(s)*'
    }
}
