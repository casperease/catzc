# pwsh/Base.Maps/types/MapPlacement.cs

Where one tracked file sits on the world map, and what lights it. The cell is exact: the root folder gives the track and the extension gives
the file language.

## Highlight relation

The relation follows the fixed order per artifact kind that `WorldMapBuilder` applies. An ADR file carries its own ADR code. Every other
file carries ADR citations, and `Basis` names the step that produced them. `Sites` says where those citations sit (`CitationSite`): in the
file itself for a citations basis, in the owner's or the globset's files for the files.yml and globset bases. It is empty for an ADR file
and for a file nothing lights.

## Live

`Live` is true when the file is in its track's live aspect. It is false for a test file, a vendored file, a file of a verification track and
a file under no track.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
