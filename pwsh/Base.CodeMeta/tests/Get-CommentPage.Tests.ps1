Describe 'Get-CommentPage' -Tag 'L0', 'logic', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    BeforeAll {
        $script:config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/{kebab}' }) })
    }

    It 'returns the comment page of a file a pages entry covers' {
        Get-CommentPage -Path 'widgets/Catzc.Widget.Gadgets/Get-Gadget.ps1' -Config $script:config |
            Should -BeExactly 'docs/catzc-widget-gadgets/Get-Gadget.ps1.md'
    }

    It 'returns nothing for a file no pages entry covers' {
        @(Get-CommentPage -Path 'gadgets/Get-Gadget.ps1' -Config $script:config).Count | Should -Be 0
        @(Get-CommentPage -Path '' -Config $script:config).Count | Should -Be 0
    }
}

Describe 'Get-CommentPage (the shipped comment-pages config)' -Tag 'L1', 'integrity', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    It 'maps a python package file to its page under the package''s own folder name, a page that exists' {
        $page = Get-CommentPage -Path 'python/catzc_diagrams/configs/drawio.yml' -Config (Get-Config -Config comment-pages)
        $page | Should -BeExactly 'docs/references/python/catzc_diagrams/configs/drawio.yml.md'
        Join-Path (Get-RepositoryRoot) $page | Should -Exist
    }
}
