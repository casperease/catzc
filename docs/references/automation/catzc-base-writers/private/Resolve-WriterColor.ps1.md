---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
    kind: comment-page
    body_sha: "596002b27dc8"
---

# automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `if ($ForegroundColor -is [string]) {`.

```text
A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any
other string falls through to the plain ConsoleColor cast below.
```
