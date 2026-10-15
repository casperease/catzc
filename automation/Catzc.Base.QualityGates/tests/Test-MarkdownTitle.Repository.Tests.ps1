<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-FORMAT#6
---
#>

# The real repository titles every in-scope Markdown file with its path.
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md#comment1)
Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {
    It 'every in-scope Markdown file is titled with its repository path' -Tag 'ADR-REPO-FORMAT#6' {
        $result = Test-MarkdownTitle -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-title')
        $result.FileCount | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-MarkdownTitle'
        $result.IssueCount | Should -Be 0
    }
}
