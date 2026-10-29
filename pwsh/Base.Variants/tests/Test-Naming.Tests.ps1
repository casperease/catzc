Describe 'Test-Naming' -Tag 'L0', 'logic' {

    It 'returns true for -Standard when the repo is standard' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = 'standard' } }
        Test-Naming -Standard | Should -BeTrue
        Test-Naming -Classic | Should -BeFalse
    }

    It 'returns true for -Classic when the repo is classic' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = 'classic' } }
        Test-Naming -Classic | Should -BeTrue
        Test-Naming -Standard | Should -BeFalse
    }

    It 'returns false for either preset when the repo names an explicit list' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = [string[]] @('type', 'env') } }
        Test-Naming -Standard | Should -BeFalse
        Test-Naming -Classic | Should -BeFalse
    }

    It 'requires exactly one of -Standard / -Classic' {
        { Test-Naming } | Should -Throw
        { Test-Naming -Standard -Classic } | Should -Throw
    }
}
