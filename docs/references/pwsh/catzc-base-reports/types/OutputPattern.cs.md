# pwsh/Catzc.Base.Reports/types/OutputPattern.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One output-format pattern: an output-root-relative glob, parsed once
([ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)). It answers two questions:
does a path match it (Matches), and can any path match both it and another pattern (Overlaps). The catalogue
rejects two formats whose patterns overlap, so a file's format never depends on order or specificity.

Grammar, per '/'-separated segment:
  - '**' as a whole segment matches zero or more segments;
  - '{stamp}' as a whole segment matches one stamped run folder (yyyyMMdd-HHmmss, optionally '-<hex>');
  - otherwise literal characters, where '*' matches any run and '?' one character inside the segment.
A pattern is relative ('/' separated, no '\', no '..', no ':', not rooted, no empty segment), '**' never sits
inside a segment, and '{' or '}' appear only in '{stamp}'.

Overlap is decided exactly for literals, '*', '?' and '**'. A '{stamp}' segment against a segment with
wildcards counts as overlapping, so an accepted catalogue is always free of overlaps.
```
