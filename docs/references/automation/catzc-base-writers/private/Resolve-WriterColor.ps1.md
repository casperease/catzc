---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4426264fdb44"
---

# automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($ForegroundColor -is [string]) {`, written with `#`.

```text
A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any
other string falls through to the plain ConsoleColor cast below.
```
