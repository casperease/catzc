<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md
      source: automation/Catzc.Azure/Get-AzureCustomers.ps1
    adrs:
      - ADR-AUTO-TEST#{4,19}
---
#>

Describe 'Get-AzureCustomers' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the customer keys from customer.yml' {
        $customers = Get-AzureCustomers
        $customers | Should -Contain 'acme'
        $customers | Should -Contain 'globex'
    }

    It 'returns all fixture customers' {
        @(Get-AzureCustomers).Count | Should -Be 2
    }
}
