Describe 'Get-CommentPageGeneratedTarget' -Tag 'L0', 'logic', 'ADR-REPO-COMMENTS-PAGEISAUTHORED' {
    It 'answers no target, since a comment page is authored' {
        @(Get-CommentPageGeneratedTarget -Name 'Export-Pages' -Class 'snapshot') | Should -BeNullOrEmpty
    }
}
