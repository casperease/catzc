<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/GitHubAnchor.Tests.ps1
    kind: test
---
#>

# The GitHub slug and anchor set a markdown link's #fragment must name
# ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). The slug cases are the
# shapes the repository's headings take: rule headings, responsibility headings with an em dash, code spans, and duplicates.
Describe 'GitHubAnchor' -Tag 'L0', 'logic' {
    It 'slugs a rule heading to rule- plus the lowercased code and number' -Tag 'ADR-REPO-LINK#2' {
        [Catzc.Base.Docs.GitHubAnchor]::Slug('Rule ADR-TST-WIDGET:1') | Should -BeExactly 'rule-adr-tst-widget1'
    }

    It 'drops punctuation and keeps the space either side of an em dash as two hyphens' -Tag 'ADR-REPO-LINK#2' {
        [Catzc.Base.Docs.GitHubAnchor]::Slug('responsibility:1 — Widget invocation') | Should -BeExactly 'responsibility1--widget-invocation'
    }

    It 'reduces inline markup to its text: code spans, links, and emphasis' -Tag 'ADR-REPO-LINK#2' {
        [Catzc.Base.Docs.GitHubAnchor]::Slug('The `widget/` folder') | Should -BeExactly 'the-widget-folder'
        [Catzc.Base.Docs.GitHubAnchor]::Slug('See [the gadget](gadget.md) **now**') | Should -BeExactly 'see-the-gadget-now'
    }

    It 'drops a code span made only of punctuation and keeps both spaces around it as two hyphens' -Tag 'ADR-REPO-LINK#2' {
        [Catzc.Base.Docs.GitHubAnchor]::Slug('The `$?` widget') | Should -BeExactly 'the--widget'
    }

    It 'keeps underscores, hyphens, digits, and non-ASCII letters' -Tag 'ADR-REPO-LINK#2' {
        [Catzc.Base.Docs.GitHubAnchor]::Slug('snake_case widget-2 Café') | Should -BeExactly 'snake_case-widget-2-café'
    }

    It 'collects every heading, suffixes duplicates, counts explicit anchors, and skips fenced blocks' -Tag 'ADR-REPO-LINK#2' {
        $markdown = @(
            '# Widget'
            '## Notes'
            '## Notes'
            '<a id="gadget-anchor"></a>'
            '```markdown'
            '## Not A Heading'
            '```'
            'Setext widget'
            '-------------'
            '### Closed heading ###'
        ) -join "`n"
        $anchors = [Catzc.Base.Docs.GitHubAnchor]::Anchors($markdown)
        $anchors | Should -Contain 'widget'
        $anchors | Should -Contain 'notes'
        $anchors | Should -Contain 'notes-1'
        $anchors | Should -Contain 'gadget-anchor'
        $anchors | Should -Contain 'setext-widget'
        $anchors | Should -Contain 'closed-heading'
        $anchors | Should -Not -Contain 'not-a-heading'
    }
}
