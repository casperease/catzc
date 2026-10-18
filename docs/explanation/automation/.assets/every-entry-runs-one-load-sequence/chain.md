---
catzc:
  immutable:
    with_body_sha: d038daa6a28c
    repo_status: locked
    path: docs/explanation/automation/.assets/every-entry-runs-one-load-sequence/chain.md
    source: docs/explanation/automation/.assets/every-entry-runs-one-load-sequence/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every entry runs one load sequence: the value-chain minimap

```text
Where ADR-AUTO-BUNDLE sits in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of Every entry runs one load sequence](chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [Every entry runs one load sequence][3], which explains
[ADR-AUTO-BUNDLE][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land, so it shows the part of
the value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 2 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × build: 1 lit of 6 ADRs
- AUTO × release: 1 lit of 4 ADRs

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

### AUTO × build (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so
  it lights the build column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

### AUTO × release (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [ADR-AUTO-BUNDLE][1]: selected by [ADR-AUTO-BUNDLE][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][2]); its own value-chain concerns (build and release) override its ADR domain's default (automation), so
  it lights the release column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][2]).

## Keywords

- [value-chain map][4]
- [value-chain stack][5]
- [value-chain concern][6]
- [cell][7]
- [lit cell][8]

[1]: ../../../../adr/automation/platform-bundle.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../every-entry-runs-one-load-sequence.md
[4]: ../../../../adr/glossary.md#value-chain-map
[5]: ../../../../adr/glossary.md#value-chain-stack
[6]: ../../../../adr/glossary.md#value-chain-concern
[7]: ../../../../adr/glossary.md#cell
[8]: ../../../../adr/glossary.md#lit-cell
