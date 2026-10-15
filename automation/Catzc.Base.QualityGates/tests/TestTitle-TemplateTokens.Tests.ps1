<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{25,35}
---
#>

Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $result = Test-TestTitles -PassThru -OutputFolder (Join-Path $TestDrive 'test-titles')
        $result.TestFiles | Should -BeGreaterThan 100
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
