<#
---
catzc:
  immutable:
    with_body_sha: "47f262ddc985"
  edges:
    code: pwsh/Catzc.Base.QualityGates/types/AnalyzerDrsMapConfig.cs
    cites:
      - ADR-PWSH-FORMAT-ANALYZERADRMAPPING
---
#>

Describe 'Catzc.Base.QualityGates.AnalyzerDrsMapConfig' -Tag 'L0', 'logic', 'ADR-PWSH-FORMAT-ANALYZERADRMAPPING' {
    BeforeAll {
        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the AnalyzerDrsMapConfig constructor to throw'
        }
    }

    It 'accepts a well-formed map' {
        $config = [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::new([ordered]@{ analyzers = [ordered]@{
                    'Measure-FakeRule1' = @('ADR-WIDGET-GADGET-STOP')
                    'Measure-FakeRule2' = @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN')
                    'PSUseFakeRule'     = @('ADR-WIDGET-SPROCKET-COG')
                }
            })
        @($config.analyzers.Keys) | Should -Be @('Measure-FakeRule1', 'Measure-FakeRule2', 'PSUseFakeRule')
        @($config.analyzers['Measure-FakeRule2']) | Should -Be @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN')
    }

    It 'throws when the analyzers key is missing' {
        Get-ViolationMessage ([ordered]@{ }) | Should -BeLike '*Missing required top-level key*'
    }

    It 'throws when an analyzer maps to no rule' {
        Get-ViolationMessage ([ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @() } }) | Should -BeLike '*maps to no ADR rule*'
    }

    It 'throws on a malformed citation (the numbered form)' {
        Get-ViolationMessage ([ordered]@{ analyzers = [ordered]@{ 'Measure-X' = @('ADR-WIDGET-GADGET#3') } }) |
            Should -BeLike "*malformed citation 'ADR-WIDGET-GADGET#3'*"
    }

    It 'reports every violation in one throw, including an unknown top-level key' {
        $message = Get-ViolationMessage ([ordered]@{
                widget    = 1
                analyzers = [ordered]@{ 'Measure-X' = @(); 'Measure-Y' = @('ADR-WIDGET-GADGET:1') }
            })
        $message | Should -BeLike "*unknown top-level key 'widget'*"
        $message | Should -BeLike "*analyzer 'Measure-X' maps to no ADR rule*"
        $message | Should -BeLike "*malformed citation 'ADR-WIDGET-GADGET:1'*"
    }
}
