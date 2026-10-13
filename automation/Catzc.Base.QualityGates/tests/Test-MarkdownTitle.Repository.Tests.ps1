# The real repository titles every in-scope Markdown file with its path
# ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)). An integrity check over the tracked tree.
Describe 'Repository Markdown titles' -Tag 'L1', 'integrity', 'source-only' {
    It 'every in-scope Markdown file is titled with its repository path' -Tag 'ADR-REPO-FORMAT#6' {
        $result = Test-MarkdownTitle -PassThru -OutputFolder (Join-Path $TestDrive 'markdown-title')
        $result.FileCount | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-MarkdownTitle'
        $result.IssueCount | Should -Be 0
    }
}
