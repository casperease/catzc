Describe 'Get-Naming' -Tag 'L0', 'logic' {

    It 'returns a configured preset as its name' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = 'classic' } }
        Get-Naming | Should -BeExactly 'classic'
    }

    It 'returns a configured segment list as one string array, in its order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = [string[]] @('type', 'env', 'org') } }
        $naming = Get-Naming
        , $naming | Should -BeOfType [string[]]
        $naming | Should -Be @('type', 'env', 'org')
    }

    It 'defaults to standard when naming is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ members = @('widgetry'); type = 'modules' } } }) }
        Get-Naming | Should -BeExactly 'standard'
    }
}
