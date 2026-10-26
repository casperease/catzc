<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-AzureCustomers' -Tag 'L0', 'logic' {
    # A read-only resolver: the config mock and cache reset run once, not per test.
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure) "tests/assets/config/$Config.yml"
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
