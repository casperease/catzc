Describe 'Test-AdoNaming' -Tag 'L0', 'logic' {

    It 'returns true for -Standard when the repo is standard' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'standard' } }
        Test-AdoNaming -Standard | Should -BeTrue
        Test-AdoNaming -Classic | Should -BeFalse
    }

    It 'returns true for -Classic when the repo is classic' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'classic' } }
        Test-AdoNaming -Classic | Should -BeTrue
        Test-AdoNaming -Standard | Should -BeFalse
    }

    It 'requires exactly one of -Standard / -Classic' {
        { Test-AdoNaming } | Should -Throw
        { Test-AdoNaming -Standard -Classic } | Should -Throw
    }
}
