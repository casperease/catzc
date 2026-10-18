---
catzc:
  immutable:
    with_body_sha: "99e8778071a3"
    repo_status: locked
    path: docs/adr/azure/.assets/azure-name-assembly/chain.md
    source: docs/adr/azure/.assets/azure-name-assembly/diagram.drawio.png
    role: adr
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# ADR: Azure resource naming standard: the value-chain minimap

```text
Where ADR-AZ-NAMING sits in the value chain: value-chain stack down, value-chain concerns across.
1 of 25 cells lit.
```

![The value-chain minimap of ADR: Azure resource naming standard](chain.png)

This is the value-chain minimap in the sidebar of the implementation diagram of [ADR: Azure resource naming standard][1], which explains
[ADR-AZ-NAMING][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land, so it shows the part of the
value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- CLOUD × deploy: 1 lit of 23 ADRs

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

### CLOUD × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-AZ-NAMING][1]: selected by [ADR-AZ-NAMING][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its value-chain concerns (deploy) are its ADR domain's default, so it lights the deploy column
  ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

## Keywords

- [value-chain map][3]
- [value-chain stack][4]
- [value-chain concern][5]
- [cell][6]
- [lit cell][7]

[1]: ../../azure-naming-standard.md
[2]: ../../../design/tracks.md
[3]: ../../../glossary.md#value-chain-map
[4]: ../../../glossary.md#value-chain-stack
[5]: ../../../glossary.md#value-chain-concern
[6]: ../../../glossary.md#cell
[7]: ../../../glossary.md#lit-cell
