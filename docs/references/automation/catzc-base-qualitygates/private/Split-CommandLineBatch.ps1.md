---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Split-CommandLineBatch.ps1.md
    kind: comment-page
    body_sha: "02f4b30b368b"
---

# automation/Catzc.Base.QualityGates/private/Split-CommandLineBatch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A formatter engine that takes files as arguments runs once per batch, so formatting every tracked file never
exceeds the command-line length. The binding limit is cmd.exe's 8 191 characters: npm installs tools such as
prettier as .cmd shims, which cmd.exe expands with the node path prepended, so the default leaves room for that.
Each item is counted with the quotes and the separating space it is written with. An item longer than the limit
is a batch of its own.
```
