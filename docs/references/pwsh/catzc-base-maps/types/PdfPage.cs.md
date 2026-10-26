# pwsh/Base.Maps/types/PdfPage.cs

One page of a `PdfDocument`: its size in points and the content-stream operators drawn on it, in call order.

## Drawing

The coordinates are PDF user space: the origin at the bottom-left corner, one unit per point. Each drawing call appends one line of
operators, and `PdfDocument` writes the lines as the page's content stream. Numbers go through `PdfNumber`, so the bytes do not depend on
the culture
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)).

## Text

`Text` writes one line in the fill colour, its baseline starting at (x, y). The text goes through `WinAnsi`, the only encoding the base-14
fonts show, and a character outside it throws instead of printing a wrong glyph. `Escape` turns the text into the body of a PDF literal
string: `(`, `)` and `\` are escaped and every byte from 0x80 up is written as a three-digit octal escape, so the stream stays ASCII. A
character with no WinAnsi code throws, named by its code point and index.
