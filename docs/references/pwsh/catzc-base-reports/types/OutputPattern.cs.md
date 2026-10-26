# pwsh/Base.Reports/types/OutputPattern.cs

One output-format pattern: an output-root-relative glob, parsed once
([ADR-REPO-OUTFMT-OUTPUTFORMAT](../../../../drs/repository/output-formats.md#rule-adr-repo-outfmt-outputformat)). It answers two questions: does
a path match it (`Matches`), and can any path match both it and another pattern (`Overlaps`). The catalogue rejects two formats whose patterns
overlap, so a file's format never depends on order or specificity.

## Grammar

Per `/`-separated segment:

- `**` as a whole segment matches zero or more segments;
- `{stamp}` as a whole segment matches one stamped run folder (`yyyyMMdd-HHmmss`, optionally `-<hex>`);
- otherwise literal characters, where `*` matches any run and `?` one character inside the segment.

A pattern is relative (`/` separated, no `\`, no `..`, no `:`, not rooted, no empty segment), `**` never sits inside a segment, and `{` or `}`
appear only in `{stamp}`.

## Overlap

Overlap is decided exactly for literals, `*`, `?` and `**`. A `{stamp}` segment against a segment with wildcards counts as overlapping, so an
accepted catalogue is always free of overlaps.
