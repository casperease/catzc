<#
---
catzc:
  immutable:
    with_body_sha: "2b76b8936743"
  edges:
    docs: "[Get-AzureCustomer.Tests.ps1.md](docs/references/pwsh/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md)"
    code: pwsh/Catzc.Azure/Get-AzureCustomer.ps1
    cites:
      - ADR-AUTO-TEST-SETUPONCE
---
#>

Describe 'Get-AzureCustomer' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -eq 'customer' } -MockWith {
            @{ Name = 'customer'; Module = 'Catzc.Azure'
                Path = Join-Path (Get-CatzcModulesRoot) 'Catzc.Azure/tests/assets/config/customer.yml'
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves a customer by its key' {
        $customer = Get-AzureCustomer acme
        $customer.key | Should -Be 'acme'
        $customer.shortcode | Should -Be 'ac'
    }

    It 'resolves the same customer by its shortcode' {
        $customer = Get-AzureCustomer ac
        $customer.key | Should -Be 'acme'
        $customer.shortcode | Should -Be 'ac'
    }

    It 'resolves a second customer both ways to the same key' {
        (Get-AzureCustomer globex).key | Should -Be 'globex'
        (Get-AzureCustomer gx).key | Should -Be 'globex'
    }

    It 'throws for a token that is neither a key nor a shortcode' {
        { Get-AzureCustomer nope } | Should -Throw '*Unknown customer*'
    }
}
