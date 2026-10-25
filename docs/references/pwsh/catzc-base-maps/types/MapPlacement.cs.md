# pwsh/Catzc.Base.Maps/types/MapPlacement.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Where one tracked file sits on the world map, and what lights it. The cell is exact: the root folder gives the track
and the extension gives the file language. The highlight relation follows the fixed order per artifact kind that
WorldMapBuilder applies: an ADR file carries its own ADR code; every other file carries ADR citations, and Basis names the
step that produced them. A result type, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```

## comment:2

Above `public bool Live { get; }`, written with `//`.

```text
True when the file is in its track's live aspect; false for a test file, a vendored file, a file of a
verification track, and a file under no track.
```

## comment:3

Above `public IReadOnlyList<CitationSite> Sites { get; }`, written with `//`.

```text
Where those citations sit (CitationSite): in the file itself for BasisCitations, in the owner's or the globset's
files for BasisFilesYml and BasisGlobSet; empty for an ADR file and a file nothing lights.
```
