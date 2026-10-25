<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Test-MarkdownTitle.Repository.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Repository Markdown titles' -Tag 'L2', 'integrity', 'source-only' {
    It 'every in-scope Markdown file is titled with its repository path' -Tag 'ADR-REPO-FORMAT-MARKDOWNTITLE' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result = Test-MarkdownTitle -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-title')
        $result.Facts['FileCount'] | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-MarkdownTitle'
        $result.IssueCount | Should -Be 0
    }
}
