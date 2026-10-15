<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
    kind: test
---
#>

# Poka-yoke backstop: no <token>-shaped text in a non-data-driven test title, over the real tree through its quality
# gate (Test-TestTitles — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
#
# Pester treats <word> in an It/Describe/Context title as its name-template syntax; WITHOUT -ForEach/-TestCases data
# the token is almost always prose and THROWS under the strict tests
# ([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) at name expansion, far from the
# cause. The gate bans the pattern outright: a title with a <token> must carry -ForEach data.
# (These titles themselves spell out "angle-bracket token" — a literal one here would fire the very trap.)
# source-only: it parses the repository's test files, which give the same answer in both run modes.
Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $result = Test-TestTitles -PassThru -OutputFolder (Join-Path $TestDrive 'test-titles')
        $result.TestFiles | Should -BeGreaterThan 100
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
