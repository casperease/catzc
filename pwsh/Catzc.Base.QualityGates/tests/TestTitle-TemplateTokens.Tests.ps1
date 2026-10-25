<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/TestTitle-TemplateTokens.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $result = Test-TestTitles -PassThru -OutputFolder (Join-Path $TestDrive 'test-titles')
        $result.Facts['TestFiles'] | Should -BeGreaterThan 100
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
