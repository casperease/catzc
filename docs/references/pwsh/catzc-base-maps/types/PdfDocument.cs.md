# pwsh/Base.Maps/types/PdfDocument.cs

A minimal PDF 1.4 writer for the world-map PDFs: pages of vector rectangles, lines and base-14 Helvetica text, written by hand with the BCL
only ([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)),
since PDF is a text format.

## Deterministic bytes

The same pages always give the same file. There is no creation or modification date, the `/ID` is taken from a SHA-256 of the body, numbers
go through `PdfNumber`, objects come in a fixed order, and line ends are `\n`.

## Layout

The file holds the catalog (object 1), the page tree (2), Helvetica (3) and Helvetica-Bold (4), then each page and its content stream,
uncompressed. The xref table follows with each object's exact byte offset, then the trailer, `startxref` and `%%EOF`.
