---
catzc:
  immutable:
    with_body_sha: eb27ec91fa16
    repo_status: locked
    path: docs/explanation/design/.assets/which-rung-gates-exist-in-code/chain.md
    source: docs/explanation/design/.assets/which-rung-gates-exist-in-code/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only PR build validation, the BVT and the failure stop are checked in code: the value-chain minimap

```text
Where ADR-DSGN-LIFE sits in the value chain: value-chain stack down, value-chain concerns across.
3 of 25 cells lit.
```

![The value-chain minimap of Only PR build validation, the BVT and the failure stop are checked in code](chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [Only PR build validation, the BVT and the failure stop are
checked in code][5], which explains [ADR-DSGN-LIFE][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain
concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code that
selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 3 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- DSGN × quality-control: 1 lit of 5 ADRs
- DSGN × release: 1 lit of 4 ADRs
- DSGN × deploy: 1 lit of 6 ADRs

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

### DSGN × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK#15][4]).

### DSGN × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the release column ([ADR-DSGN-TRACK#15][4]).

### DSGN × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the deploy column ([ADR-DSGN-TRACK#15][4]).

## Keywords

- [value-chain map][6]
- [value-chain stack][7]
- [value-chain concern][8]
- [cell][9]
- [lit cell][10]

Terms the cited ADRs define:

- [occupant][11], defined by [ADR-DSGN-LIFE#5][12]
- [staging slot][13], defined by [ADR-DSGN-LIFE#5][12]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../which-rung-gates-exist-in-code.md
[6]: ../../../../adr/glossary.md#value-chain-map
[7]: ../../../../adr/glossary.md#value-chain-stack
[8]: ../../../../adr/glossary.md#value-chain-concern
[9]: ../../../../adr/glossary.md#cell
[10]: ../../../../adr/glossary.md#lit-cell
[11]: ../../../../adr/glossary.md#occupant
[12]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[13]: ../../../../adr/glossary.md#staging-slot
