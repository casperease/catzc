# pwsh/Base.Maps/types/PdfFont.cs

The base-14 fonts the world-map PDFs print with. A base-14 font is built into every PDF reader, so `PdfDocument` embeds no font program and
the output stays small and deterministic. The price is WinAnsi-only text (see `WinAnsi`). `PdfDocument` names Helvetica `/F1` and
Helvetica-Bold `/F2` in every page's resources.
