Describe 'Get-AspectDeclaration' -Tag 'L0', 'logic' {

    It 'returns the aspects variant, keyed by track, read through Get-Variant' {
        $config = [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } }; aspects = [ordered]@{ widgets = @([ordered]@{ live = @('*.wdg') }, [ordered]@{ tests = @('**') }) } })
        Mock Get-Variant -ModuleName Catzc.Base.Variants -ParameterFilter { $Name -eq 'aspects' } { , $config.aspects }

        $aspects = Get-AspectDeclaration

        $aspects.ContainsKey('widgets') | Should -BeTrue
        @($aspects['widgets'].Name) | Should -Be @('live', 'tests')
        Should -Invoke Get-Variant -ModuleName Catzc.Base.Variants -Times 1 -Exactly -ParameterFilter { $Name -eq 'aspects' }
    }
}
