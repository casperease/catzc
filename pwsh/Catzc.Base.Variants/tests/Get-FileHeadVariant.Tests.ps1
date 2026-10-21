Describe 'Get-FileHeadVariant' -Tag 'L0', 'logic', 'ADR-REPO-VARIANT-FILEHEADS' {

    It 'returns the configured mode' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ file_heads = [ordered]@{ code = 'none' } } }
        Get-FileHeadVariant | Should -Be 'none'
    }

    It 'defaults to minimal when the variant is unset' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } } }) }
        Get-FileHeadVariant | Should -Be 'minimal'
    }
}
