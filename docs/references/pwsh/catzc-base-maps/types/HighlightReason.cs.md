# pwsh/Base.Maps/types/HighlightReason.cs

Why a highlight lights a file, or a cell with no file. It is the unit of evidence a lit cell carries, so a reader can follow every lit cell
back to the file and the citation behind it.

## Fields

- the file;
- the step that tied it to the request: a `MapPlacement` basis, `path` for a requested file, or `pin` for a reviewed pin of
  `configs/maps.yml`;
- the requested citation that covers it;
- the citation sites the request covers, which are where the file, or its owner's or globset's files, cite it.

An adr-file reason names the requested ADR's own file and has no site. A file lit only by comment sites is a passing mention (`Mention`),
so a reader can tell a lit file's subject from a mention.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
