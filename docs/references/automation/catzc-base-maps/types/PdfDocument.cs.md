---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/PdfDocument.cs.md
    kind: reference
    body_sha: e2e4bc0d3e95
    adrs:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.Maps/types/PdfDocument.cs

<!-- cspell:ignore startxref endstream nendobj -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A minimal PDF 1.4 writer for the world-map PDFs: pages of vector rectangles, lines and base-14 Helvetica text,
written by hand with the BCL only ([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)),
since PDF is a text format. The bytes are deterministic: no CreationDate or ModDate, a /ID taken from a SHA-256 of
the body, numbers through PdfNumber, objects in a fixed order, and '\n' line ends, so the same pages always give the
same file. The layout is: the catalog (1), the page tree (2), Helvetica (3) and Helvetica-Bold (4), then each page
and its content stream, uncompressed; then the xref table with each object's exact byte offset, the trailer,
startxref and %%EOF.
```
