# pwsh/Base.Maps/types/ValueChainHighlight.cs

A value-chain highlight: the lit cells of the value-chain map for ADR references
([ADR-REPO-VALUECHAIN-MAP](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map),
[DDR-TRACK-LITCELL](../../../../drs/design/tracks.md#rule-ddr-track-litcell)).

## References

A reference is `ADR-<CODE>`, or one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`. A rule sits where its ADR sits, so it lights its ADR's cells.

## Lit cells

Each lit cell lists the requested ADRs that light it, with a `ValueChainReason` per ADR: its ADR domain's row, the concern, and whether the
concerns are the ADR's own override or its ADR domain's default. The cells keep the map's order (rows, then columns), so the result is
deterministic. `ToJson` is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).
