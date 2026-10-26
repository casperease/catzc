# pwsh/Base.Maps/types/WorldMapHighlight.cs

A world-map highlight: the cells a request lights. A request is either ADR references or a drawing's files
([DDR-TRACK-ISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster) places each file in one cell).

## ADR references

`ForAdr` takes each `ADR-<CODE>`, `ADR-<CODE>#n` or `ADR-<CODE>:n`. A reference that is not an ADR code the map's index lists throws. It
lights, through the placements `WorldMapBuilder` derived in its fixed order per artifact kind, each requested ADR's own file (an
`ADR-<CODE>#n` request lights its ADR's file) and every file whose citations a request covers (`CitationScanner.Covers`). An ADR's domain
never lights a file: it only picks the value-chain row.

## Pins and exceptions

The reviewed overrides of `configs/maps.yml` then apply: an exception a request covers keeps its cell dark, and a pin a request covers
lights its cell, so a pin wins over an exception. A pin or exception that names a cell the map does not have throws.

## Files

`ForPaths` lights the cells the given files sit in.

## Reasons

Every lit file, and every pin, carries its reason (`HighlightReason`): the basis, the covering request, and the citation sites with their
lines and kinds, so a lit file cited only in passing comments reads as a mention. The cells keep the map's order (rows, then columns), so
the result is deterministic. `ToJson` is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).
