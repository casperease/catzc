# pwsh/Base.Maps/types/WorldMap.cs

The world map: the tracks (rows) crossed with the file languages (columns), every cell of that grid with its file count, and the placement
of every tracked file in exactly one cell ([DDR-TRACK-ISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster),
[DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)).

## Buckets

Two buckets close the grid so no file is left out. The `NoTrack` row holds the files under no track: the repository root's own files, and
`out/`. The `NoFileLanguage` column holds the files no file language names, which have no extension or an extension no entry lists.

## Order

The order is deterministic: rows and columns in ordinal order with the bucket last, cells row by row, placements by path.

## Who builds and returns it

`WorldMapBuilder` builds one, `Get-WorldMap` returns it, and `ToJson` is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).
