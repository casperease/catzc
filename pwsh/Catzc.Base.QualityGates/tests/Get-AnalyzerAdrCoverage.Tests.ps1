<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
    folder: tests
    name: get-analyzer-adr-coverage-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-AnalyzerAdrCoverage.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Get-AnalyzerAdrCoverage.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-COVERAGEREPORTEDONLY
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PWSH-FORMAT-ANALYZERADRMAPPING
---
#>

Describe 'Get-AnalyzerAdrCoverage' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-COVERAGEREPORTEDONLY' {
    It 'flattens the map into one pssa-rule row per (analyzer, ADR id)' {
        InModuleScope Catzc.Base.QualityGates {
            Mock Get-Config {
                [ordered]@{ analyzers = [ordered]@{
                        'Measure-FakeRule2' = @('ADR-FAKE-FOLD', 'ADR-FAKE-SINK')
                        'PSUseFakeRule'     = @('ADR-FAKE-LIFT')
                    }
                }
            } -ParameterFilter { $Config -eq 'analyzer-adr-map' }

            $rows = @(Get-AnalyzerAdrCoverage)
            $rows | Should -HaveCount 3
            ($rows | ForEach-Object Kind | Sort-Object -Unique) | Should -Be 'pssa-rule'
            ($rows | Where-Object { $_.Enforcer -eq 'Measure-FakeRule2' }).AdrId | Should -Be @('ADR-FAKE-FOLD', 'ADR-FAKE-SINK')
            ($rows | Where-Object { $_.AdrId -eq 'ADR-FAKE-LIFT' }).Enforcer | Should -Be 'PSUseFakeRule'
        }
    }
}

Describe 'analyzer-adr-map integrity' -Tag 'L1', 'integrity', 'source-only', 'ADR-PWSH-FORMAT-ANALYZERADRMAPPING' {
    BeforeAll {
        $script:result = Test-AnalyzerAdrMap -PassThru -OutputFolder (Join-Path $TestDrive 'analyzer-adr-map')
    }

    It 'found custom analyzer rules to check (guards against a silent no-op)' {
        $result.Facts['CustomRules'] | Should -BeGreaterThan 0
    }

    It 'maps every analyzer to real ADR rule ids, and every custom analyzer rule (a new one cannot ship unmapped)' {
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
