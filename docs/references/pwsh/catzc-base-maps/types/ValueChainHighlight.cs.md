# pwsh/Catzc.Base.Maps/types/ValueChainHighlight.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A value-chain highlight: the lit cells of the value-chain map for ADR references
([DDR-TRACK-VALUECHAINMAP](/docs/drs/design/tracks.md#rule-ddr-track-valuechainmap),
[DDR-TRACK-LITCELL](/docs/drs/design/tracks.md#rule-ddr-track-litcell)). A reference is ADR-<CODE>, or one rule as
ADR-<CODE>#n or ADR-<CODE>:n; a rule sits where its ADR sits, so it lights its ADR's cells. Each lit cell lists the
requested ADRs that light it, with a ValueChainReason per ADR (its ADR domain's row, the concern, and whether the
concerns are the ADR's own override or its ADR domain's default). The cells keep the map's order (rows, then
columns), so the result is deterministic; ToJson is its data form
([TDR-ONETRUTH-TRUTHISQUERYABLE](/docs/drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).
```
