<#
---
catzc:
  immutable:
    with_body_sha: "9590f37db2d7"
  edges:
    docs: "[Test-MarkdownTitle.Repository.Tests.ps1.md](docs/references/pwsh/catzc-base-qualitygates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md)"
    cites:
      - ADR-REPO-FORMAT-MARKDOWNTITLE
---
#>

Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {
    It 'every in-scope Markdown file is titled with its repository path' -Tag 'ADR-REPO-FORMAT-MARKDOWNTITLE' {
        $result = Test-MarkdownTitle -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-title')
        $result.Facts['FileCount'] | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-MarkdownTitle'
        $result.IssueCount | Should -Be 0
    }
}
