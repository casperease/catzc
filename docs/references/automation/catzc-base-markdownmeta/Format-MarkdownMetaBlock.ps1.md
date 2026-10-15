---
catzc:
  derived:
    path: docs/references/automation/catzc-base-markdownmeta/Format-MarkdownMetaBlock.ps1.md
    kind: reference
    body_sha: "4fce42414409"
    adrs: []
---

# automation/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The `derived` part is written from -Fact in the order given, one canonical form, so the same facts always give the same bytes.
The authored `config` part and every other byte of the text are kept as written. With no facts and no config lines the block is
removed. Pure: it reads no file and no config, and it returns the text rather than writing it.
```
