# pwsh/Base.Maps/types/WinAnsi.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
The WinAnsi character set: the only text the base-14 PDF fonts (Helvetica and its kin) can show, through their
WinAnsiEncoding (PDF 1.7, Annex D). It is ASCII 0x20-0x7E, Latin-1 0xA0-0xFF, and 27 typographic characters at
0x80-0x9F (the euro sign, curly quotes, en and em dash, bullet, ellipsis, ...). A label the world-map PDFs print
must be encodable here, so MapsConfig rejects any other label at load; '×' (0xD7) is encodable, '→' is not. Control
characters are not: a label is one printable line.
```

## comment:2

Above `public static int IndexOfUnsupported(string text)`, written with `//`.

```text
The index of the first character of the text that has no WinAnsi code, or -1 when every character has one. An
empty or null text has none.
```
