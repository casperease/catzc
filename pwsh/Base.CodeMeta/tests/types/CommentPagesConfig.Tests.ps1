Describe 'CommentPagesConfig' -Tag 'L0', 'logic' {
    It 'takes the declared default pages and no articles when the keys are omitted' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.pages.Count | Should -Be 4
        $config.pages[0].source | Should -Be 'pwsh/*'
        $config.articles.Count | Should -Be 0
    }

    It 'maps a file to <Page>: module, aspect path and file in the normal form, the extension and the .Tests role dropped' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' -ForEach @(
        @{ Path = 'pwsh/Widget.Gadgets/Get-Gadget.ps1'; Page = 'docs/references/pwsh/widget-gadgets/get-gadget.md' }
        @{ Path = 'pwsh/Widget.Gadgets/private/Get-Gadget.ps1'; Page = 'docs/references/pwsh/widget-gadgets/private/get-gadget.md' }
        @{ Path = 'pwsh/Widget.Gadgets/configs/gadgets.yml'; Page = 'docs/references/pwsh/widget-gadgets/configs/gadgets.md' }
        @{ Path = 'pwsh/Widget.Gadgets/tests/ManualTestPlan-Coverage.Tests.ps1'; Page = 'docs/references/pwsh/widget-gadgets/tests/manual-test-plan-coverage.md' }
        @{ Path = 'pwsh/Widget.Gadgets/tests/types/GadgetConfig.Tests.ps1'; Page = 'docs/references/pwsh/widget-gadgets/tests/types/gadget-config.md' }
        @{ Path = 'pwsh/Widget.Gadgets/tests/Get-Gadget.Spring.Tests.ps1'; Page = 'docs/references/pwsh/widget-gadgets/tests/get-gadget-spring.md' }
        @{ Path = '.ado/pipelines/widget/build.yaml'; Page = 'docs/references/ado/pipelines/widget/build.md' }
        @{ Path = '.claude/hooks/Gadget/Program.cs'; Page = 'docs/references/pwsh/claude-hooks/gadget/program.md' }
    ) {
        [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{}).PageFor($Path) | Should -BeExactly $Page
    }

    It 'maps no page for a file outside every source, a dot-prefixed module folder, or a file directly in the prefix' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.PageFor('docs/drs/index.md') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/.vendor/Gadget/Gadget.psm1') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/importer.ps1') | Should -BeNullOrEmpty
        $config.PageFor('pwsh/Widget.Gadgets') | Should -BeNullOrEmpty
        $config.PageFor('') | Should -BeNullOrEmpty
    }

    It 'gives a module folder its article page, index.md in the module''s page folder, and no other folder one' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.ModulePageFor('pwsh/Widget.Gadgets') | Should -BeExactly 'docs/references/pwsh/widget-gadgets/index.md'
        $config.ModulePageFor('pwsh/Widget.Gadgets/tests') | Should -BeNullOrEmpty
        $config.ModulePageFor('pwsh/.vendor') | Should -BeNullOrEmpty
        $config.ModulePageFor('.ado/pipelines') | Should -BeNullOrEmpty
    }

    It 'maps a page back to its source, a module article back to its folder, and lists every source of a shared page' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $index = $config.PageIndex([string[]] @('pwsh/Widget.Gadgets/Get-Gadget.ps1', 'pwsh/Widget.Gadgets/Get-Gadget.cs',
                'pwsh/Widget.Gadgets/tests/Get-Gadget.Tests.ps1', 'docs/drs/index.md'))
        $index['docs/references/pwsh/widget-gadgets/tests/get-gadget.md'] | Should -Be @('pwsh/Widget.Gadgets/tests/Get-Gadget.Tests.ps1')
        $index['docs/references/pwsh/widget-gadgets/index.md'] | Should -Be @('pwsh/Widget.Gadgets')
        $index['docs/references/pwsh/widget-gadgets/get-gadget.md'] |
            Should -Be @('pwsh/Widget.Gadgets/Get-Gadget.ps1', 'pwsh/Widget.Gadgets/Get-Gadget.cs')
        $index.Count | Should -Be 3
    }

    It 'lets the first matching pages entry win and takes a plain folder map as given' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{
                pages = @(
                    [ordered]@{ source = 'widgets/Widget.Gadgets'; docs = 'docs/references/gadgets' },
                    [ordered]@{ source = 'widgets/*'; docs = 'docs/references/widgets' }
                )
            })
        $config.PageFor('widgets/Widget.Gadgets/Get-Gadget.ps1') | Should -Be 'docs/references/gadgets/get-gadget.md'
        $config.PageFor('widgets/Widget.Other/Get-Gadget.ps1') | Should -Be 'docs/references/widgets/widget-other/get-gadget.md'
    }

    It 'scopes the pages that must map back to the docs folders of the pages entries' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{})
        $config.IsInScope('docs/references/pwsh/widget-gadgets/get-gadget.md') | Should -BeTrue
        $config.IsInScope('docs/references/contracts/catzc.md') | Should -BeFalse
    }

    It 'gives a file in an excluded folder no page, and leaves it out of the page index' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $config = [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{
                exclude = @('widgets/Gadget.Kit/assets/scripts')
                pages   = @(@{ source = 'widgets/*'; docs = 'docs/widgets' })
            })
        $config.PageFor('widgets/Gadget.Kit/assets/scripts/install.ps1') | Should -BeNullOrEmpty
        $config.PageFor('widgets/Gadget.Kit/assets/install.ps1') | Should -Be 'docs/widgets/gadget-kit/assets/install.md'
        $config.PageIndex([string[]] @('widgets/Gadget.Kit/assets/scripts/install.ps1', 'widgets/Gadget.Kit/assets/scripts/install.sh')).Count |
            Should -Be 0
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ exclude = @('widgets/*') }) } | Should -Throw '*no pattern*'
    }

    It 'rejects an unknown key, naming the allowed set' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ gadget = 1 }) } |
            Should -Throw '*unknown key*allowed: pages, articles, exclude*'
    }

    It 'rejects an empty pages list, and an article that is not a .md path under docs/' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @() }) } |
            Should -Throw '*pages must be a non-empty list*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ articles = @('notes/widget.md') }) } |
            Should -Throw "*article 'notes/widget.md' must be*"
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ articles = 'docs/widget.md' }) } |
            Should -Throw '*articles must be a list*'
    }

    It 'rejects a pages entry that is not a folder map with a plain docs folder' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        # A '[' in a -Throw pattern is a wildcard class, so the index brackets are escaped.
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @('widget') }) } |
            Should -Throw '*pages`[0`]*must be a map*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget' }) }) } |
            Should -Throw '*pages`[0`]*docs is required*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'notes/widget' }) }) } |
            Should -Throw '*must be a folder under docs/*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget/**'; docs = 'docs/widget' }) }) } |
            Should -Throw "*only a trailing '/*' is supported*"
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget/*'; docs = 'docs/{kebab}' }) }) } |
            Should -Throw '*must be a plain folder*derived*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = '/widget'; docs = 'docs/widget' }) }) } |
            Should -Throw '*no leading or trailing*'
        { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widget'; docs = 'docs/widget'; gadget = 1 }) }) } |
            Should -Throw '*unknown key*source, docs*'
    }
}
