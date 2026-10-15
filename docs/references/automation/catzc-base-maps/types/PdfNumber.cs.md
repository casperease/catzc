---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/PdfNumber.cs.md
    kind: comment-page
    body_sha: "969a373c714a"
    adrs: []
---

# automation/Catzc.Base.Maps/types/PdfNumber.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
How PdfDocument writes a number: invariant culture, at most three decimals, no exponent, no negative zero, and no
trailing zeros, so the same value always gives the same bytes whatever the session's culture. A PDF number has no
exponent form, and a thousandth of a point is far below what a reader can show.
```
