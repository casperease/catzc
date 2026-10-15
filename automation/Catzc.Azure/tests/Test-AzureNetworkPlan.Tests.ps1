<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
      source: automation/Catzc.Azure/Test-AzureNetworkPlan.ps1
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AZ-NETWORK#{2,4,5}
---
#>

Describe 'Test-AzureNetworkPlan' -Tag 'L0', 'logic' {
    BeforeAll {
        $environment = { param($code) [ordered]@{ shortcode = $code; region = 'westeurope'; region_code = 'weu' } }
        $script:fixtureAzure = [Catzc.Azure.AzureConfig]::new([ordered]@{
                org               = 'tst'
                bicep_min_version = '0.30.0'
                tenants           = [ordered]@{ fixtenant = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' } }
                subscriptions     = [ordered]@{
                    core_lower   = [ordered]@{ id = '50a0ed00-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha', 'nsub') }
                    widget_lower = [ordered]@{
                        id = 'a0e00000-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; customer = 'widget'
                        environments = @('alpha', 'beta', 'nsub')
                    }
                }
                environments      = [ordered]@{
                    alpha = (& $environment 'al')
                    beta  = (& $environment 'bt')
                    nsub  = [ordered]@{ shortcode = 'ns'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                }
            })
        $script:hub = {
            param([int] $Octet)
            [ordered]@{
                kind               = 'hub'
                vnet_address_space = "10.$Octet.0.0/16"
                subnets            = [ordered]@{
                    GatewaySubnet       = "10.$Octet.0.0/27"
                    AzureFirewallSubnet = "10.$Octet.0.64/26"
                    'shared-services'   = "10.$Octet.1.0/24"
                }
            }
        }
        $script:spoke = {
            param([int] $Octet, [string[]] $Workloads)
            $subnets = [ordered]@{ 'private-endpoints' = "10.$Octet.0.0/24" }
            $third = 0
            foreach ($workload in $Workloads) {
                $third++
                $subnets[$workload] = "10.$Octet.$third.0/24"
            }
            [ordered]@{ kind = 'spoke'; vnet_address_space = "10.$Octet.0.0/16"; subnets = $subnets }
        }
        $script:plan = {
            param([string[]] $Names, [System.Collections.IDictionary] $Subscriptions)
            $map = [ordered]@{}
            $octet = 10
            foreach ($name in $Names) {
                $octet += 10
                $map[$name] = [ordered]@{ vnet_address_space = "10.$octet.0.0/16"; default_subnet = "10.$octet.0.0/24" }
            }
            if (-not $Subscriptions) {
                $Subscriptions = [ordered]@{ core_lower = (& $script:hub 0); widget_lower = (& $script:spoke 100 'alpha', 'beta') }
            }
            [Catzc.Azure.NetworkConfig]::new([ordered]@{ environments = $map; subscriptions = $Subscriptions })
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
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Environments | Should -Be 2
        $result.Subscriptions | Should -Be 2
    }

    It 'throws once listing a ghost plan and a standard environment with no plan' -Tag 'ADR-AZ-NETWORK#2' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } { & $script:plan 'alpha', 'ghost' }
        $thrown = { Test-AzureNetworkPlan -OutputFolder $out } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-AzureNetworkPlan failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -BeLike "*network environment 'ghost' is not a defined azure.yml environment (valid: alpha, beta, nsub)*"
        $thrown.Exception.Message | Should -BeLike "*azure.yml environment 'beta' has no network entry in network.yml*"
    }

    It 'lists a subscription with no network entry and a ghost network subscription' -Tag 'ADR-AZ-NETWORK#5' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } {
            & $script:plan 'alpha', 'beta' ([ordered]@{ core_lower = (& $script:hub 0); gadget_lower = (& $script:spoke 100 'alpha') })
        }
        $result = Test-AzureNetworkPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain "network subscription 'gadget_lower' is not a defined azure.yml subscription (valid: core_lower, widget_lower)"
        $result.Issues | Should -Contain ("azure.yml subscription 'widget_lower' has no network entry in network.yml (it serves customer" +
            " 'widget', so it needs a spoke)")
    }

    It 'lists a subscription whose entry is the wrong kind, both ways' -Tag 'ADR-AZ-NETWORK#5' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } {
            & $script:plan 'alpha', 'beta' ([ordered]@{ core_lower = (& $script:spoke 0 'alpha'); widget_lower = (& $script:hub 100) })
        }
        $result = Test-AzureNetworkPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain ("network subscription 'core_lower' is a spoke, but its azure.yml subscription serves no customer," +
            ' so it needs a hub')
        $result.Issues | Should -Contain ("network subscription 'widget_lower' is a hub, but its azure.yml subscription serves customer" +
            " 'widget', so it needs a spoke")
    }

    It 'lists a spoke missing a workload subnet for a served environment and one for an environment it does not serve' -Tag 'ADR-AZ-NETWORK#5' {
        Mock Get-Config -ModuleName Catzc.Azure -ParameterFilter { $Config -eq 'network' } {
            & $script:plan 'alpha', 'beta' ([ordered]@{ core_lower = (& $script:hub 0); widget_lower = (& $script:spoke 100 'alpha', 'gamma') })
        }
        $result = Test-AzureNetworkPlan -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 2
        $result.Issues | Should -Contain "network spoke 'widget_lower' has no workload subnet for environment 'beta', which its subscription serves"
        $result.Issues | Should -Contain ("network spoke 'widget_lower' has workload subnet 'gamma', which names no standard environment its" +
            ' subscription serves (serves: alpha, beta)')
    }
}

Describe 'Azure network plan sync' -Tag 'L0', 'integrity', 'ADR-AZ-NETWORK#2', 'ADR-AZ-NETWORK#5' {
    It 'the shipped network.yml and azure.yml environments and subscriptions are in sync' {
        $result = Test-AzureNetworkPlan -PassThru -OutputFolder (Join-Path $TestDrive 'azure-network-plan')
        $result.Environments | Should -BeGreaterThan 0
        $result.Subscriptions | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
