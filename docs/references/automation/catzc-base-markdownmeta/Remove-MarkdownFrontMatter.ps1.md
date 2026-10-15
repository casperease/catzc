---
catzc:
  derived:
    path: docs/references/automation/catzc-base-markdownmeta/Remove-MarkdownFrontMatter.ps1.md
    kind: reference
    body_sha: d71720b4d0f4
    adrs: []
---

# docs/references/automation/catzc-base-markdownmeta/Remove-MarkdownFrontMatter.ps1.md

`automation/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
For a copy that carries the content but not the file's meta: a generated README, which a reader opens with its title first. The
blank line that separates written front matter from the body goes with it. A text with no front matter comes back unchanged.
Pure: it reads no file and no config.
```
