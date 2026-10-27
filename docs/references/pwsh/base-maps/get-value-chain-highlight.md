# pwsh/Base.Maps/Get-ValueChainHighlight.ps1

The command that lights the value-chain map's cells for a set of ADR codes: the cells each ADR sits in, with the ADRs that light each one.

## help

### synopsis

Returns the value-chain map cells that ADR codes light.

### description

Builds the value-chain map (Get-ValueChainMap) and lights its cells with Catzc.Base.Maps.ValueChainHighlight: each code (`ADR-<CODE>`, or
one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`) lights the cells its ADR sits in, its ADR domain's row crossed with each of its value-chain
concerns ([DDR-TRACK-LITCELL](../../../drs/design/tracks.md#rule-ddr-track-litcell),
[ADR-REPO-VALUECHAIN-MAP][r1]). A rule sits where its ADR sits, so a citation of one
rule lights the same cells as its ADR. Each lit cell lists the requested ADRs that light it. It is the value-chain counterpart of
Get-WorldMapHighlight -Adr, which lights where the ADR's files sit.

### parameter `Adr`

The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.

### parameter `AsJson`

Return the highlight as JSON (the request and the lit cells with their ADRs) instead of the object
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).

### outputs

`[Catzc.Base.Maps.ValueChainHighlight]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-ValueChainHighlight FDR-CD).Cells
```

### example 2

```powershell
Get-ValueChainHighlight -Adr 'DDR-TRACK-ONETECHSTACK', 'ADR-AUTO-TEST' -AsJson
```

[r1]: ../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map
