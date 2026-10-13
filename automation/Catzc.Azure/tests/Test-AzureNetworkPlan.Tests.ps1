# Test-AzureNetworkPlan and its join (Get-NetworkPlanViolations) over typed fixture configs with Greek environment
# names, not the shipped ones, so editing azure.yml can never change the logic outcome
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-AzureNetworkPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        $environment = { param($code) [ordered]@{ shortcode = $code; region = 'westeurope'; region_code = 'weu' } }
        $script:fixtureAzure = [Catzc.Azure.AzureConfig]::new([ordered]@{
                org               = 'tst'
                bicep_min_version = '0.30.0'
                tenants           = [ordered]@{ fixtenant = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' } }
                subscriptions     = [ordered]@{
                    core_lower = [ordered]@{ id = '50a0ed00-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
                }
                environments      = [ordered]@{
                    alpha = (& $environment 'al')
                    beta  = (& $environment 'bt')
                    nsub  = [ordered]@{ shortcode = 'ns'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                }
            })
        $script:plan = {
            param([string[]] $Names)
            $map = [ordered]@{}
            $octet = 10
            foreach ($name in $Names) {
                $octet += 10
                $map[$name] = [ordered]@{ vnet_address_space = "10.$octet.0.0/16"; default_subnet = "10.$octet.0.0/24" }
            }
            [Catzc.Azure.NetworkConfig]::new([ordered]@{ environments = $map })
        }
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'azure' } { $script:fixtureAzure }
    }

    It 'passes when every standard environment has a plan and per-subscription ones are exempt' -Tag 'ADR-AZ-NETWORK#4' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } { & $script:plan 'alpha', 'beta' }
        $result = Test-AzureNetworkPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Environments | Should -Be 2
    }

    It 'throws once listing a ghost plan and a standard environment with no plan' -Tag 'ADR-AZ-NETWORK#2' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } { & $script:plan 'alpha', 'ghost' }
        $thrown = { Test-AzureNetworkPlan -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-AzureNetworkPlan failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -BeLike "*network environment 'ghost' is not a defined azure.yml environment (valid: alpha, beta, nsub)*"
        $thrown.Exception.Message | Should -BeLike "*azure.yml environment 'beta' has no network entry in network.yml*"
    }
}

Describe 'Azure network plan sync' -Tag 'L0', 'integrity', 'ADR-AZ-NETWORK#2' {
    It 'the shipped network.yml and azure.yml environments are in sync' {
        $result = Test-AzureNetworkPlan -PassThru -OutputFolder (Join-Path $TestDrive 'azure-network-plan')
        $result.Environments | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
