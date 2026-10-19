# automation/pwsh/Catzc.Base.Maps/types/PdfPage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One page of a PdfDocument: its size in points and the content-stream operators drawn on it, in call order. The
coordinates are PDF user space: the origin at the bottom-left corner, one unit per point. Each drawing call appends
one line of operators; PdfDocument writes the lines as the page's content stream. Text goes through WinAnsi, the
only encoding the base-14 fonts show, and a character outside it throws instead of printing a wrong glyph. Numbers
go through PdfNumber, so the bytes do not depend on the culture
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](/docs/adr/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)).
```

## comment:2

Above `public PdfPage Text(PdfFont font, double size, double x, double y, string text)`, written with `//`.

```text
One line of text in the fill colour, its baseline starting at (x, y) (BT Tf Td Tj ET). The text must be WinAnsi;
'(', ')' and '\' are escaped, and every byte from 0x80 up is written as an octal escape, so the stream stays ASCII.
```

## comment:3

Above `public static string Escape(string text)`, written with `//`.

```text
The text as the body of a PDF literal string: WinAnsi codes, with '(', ')' and '\' escaped and 0x80-0xFF as
three-digit octal escapes. A character with no WinAnsi code throws, named by its code point and index.
```
