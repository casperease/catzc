Describe 'Get-AdoNaming' -Tag 'L0', 'logic' {

    It 'returns the configured ado_naming value' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'classic' } }
        Get-AdoNaming | Should -Be 'classic'
    }

    It 'defaults to standard when ado_naming is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{} }
        Get-AdoNaming | Should -Be 'standard'
    }
}
