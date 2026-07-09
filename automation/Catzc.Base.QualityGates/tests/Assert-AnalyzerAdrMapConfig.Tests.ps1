Describe 'Assert-AnalyzerAdrMapConfig' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#29' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Config } { param($C) Assert-AnalyzerAdrMapConfig -Config $C }
        }
    }

    It 'accepts a well-formed map' {
        $config = [ordered]@{ analyzers = [ordered]@{
                'Measure-FakeRule1' = @('ADR-FAKE#6')
                'Measure-FakeRule2' = @('ADR-FAKE#3', 'ADR-FAKE#5')
                'PSUseFakeRule'     = @('ADR-FAKE#4')
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
        $config = [ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @('ADR-AUTO-ERROR:3') } }
        { & $script:assert $config } | Should -Throw "*malformed citation 'ADR-AUTO-ERROR:3'*"
    }
}
