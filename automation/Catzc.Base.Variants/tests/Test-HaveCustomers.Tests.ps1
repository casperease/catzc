Describe 'Test-HaveCustomers' -Tag 'L0', 'logic' {

    Context 'no -Name (repo-wide capability)' {
        It 'is false when disabled' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = $false } }
            Test-HaveCustomers | Should -BeFalse
        }
        It "is true when 'all'" {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
            Test-HaveCustomers | Should -BeTrue
        }
        It 'is true for a non-empty list' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
            Test-HaveCustomers | Should -BeTrue
        }
    }

    Context '-Name (specific customers)' {
        It "is true for any name under 'all'" {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
            Test-HaveCustomers -Name acme | Should -BeTrue
        }
        It 'is true for a listed name' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme', 'globex') } }
            Test-HaveCustomers -Name acme | Should -BeTrue
        }
        It 'is false for a non-listed name' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
            Test-HaveCustomers -Name globex | Should -BeFalse
        }
        It 'is false for any name when disabled' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = $false } }
            Test-HaveCustomers -Name acme | Should -BeFalse
        }
        It 'requires every listed name to be enabled' {
            Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
            Test-HaveCustomers -Name acme, globex | Should -BeFalse
        }
    }
}
