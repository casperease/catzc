<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#25
      - ADR-AUTO-TEST#35
---
#>

# Poka-yoke backstop: no <token>-shaped text in a non-data-driven test title, over the real tree through its quality...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md#comment1)
Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $result = Test-TestTitles -PassThru -OutputFolder (Join-Path $TestDrive 'test-titles')
        $result.TestFiles | Should -BeGreaterThan 100
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
