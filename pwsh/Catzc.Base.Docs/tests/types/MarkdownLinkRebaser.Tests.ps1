Describe 'MarkdownLinkRebaser' -Tag 'L0', 'logic', 'ADR-REPO-README-WORKINGLINKS' {
    BeforeAll {
        # The article lives in docs/references/widget/ and is copied into the widget/ folder at the root.
        $script:rebase = {
            param([string] $Text)
            [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase($Text, 'docs/references/widget/article.md', 'widget')
        }
    }

    Context 'rebased' {
        It 'a sibling link' {
            & $script:rebase '[g](gadget.md)' | Should -BeExactly '[g](../docs/references/widget/gadget.md)'
        }

        It 'a link climbing out of the source folder' {
            & $script:rebase '[r](../../adr/widget/rules.md)' | Should -BeExactly '[r](../docs/adr/widget/rules.md)'
        }

        It 'a link into the copy''s own folder, which shortens' {
            & $script:rebase '[s](../../../widget/settings.yml)' | Should -BeExactly '[s](settings.yml)'
        }

        It 'a link to the copy''s own folder' {
            & $script:rebase '[here](../../../widget/)' | Should -BeExactly '[here](./)'
        }

        It 'keeps the #fragment and a trailing slash' {
            & $script:rebase '[a](../gadget/#setup) [b](sub/)' | Should -BeExactly '[a](../docs/references/gadget/#setup) [b](../docs/references/widget/sub/)'
        }

        It 'an image, an angle-bracket target with a title, and a reference definition' {
            & $script:rebase '![d](diagram.png) [t](<gadget.md> "Gadget")' | Should -BeExactly '![d](../docs/references/widget/diagram.png) [t](<../docs/references/widget/gadget.md> "Gadget")'
            & $script:rebase '[gadget]: gadget.md' | Should -BeExactly '[gadget]: ../docs/references/widget/gadget.md'
        }

        It 'every link on every line, CRLF kept' {
            & $script:rebase "[a](a.md) and [b](b.md)`r`n[c](c.md)`r`n" |
                Should -BeExactly "[a](../docs/references/widget/a.md) and [b](../docs/references/widget/b.md)`r`n[c](../docs/references/widget/c.md)`r`n"
        }
    }

    Context 'left as written' {
        It 'a URL, an in-file anchor, and a repository-rooted target' {
            $text = '[u](https://example.com/x.md) [m](mailto:widget@example.com) [h](#setup) [r](/docs/adr/index.md)'
            & $script:rebase $text | Should -BeExactly $text
        }

        It 'link-shaped text in an inline code span' {
            $text = 'Write `[g](gadget.md)` like this, but [g](gadget.md) here.'
            & $script:rebase $text | Should -BeExactly 'Write `[g](gadget.md)` like this, but [g](../docs/references/widget/gadget.md) here.'
        }

        It 'a fenced code block' {
            $text = "``````markdown`n[g](gadget.md)`n``````"
            & $script:rebase $text | Should -BeExactly $text
        }

        It 'a target that climbs above the repository root' {
            $text = '[x](../../../../outside.md)'
            & $script:rebase $text | Should -BeExactly $text
        }

        It 'text with no links, and empty text' {
            & $script:rebase 'No links here.' | Should -BeExactly 'No links here.'
            & $script:rebase '' | Should -BeExactly ''
        }
    }

    Context 'same folder' {
        It 'changes nothing when the copy sits beside its source' {
            [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase('[g](gadget.md) [u](../up.md)', 'docs/widget/index.md', 'docs/widget') |
                Should -BeExactly '[g](gadget.md) [u](../up.md)'
        }
    }

    Context 'a moved path' {
        It 'a page that stays re-points only its links into the moved folder, and keeps every other link as written' {
            [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase('[s](assets/widget/slide.png) [g](./gadget.md) [w](assets/widgetry.md)', 'docs/widget/index.md', 'docs/widget', 'docs/widget/assets/widget', 'docs/widget/.assets/widget') |
                Should -BeExactly '[s](.assets/widget/slide.png) [g](./gadget.md) [w](assets/widgetry.md)'
        }

        It 'a page that stays re-points a link to a moved file' {
            [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase('![s](../assets/grid/widget.png#top)', 'docs/widget/index.md', 'docs/widget', 'docs/assets/grid/widget.png', 'docs/widget/.assets/widget/grid.png') |
                Should -BeExactly '![s](.assets/widget/grid.png#top)'
        }

        It 'a moved file re-points its links out of the folder and keeps its links inside it' {
            [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase('[a](../../index.md) [g](grid.png)', 'docs/widget/assets/widget/diagram.md', 'docs/gadget/.assets/widget', 'docs/widget/assets/widget', 'docs/gadget/.assets/widget') |
                Should -BeExactly '[a](../../../widget/index.md) [g](grid.png)'
        }
    }

    Context 'RelativeLink' {
        It 'links from a folder to a repository path' {
            [Catzc.Base.Docs.MarkdownLinkRebaser]::RelativeLink('widget/sub', 'docs/references/widget.md') | Should -BeExactly '../../docs/references/widget.md'
            [Catzc.Base.Docs.MarkdownLinkRebaser]::RelativeLink('docs/widget', 'docs/widget/index.md') | Should -BeExactly 'index.md'
            [Catzc.Base.Docs.MarkdownLinkRebaser]::RelativeLink('', 'docs/widget.md') | Should -BeExactly 'docs/widget.md'
        }
    }
}
