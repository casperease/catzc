Describe 'Assert-AdoNaming' -Tag 'L0', 'logic' {

    It 'passes when the repo matches the asserted order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'standard' } }
        { Assert-AdoNaming -Standard } | Should -Not -Throw
    }

    It 'throws (naming the actual order) when it does not match' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'classic' } }
        { Assert-AdoNaming -Standard } | Should -Throw "*ado_naming 'standard'*is 'classic'*"
    }
}
