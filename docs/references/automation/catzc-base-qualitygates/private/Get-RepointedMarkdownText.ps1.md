---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-RepointedMarkdownText.ps1.md
    kind: reference
    body_sha: "8f7339fe6c69"
    adrs:
      - ADR-REPO-FORMAT#7
---

# automation/Catzc.Base.QualityGates/private/Get-RepointedMarkdownText.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every inline link `[text](<target>#<fragment>)` — a relative target, or none for the file's own headings — is
resolved against the file's folder; when `<resolved path>#<fragment>` is a key of Rename, the fragment is
replaced by its value. The link text, the target as written, and every other byte are kept, so the text is
returned unchanged when no link matches. Used by the heading normal form, which renames anchors
([ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)).
```
