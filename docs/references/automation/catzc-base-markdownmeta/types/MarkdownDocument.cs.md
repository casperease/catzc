---
catzc:
  derived:
    path: docs/references/automation/catzc-base-markdownmeta/types/MarkdownDocument.cs.md
    kind: reference
    body_sha: "56475cf9128b"
    adrs: []
---

# docs/references/automation/catzc-base-markdownmeta/types/MarkdownDocument.cs.md

`automation/Catzc.Base.MarkdownMeta/types/MarkdownDocument.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `public string BodyHash()`.

```text
The first 12 hex characters of the SHA-256 of the body, its line endings read as LF and its leading blank lines dropped. The blank
line that separates written front matter from the body is no part of the body, so imprinting never changes the hash it records.
```
