<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Format-MarkdownParagraph.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/Format-MarkdownParagraph.Tests.ps1.md
      source: automation/Catzc.Base.Docs/Format-MarkdownParagraph.ps1
    adrs:
      - ADR-REPO-FORMAT#5
---
#>

Describe 'Format-MarkdownParagraph' -Tag 'L0', 'logic' {
    It 'fills greedily within the width, prefix included' {
        $lines = Format-MarkdownParagraph -Text ('widget gadget  widget' + "`n" + 'gadget widget') -FirstPrefix '- ' -ContinuationPrefix '  ' -Width 16
        $lines | Should -Be @('- widget gadget', '  widget gadget', '  widget')
    }

    It 'keeps a code span and a link whole, spaces included' {
        $lines = Format-MarkdownParagraph -Text 'see `widget gadget` and [the gadget](widget.md) now' -Width 12
        $lines | Should -Be @('see', '`widget gadget`', 'and', '[the gadget](widget.md)', 'now')
    }

    It 'joins a code span that the source wrapped across lines' {
        $lines = Format-MarkdownParagraph -Text ('a `widget' + "`n" + '   gadget` b')
        $lines | Should -Be @('a `widget gadget` b')
    }
}
