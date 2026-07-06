Describe 'Get-Aspect' -Tag 'L0', 'logic' {

    It 'defaults to live then tests (the catch-all last) when the variant is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{} }
        $aspects = @(Get-Aspect)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Contain 'private/**'
        $aspects[-1].Patterns | Should -Be @('**')          # tests is the non-live catch-all, declared last
    }

    It 'returns the configured aspects in declared order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } {
            [ordered]@{ aspects = @([ordered]@{ live = @('src/**') }, [ordered]@{ tests = @('**') }) }
        }
        $aspects = @(Get-Aspect)
        $aspects.Name | Should -Be @('live', 'tests')
        $aspects[0].Patterns | Should -Be @('src/**')
    }
}
