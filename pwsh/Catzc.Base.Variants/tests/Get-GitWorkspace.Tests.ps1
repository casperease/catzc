Describe 'Get-GitWorkspace' -Tag 'L0', 'logic' {

    It 'returns the configured mode' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ git_workspace = 'main-via-pr' } }
        Get-GitWorkspace | Should -Be 'main-via-pr'
    }

    It 'defaults to main-direct when the variant is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } } }) }
        Get-GitWorkspace | Should -Be 'main-direct'
    }
}
