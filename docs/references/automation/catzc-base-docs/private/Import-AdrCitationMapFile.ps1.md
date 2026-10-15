---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Import-AdrCitationMapFile.ps1.md
    kind: comment-page
    body_sha: "934a6388e39e"
---

# automation/Catzc.Base.Docs/private/Import-AdrCitationMapFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The map's first line must be exactly the expected header, and every row must have one cell per header column;
anything else throws, naming the file and line, before a single reference is rewritten
([ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md)). Blank lines are skipped. The cells are
validated by [Catzc.Base.Docs.AdrCitationRewriter], which reads the rows.
```
