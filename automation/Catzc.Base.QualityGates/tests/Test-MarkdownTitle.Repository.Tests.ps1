<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1
    folder: tests
    name: test-markdown-title-repository-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md
    adrs:
      - ADR-REPO-FORMAT#6
---
#>

Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {
    It 'every in-scope Markdown file is titled with its repository path' -Tag 'ADR-REPO-FORMAT#6' {
        $result = Test-MarkdownTitle -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-title')
        $result.FileCount | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-MarkdownTitle'
        $result.IssueCount | Should -Be 0
    }
}
