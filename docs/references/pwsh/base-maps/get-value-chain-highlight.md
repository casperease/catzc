# pwsh/Base.Maps/Get-ValueChainHighlight.ps1

The command that lights the value-chain map's cells for a set of rule codes: the cells each record sits in, with the records that light each
one.

## help

### synopsis

Returns the value-chain map cells that rule codes light.

### description

Builds the value-chain map (Get-ValueChainMap) and lights its cells with Catzc.Base.Maps.ValueChainHighlight: each code (`ADR-<CODE>`, or
one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`) lights the cells its record sits in, its DRS domain's row crossed with each of its value-chain
concerns ([DDR-TRACK-LITCELL](../../../drs/design/tracks.md#rule-ddr-track-litcell), [ADR-REPO-VALUECHAIN-MAP][r1]). A rule sits where its
record sits, so a citation of one rule lights the same cells as its record. Each lit cell lists the requested records that light it. It is
the value-chain counterpart of Get-WorldMapHighlight -Rule, which lights where the record's files sit.

### parameter `Rule`

The record codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.

### parameter `AsJson`

Return the highlight as JSON (the request and the lit cells with their records) instead of the object
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).

### outputs

`[Catzc.Base.Maps.ValueChainHighlight]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-ValueChainHighlight FDR-CD).Cells
```

### example 2

```powershell
Get-ValueChainHighlight -Rule 'DDR-TRACK-ONETECHSTACK', 'ADR-AUTO-TEST' -AsJson
```

[r1]: ../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map
