---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/HelveticaMetrics.cs.md
    kind: comment-page
    body_sha: "79f4779831a8"
    adrs:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.Maps/types/HelveticaMetrics.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The advance widths of the two base-14 fonts PdfDocument writes, Helvetica and Helvetica-Bold, from their Adobe font
metrics, in thousandths of the font size. A viewer draws those fonts with these widths, so WorldMapPdf measures a
label with them to shrink or shorten it before it overflows its box. The table covers printable ASCII; any other
WinAnsi character is measured at its own width where the table lists it, else at the widest Latin letter (1000), so a
measured label is never narrower than the drawn one. BCL only
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)).
```
