# pwsh/Base.Maps/types/WinAnsi.cs

The WinAnsi character set: the only text the base-14 PDF fonts (Helvetica and its kin) can show, through their WinAnsiEncoding (PDF 1.7,
Annex D).

## What it holds

It is ASCII 0x20-0x7E, Latin-1 0xA0-0xFF, and 27 typographic characters at 0x80-0x9F (the euro sign, curly quotes, en and em dash, bullet,
ellipsis and others). Control characters are not in it: a label is one printable line.

## Why it matters

A label the world-map PDFs print must be encodable here, so `MapsConfig` rejects any other label at load. The multiplication sign `×` (0xD7)
is encodable, the arrow `→` is not. `IndexOfUnsupported` returns the index of the first character of a text that has no WinAnsi code, or -1
when every character has one; an empty or null text has none.
