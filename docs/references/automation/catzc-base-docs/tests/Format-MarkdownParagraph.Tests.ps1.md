---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Format-MarkdownParagraph.Tests.ps1.md
    kind: test-asset
    body_sha: ab23da84e9e4
    adrs:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/tests/Format-MarkdownParagraph.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Format-MarkdownParagraph' -Tag 'L0', 'logic' {`.

```text
Format-MarkdownParagraph must fill text the way Prettier's proseWrap: always does, so the generated ADR index, glossary,
and contract reference are formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)).
```
