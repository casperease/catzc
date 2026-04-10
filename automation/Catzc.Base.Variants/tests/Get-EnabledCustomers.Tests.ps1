Describe 'Get-EnabledCustomers' -Tag 'L0', 'logic' {

    It 'returns an empty set when have_customers is false' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = $false } }
        Get-EnabledCustomers | Should -BeNullOrEmpty
    }

    It 'returns an empty set when have_customers is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{} }
        Get-EnabledCustomers | Should -BeNullOrEmpty
    }

    It "returns 'all' when have_customers is the string all" {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
        Get-EnabledCustomers | Should -Be 'all'
    }

    It "returns 'all' when have_customers is boolean true" {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = $true } }
        Get-EnabledCustomers | Should -Be 'all'
    }

    It 'returns the list of names when have_customers is a list' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme', 'globex') } }
        (Get-EnabledCustomers) -join ',' | Should -Be 'acme,globex'
    }

    It 'returns an empty set for an empty list' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @() } }
        Get-EnabledCustomers | Should -BeNullOrEmpty
    }
}
