<#
---
catzc:
  immutable:
    with_body_sha: bfcfb514d94e
  edges:
    code: pwsh/Catzc.Base.Variants/Test-HaveCustomer.ps1
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
