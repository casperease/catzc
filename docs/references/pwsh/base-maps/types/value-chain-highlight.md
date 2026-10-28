# pwsh/Base.Maps/types/ValueChainHighlight.cs

A value-chain highlight: the lit cells of the value-chain map for record references
([ADR-REPO-VALUECHAIN-MAP](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map),
[DDR-TRACK-LITCELL](../../../../drs/design/tracks.md#rule-ddr-track-litcell)).

## References

A reference is `ADR-<CODE>`, or one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`. A rule sits where its record sits, so it lights its record's
cells.

## Lit cells

Each lit cell lists the requested records that light it, with a `ValueChainReason` per record: its domain's row, the concern, and whether
the concerns are the record's own override or its domain's default. The cells keep the map's order (rows, then columns), so the result is
deterministic. `ToJson` is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).
