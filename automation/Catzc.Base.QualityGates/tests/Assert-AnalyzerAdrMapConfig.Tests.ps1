Describe 'Assert-AnalyzerAdrMapConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Config } { param($C) Assert-AnalyzerAdrMapConfig -Config $C }
        }
    }

    It 'accepts a well-formed map' {
        $config = [ordered]@{ analyzers = [ordered]@{
                'Measure-VariableCasing'   = @('ADR-PSFORMAT#4')
                'Measure-NeverDependOnPwd' = @('ADR-NOPWD#1', 'ADR-NOPWD#3')
                'PSUseApprovedVerbs'       = @('ADR-VERBS#1')
            }
        }
        { & $script:assert $config } | Should -Not -Throw
    }

    It 'throws when the analyzers key is missing' {
        { & $script:assert ([ordered]@{ }) } | Should -Throw '*Missing required top-level key*'
    }

    It 'throws when an analyzer maps to no rule' {
        $config = [ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @() } }
        { & $script:assert $config } | Should -Throw '*maps to no ADR rule*'
    }

    It 'throws on a malformed citation (registry colon form)' {
        $config = [ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @('ADR-ERROR:3') } }
        { & $script:assert $config } | Should -Throw "*malformed citation 'ADR-ERROR:3'*"
    }
}
