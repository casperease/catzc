---
catzc:
  immutable:
    with_body_sha: "26a5393644dd"
    repo_status: locked
    path: docs/explanation/design/.assets/one-door-in-one-stable-point-out/chain.md
    source: docs/explanation/design/.assets/one-door-in-one-stable-point-out/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Changes enter through one door, and consumers build on one stable point: the value-chain minimap

```text
Where ADR-DSGN-REMOTE sits in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of Changes enter through one door, and consumers build on one stable point](chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [Changes enter through one door, and consumers build on one stable
point][3], which explains [ADR-DSGN-REMOTE][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land,
so it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 2 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- DSGN × build: 1 lit of 5 ADRs
- DSGN × quality-control: 1 lit of 5 ADRs

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

### DSGN × build (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-DSGN-REMOTE][1]: selected by [ADR-DSGN-REMOTE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (build and quality-control) override its ADR domain's default
  (automation), so it lights the build column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

### DSGN × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-DSGN-REMOTE][1]: selected by [ADR-DSGN-REMOTE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (build and quality-control) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

## Keywords

- [value-chain map][4]
- [value-chain stack][5]
- [value-chain concern][6]
- [cell][7]
- [lit cell][8]

[1]: ../../../../adr/design/server-remote-integration.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../one-door-in-one-stable-point-out.md
[4]: ../../../../adr/glossary.md#value-chain-map
[5]: ../../../../adr/glossary.md#value-chain-stack
[6]: ../../../../adr/glossary.md#value-chain-concern
[7]: ../../../../adr/glossary.md#cell
[8]: ../../../../adr/glossary.md#lit-cell
