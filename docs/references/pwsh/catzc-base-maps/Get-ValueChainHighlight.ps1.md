# pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the value-chain map cells that ADR codes light.

### description

Builds the value-chain map (Get-ValueChainMap) and lights its cells with Catzc.Base.Maps.ValueChainHighlight: each code (`ADR-<CODE>`, or
one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`) lights the cells its ADR sits in, its ADR domain's row crossed with each of its value-chain
concerns ([ADR-DSGN-TRACK#12](../../../adr/design/tracks.md#rule-adr-dsgn-track12),
[ADR-DSGN-TRACK#16](../../../adr/design/tracks.md#rule-adr-dsgn-track16)). A rule sits where its ADR sits, so a citation of one rule lights
the same cells as its ADR. Each lit cell lists the requested ADRs that light it. It is the value-chain counterpart of Get-WorldMapHighlight
-Adr, which lights where the ADR's files sit.

### parameter `Adr`

The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.

### parameter `AsJson`

Return the highlight as JSON (the request and the lit cells with their ADRs) instead of the object
([ADR-THES-ONETRUTH#3](../../../adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).

### outputs

`[Catzc.Base.Maps.ValueChainHighlight]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-ValueChainHighlight ADR-FLOW-CD).Cells
```

### example 2

```powershell
Get-ValueChainHighlight -Adr 'ADR-DSGN-TRACK#3', 'ADR-AUTO-TEST' -AsJson
```
