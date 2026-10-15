---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/MarkdownLinkRebaser.Tests.ps1.md
    kind: test-asset
    body_sha: "0c9a736dad8a"
    adrs:
      - ADR-REPO-README#6
---

# automation/Catzc.Base.Docs/tests/types/MarkdownLinkRebaser.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'MarkdownLinkRebaser' -Tag 'L0', 'logic', 'ADR-REPO-README#6' {`.

```text
A generated README copies an article into another folder; its relative links are rebased so they resolve there
([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)).
```
