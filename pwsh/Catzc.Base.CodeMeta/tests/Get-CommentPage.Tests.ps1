Describe 'Get-CommentPage' -Tag 'L0', 'logic', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    BeforeAll {
        Mock -ModuleName Catzc.Base.CodeMeta Get-Config {
            [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/{kebab}' }) })
        } -ParameterFilter { $Config -eq 'comment-pages' }
    }

    It 'returns the comment page of a file a pages entry covers' {
        Get-CommentPage -Path 'widgets/Catzc.Widget.Gadgets/Get-Gadget.ps1' | Should -BeExactly 'docs/catzc-widget-gadgets/Get-Gadget.ps1.md'
    }

    It 'returns nothing for a file no pages entry covers' {
        @(Get-CommentPage -Path 'gadgets/Get-Gadget.ps1').Count | Should -Be 0
        @(Get-CommentPage -Path '').Count | Should -Be 0
    }
}
