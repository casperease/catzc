Describe 'Get-CommentPage' -Tag 'L0', 'logic', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    BeforeAll {
        $script:config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/widgets' }) })
    }

    It 'returns the page of a file a pages entry covers' {
        Get-CommentPage -Path 'widgets/Widget.Gadgets/Get-Gadget.ps1' -Config $script:config |
            Should -BeExactly 'docs/widgets/widget-gadgets/get-gadget.md'
    }

    It 'returns nothing for a file no pages entry covers' {
        @(Get-CommentPage -Path 'gadgets/Get-Gadget.ps1' -Config $script:config).Count | Should -Be 0
        @(Get-CommentPage -Path '' -Config $script:config).Count | Should -Be 0
    }

    It 'maps a page back to its source among the tracked files, and to nothing when none renders to it' {
        $tracked = 'widgets/Widget.Gadgets/Get-Gadget.ps1', 'widgets/Widget.Gadgets/tests/Get-Gadget.Tests.ps1'
        Get-CommentPage -Page 'docs/widgets/widget-gadgets/tests/get-gadget.md' -TrackedPath $tracked -Config $script:config |
            Should -BeExactly 'widgets/Widget.Gadgets/tests/Get-Gadget.Tests.ps1'
        Get-CommentPage -Page 'docs/widgets/widget-gadgets/index.md' -TrackedPath $tracked -Config $script:config |
            Should -BeExactly 'widgets/Widget.Gadgets'
        @(Get-CommentPage -Page 'docs/widgets/widget-gadgets/stale.md' -TrackedPath $tracked -Config $script:config).Count | Should -Be 0
    }
}

Describe 'Get-CommentPage (the shipped comment-pages config)' -Tag 'L1', 'integrity', 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
    It 'maps a python package file to its page under the package''s own folder, and the page back to the file' {
        $config = Get-Config -Config comment-pages
        $page = Get-CommentPage -Path 'python/diagrams/configs/drawio.yml' -Config $config
        $page | Should -BeExactly 'docs/references/python/diagrams/configs/drawio.md'
        Get-CommentPage -Page $page -TrackedPath @('python/diagrams/configs/drawio.yml') -Config $config |
            Should -BeExactly 'python/diagrams/configs/drawio.yml'
    }
}
