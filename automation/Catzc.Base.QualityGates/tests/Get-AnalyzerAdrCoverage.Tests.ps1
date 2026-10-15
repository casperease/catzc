<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-AnalyzerAdrCoverage' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#28' {
    It 'flattens the map into one pssa-rule row per (analyzer, ADR id)' {
        InModuleScope Catzc.Base.QualityGates {
            Mock Get-Config {
                [ordered]@{ analyzers = [ordered]@{
                        'Measure-FakeRule2' = @('ADR-FAKE#3', 'ADR-FAKE#5')
                        'PSUseFakeRule'     = @('ADR-FAKE#4')
                    }
                }
            } -ParameterFilter { $Config -eq 'analyzer-adr-map' }

            $rows = @(Get-AnalyzerAdrCoverage)
            $rows | Should -HaveCount 3
            ($rows | ForEach-Object Kind | Sort-Object -Unique) | Should -Be 'pssa-rule'
            ($rows | Where-Object { $_.Enforcer -eq 'Measure-FakeRule2' }).AdrId | Should -Be @('ADR-FAKE#3', 'ADR-FAKE#5')
            ($rows | Where-Object { $_.AdrId -eq 'ADR-FAKE#4' }).Enforcer | Should -Be 'PSUseFakeRule'
        }
    }
}

# source-only: it cross-checks the map against the repository's ADR tree and .scriptanalyzer rule files, which
# gives the same answer in both run modes. The check is the quality gate Test-AnalyzerAdrMap
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
Describe 'analyzer-adr-map integrity' -Tag 'L1', 'integrity', 'source-only', 'ADR-PWSH-FORMAT#7' {
    BeforeAll {
        $script:result = Test-AnalyzerAdrMap -PassThru -OutputFolder (Join-Path $TestDrive 'analyzer-adr-map')
    }

    It 'found custom analyzer rules to check (guards against a silent no-op)' {
        $result.CustomRules | Should -BeGreaterThan 0
    }

    It 'maps every analyzer to real ADR rule ids, and every custom analyzer rule (a new one cannot ship unmapped)' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
