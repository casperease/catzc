---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/private/Format-GitIgnoreSection.ps1.md
    kind: reference
    body_sha: f1296676727b
    adrs: []
---

# automation/Catzc.Base.Git/private/Format-GitIgnoreSection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The per-section pretty-printer behind New-GitIgnore: a rule line carrying the section's title, the wrapped
`why` explanation as comment lines, then each pattern verbatim — with any `note` rendered as its own comment
line directly above its pattern. git has no trailing comments: a '#' after a pattern becomes part of the
pattern, so a noted pattern written on one line would match nothing. Pure formatting; the pattern text is never
rewritten.
```
