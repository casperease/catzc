Describe 'Assert-HaveCustomers' -Tag 'L0', 'logic' {

    It 'passes (no -Name) when enabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
        { Assert-HaveCustomers } | Should -Not -Throw
    }

    It 'throws (no -Name) when disabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = $false } }
        { Assert-HaveCustomers } | Should -Throw '*disabled*have_customers*'
    }

    It 'passes for a listed name' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
        { Assert-HaveCustomers -Name acme } | Should -Not -Throw
    }

    It 'throws naming the not-enabled customer' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
        { Assert-HaveCustomers -Name globex } | Should -Throw '*globex*'
    }
}
