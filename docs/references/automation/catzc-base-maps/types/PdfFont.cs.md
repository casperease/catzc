---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/PdfFont.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a1851ba2c465
---

# automation/Catzc.Base.Maps/types/PdfFont.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
The base-14 fonts the world-map PDFs print with. A base-14 font is built into every PDF reader, so PdfDocument
embeds no font program and the output stays small and deterministic; the price is WinAnsi-only text (WinAnsi).
PdfDocument names Helvetica /F1 and Helvetica-Bold /F2 in every page's resources.
```
