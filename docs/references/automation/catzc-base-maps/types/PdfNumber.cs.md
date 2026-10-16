---
catzc:
  immutable:
    with_body_sha: fe8e0cbd60d9
    path: docs/references/automation/catzc-base-maps/types/PdfNumber.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: pdf-number-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Maps/types/PdfNumber.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
How PdfDocument writes a number: invariant culture, at most three decimals, no exponent, no negative zero, and no
trailing zeros, so the same value always gives the same bytes whatever the session's culture. A PDF number has no
exponent form, and a thousandth of a point is far below what a reader can show.
```
