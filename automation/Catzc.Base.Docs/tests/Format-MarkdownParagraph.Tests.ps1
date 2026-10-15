<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Format-MarkdownParagraph.Tests.ps1
    kind: pester-test
---
#>

# Format-MarkdownParagraph must fill text the way Prettier's proseWrap: always does, so the generated ADR index, glossary,
# and contract reference are formatter-stable
# ([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)).
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
