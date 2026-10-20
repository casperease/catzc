<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
    folder: tests
    name: test-title-template-tokens-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[TestTitle-TemplateTokens.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/TestTitle-TemplateTokens.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-FILEPARALLELISM
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Test titles use angle-bracket templates only on data-driven tests' -Tag 'L1', 'integrity', 'source-only' {
    It 'finds no template-shaped token in a title without -ForEach data' {
        $result = Test-TestTitles -PassThru -OutputFolder (Join-Path $TestDrive 'test-titles')
        $result.Facts['TestFiles'] | Should -BeGreaterThan 100
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
