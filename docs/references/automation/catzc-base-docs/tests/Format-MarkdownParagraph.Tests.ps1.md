---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Format-MarkdownParagraph.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c7c9f77db18d
    adrs:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/tests/Format-MarkdownParagraph.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Format-MarkdownParagraph' -Tag 'L0', 'logic' {`, written with `#`.

```text
Format-MarkdownParagraph must fill text the way Prettier's proseWrap: always does, so the generated ADR index, glossary,
and contract reference are formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)).
```
