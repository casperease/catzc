---
catzc:
  immutable:
    with_body_sha: "4271ba899c4f"
    repo_status: locked
    path: docs/explanation/azure/.assets/coordinate-rules-and-their-gates/chain.md
    source: docs/explanation/azure/.assets/coordinate-rules-and-their-gates/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two ADRs rule the coordinate; one shared check and the integrity tests hold them: the value-chain minimap

```text
Where ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD sit in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of Two ADRs rule the coordinate; one shared check and the integrity tests hold them](chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [Two ADRs rule the coordinate; one shared check and the
integrity tests hold them][4], which explains [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]. It lights the cells of the value-chain map where
the cited ADRs' value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its reason below,
naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 2 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- CLOUD × deploy: 2 lit of 23 ADRs
- CLOUD × access: 1 lit of 3 ADRs

## Key

Rows are the value-chain stack and columns the value-chain concerns, each printed as a capital code:

- `PRIN`: the PRIN row of the value-chain stack
- `DSGN`: the DSGN row of the value-chain stack
- `AUTO`: the AUTO row of the value-chain stack
- `PIPE`: the PIPE row of the value-chain stack
- `CLOUD`: the CLOUD row of the value-chain stack
- `BUILD`: build
- `QC`: quality-control
- `RELEASE`: release
- `DEPLOY`: deploy
- `ACCESS`: access

## Why each cell is lit

### CLOUD × deploy (2 ADRs)

Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [ADR-AZ-CUSTOMER][1]: selected by [ADR-AZ-CUSTOMER][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][3]); its value-chain concerns (deploy) are its ADR domain's default, so it lights the deploy column
  ([ADR-DSGN-TRACK-VALUECHAINCONCERN][3]).
- [ADR-AZ-DATAMOD][2]: selected by [ADR-AZ-DATAMOD][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][3]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it
  lights the deploy column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][3]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [ADR-AZ-DATAMOD][2]: selected by [ADR-AZ-DATAMOD][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][3]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it
  lights the access column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][3]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

[1]: ../../../../adr/azure/azure-customer-model.md
[2]: ../../../../adr/azure/azure-data-model.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../coordinate-rules-and-their-gates.md
[5]: ../../../../adr/glossary.md#value-chain-map
[6]: ../../../../adr/glossary.md#value-chain-stack
[7]: ../../../../adr/glossary.md#value-chain-concern
[8]: ../../../../adr/glossary.md#cell
[9]: ../../../../adr/glossary.md#lit-cell
