Describe 'Catzc.Base.QualityGates.AnalyzerAdrMapConfig' -Tag 'L0', 'logic', 'ADR-PWSH-FORMAT-ANALYZERADRMAPPING' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.QualityGates.AnalyzerAdrMapConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the AnalyzerAdrMapConfig constructor to throw'
        }
    }

    It 'accepts a well-formed map' {
        $config = [Catzc.Base.QualityGates.AnalyzerAdrMapConfig]::new([ordered]@{ analyzers = [ordered]@{
                    'Measure-FakeRule1' = @('ADR-FAKE#6')
                    'Measure-FakeRule2' = @('ADR-FAKE#3', 'ADR-FAKE#5')
                    'PSUseFakeRule'     = @('ADR-FAKE#4')
                }
            })
        @($config.analyzers.Keys) | Should -Be @('Measure-FakeRule1', 'Measure-FakeRule2', 'PSUseFakeRule')
        @($config.analyzers['Measure-FakeRule2']) | Should -Be @('ADR-FAKE#3', 'ADR-FAKE#5')
    }

    It 'throws when the analyzers key is missing' {
        Get-ViolationMessage ([ordered]@{ }) | Should -BeLike '*Missing required top-level key*'
    }

    It 'throws when an analyzer maps to no rule' {
        Get-ViolationMessage ([ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @() } }) | Should -BeLike '*maps to no ADR rule*'
    }

    It 'throws on a malformed citation (registry colon form)' {
        Get-ViolationMessage ([ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @('ADR-WIDGET-GADGET:3') } }) |
            Should -BeLike "*malformed citation 'ADR-WIDGET-GADGET:3'*"
    }

    It 'reports every violation in one throw, including an unknown top-level key' {
        $message = Get-ViolationMessage ([ordered]@{
                widget    = 1
                analyzers = [ordered]@{ 'Measure-X' = @(); 'Measure-Y' = @('ADR-FAKE:1') }
            })
        $message | Should -BeLike "*unknown top-level key 'widget'*"
        $message | Should -BeLike "*analyzer 'Measure-X' maps to no ADR rule*"
        $message | Should -BeLike "*malformed citation 'ADR-FAKE:1'*"
    }
}
