Describe 'Test-FileHeadVariant' -Tag 'L0', 'logic', 'ADR-REPO-VARIANT-FILEHEADS' {

    It 'returns true for -Minimal when the repo is minimal' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ file_heads = [ordered]@{ code = 'minimal' } } }
        Test-FileHeadVariant -Minimal | Should -BeTrue
        Test-FileHeadVariant -None | Should -BeFalse
    }

    It 'returns true for -None when the repo is none' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ file_heads = [ordered]@{ code = 'none' } } }
        Test-FileHeadVariant -None | Should -BeTrue
        Test-FileHeadVariant -Minimal | Should -BeFalse
    }

    It 'requires exactly one of -Minimal / -None' {
        { Test-FileHeadVariant } | Should -Throw
        { Test-FileHeadVariant -Minimal -None } | Should -Throw
    }
}
