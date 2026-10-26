# pwsh/Base.Maps/types/WorldMapPdfDrawing.cs

The drawing helpers `WorldMapPdf` shares between its pages: the column header and the legend.

## Column header

A column header is fitted into its box on one or two lines (`FitLines`), each line centred, the block set on the box's vertical middle, in
the current fill colour.

## Legend

The legend band holds the file-count scale, the stack-violation mark and, with a highlight, the lit-cell outline with the request.
