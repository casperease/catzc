# docs/references/automation/catzc-base-maps/types/PdfFont.cs.md

`automation/Catzc.Base.Maps/types/PdfFont.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
The base-14 fonts the world-map PDFs print with. A base-14 font is built into every PDF reader, so PdfDocument
embeds no font program and the output stays small and deterministic; the price is WinAnsi-only text (WinAnsi).
PdfDocument names Helvetica /F1 and Helvetica-Bold /F2 in every page's resources.
```
