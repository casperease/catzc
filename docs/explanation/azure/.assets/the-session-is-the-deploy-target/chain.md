---
catzc:
  immutable:
    with_body_sha: c0b3d3445192
    repo_status: locked
    path: docs/explanation/azure/.assets/the-session-is-the-deploy-target/chain.md
    source: docs/explanation/azure/.assets/the-session-is-the-deploy-target/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# The az session is the deploy target, and the guard only checks it: the value-chain minimap

```text
Where ADR-AZ-DATAMOD sits in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of The az session is the deploy target, and the guard only checks it](chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [The az session is the deploy target, and the guard only checks
it][3], which explains [ADR-AZ-DATAMOD][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land, so
it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 2 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- CLOUD × deploy: 1 lit of 23 ADRs
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

### CLOUD × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it
  lights the deploy column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it
  lights the access column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

## Keywords

- [value-chain map][4]
- [value-chain stack][5]
- [value-chain concern][6]
- [cell][7]
- [lit cell][8]

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../the-session-is-the-deploy-target.md
[4]: ../../../../adr/glossary.md#value-chain-map
[5]: ../../../../adr/glossary.md#value-chain-stack
[6]: ../../../../adr/glossary.md#value-chain-concern
[7]: ../../../../adr/glossary.md#cell
[8]: ../../../../adr/glossary.md#lit-cell
