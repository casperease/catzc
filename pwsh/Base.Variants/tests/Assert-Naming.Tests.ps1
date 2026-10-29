Describe 'Assert-Naming' -Tag 'L0', 'logic' {

    It 'passes when the repo matches the asserted order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = 'standard' } }
        { Assert-Naming -Standard } | Should -Not -Throw
    }

    It 'throws (naming the actual order) when it does not match' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = 'classic' } }
        { Assert-Naming -Standard } | Should -Throw "*naming 'standard'*is 'classic'*"
    }

    It 'throws (naming the segments) when the repo names an explicit list' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ naming = [string[]] @('type', 'env') } }
        { Assert-Naming -Classic } | Should -Throw "*naming 'classic'*is 'type, env'*"
    }
}
