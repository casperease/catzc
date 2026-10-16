---
catzc:
  immutable:
    with_body_sha: b7484699bf8b
    repo_status: locked
    path: docs/references/automation/catzc-base-maps/types/HelveticaMetrics.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: helvetica-metrics-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.Maps/types/HelveticaMetrics.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The advance widths of the two base-14 fonts PdfDocument writes, Helvetica and Helvetica-Bold, from their Adobe font
metrics, in thousandths of the font size. A viewer draws those fonts with these widths, so WorldMapPdf measures a
label with them to shrink or shorten it before it overflows its box. The table covers printable ASCII; any other
WinAnsi character is measured at its own width where the table lists it, else at the widest Latin letter (1000), so a
measured label is never narrower than the drawn one. BCL only
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)).
```
