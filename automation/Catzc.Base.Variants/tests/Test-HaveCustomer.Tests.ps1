<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Test-HaveCustomer.Tests.ps1
    folder: tests
    name: test-have-customer-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-HaveCustomer' -Tag 'L0', 'logic' {

    It 'is true when the single customer is enabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
        Test-HaveCustomer acme | Should -BeTrue
    }

    It 'is false when the single customer is not enabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
        Test-HaveCustomer globex | Should -BeFalse
    }

    It 'agrees with Test-HaveCustomers -Name for one name (cover-function equivalence)' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
        Test-HaveCustomer acme | Should -Be (Test-HaveCustomers -Name acme)
    }
}
