# pwsh/Base.Maps/types/HelveticaMetrics.cs

The advance widths of the two base-14 fonts `PdfDocument` writes, Helvetica and Helvetica-Bold, from their Adobe font metrics, in
thousandths of the font size. A viewer draws those fonts with these widths, so `WorldMapPdf` measures a label with them to shrink or
shorten it before it overflows its box.

## Coverage

The table covers printable ASCII. Any other WinAnsi character is measured at its own width where the table lists it, else at the widest
Latin letter (1000), so a measured label is never narrower than the drawn one.

## Why it is shaped so

It uses the BCL only
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)),
so the PDF writer needs no font library.
