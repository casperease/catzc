---
catzc:
  immutable:
    with_body_sha: "3260923bd251"
    repo_status: locked
    path: docs/explanation/flow/.assets/drift-is-gated-generation-is-adr-only/chain.md
    source: docs/explanation/flow/.assets/drift-is-gated-generation-is-adr-only/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Three gates check the projection, while generation is held by the ADR alone: the value-chain minimap

```text
Where ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS sit in the value chain: value-chain stack down, value-chain concerns across.
1 of 25 cells lit.
```

![The value-chain minimap of Three gates check the projection, while generation is held by the ADR alone](chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [Three gates check the projection, while generation is held by
the ADR alone][4], which explains [ADR-AUTO-TEST][1] and [ADR-FLOW-CD-GLOBS][2]. It lights the cells of the value-chain map where the cited
ADRs' value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming
the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × quality-control: 1 lit of 18 ADRs

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

### AUTO × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [ADR-AUTO-TEST][1]: selected by [ADR-AUTO-TEST][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK-VALUECHAINSTACK][3]); its own value-chain concerns (quality-control) override its ADR domain's default (automation), so
  it lights the quality-control column ([ADR-DSGN-TRACK-VALUECHAINCONCERN][3]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

[1]: ../../../../adr/automation/test-automation.md
[2]: ../../../../adr/flow/durable-sha-globs.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../drift-is-gated-generation-is-adr-only.md
[5]: ../../../../adr/glossary.md#value-chain-map
[6]: ../../../../adr/glossary.md#value-chain-stack
[7]: ../../../../adr/glossary.md#value-chain-concern
[8]: ../../../../adr/glossary.md#cell
[9]: ../../../../adr/glossary.md#lit-cell
