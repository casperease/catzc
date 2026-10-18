---
catzc:
  immutable:
    with_body_sha: bd35fedf20e3
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
    source: docs/explanation/.assets/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Deploying a topic commit is not integrating it: the value-chain minimap

```text
Where ADR-DSGN-LIFE and ADR-DSGN-VISUAL sit in the value chain: value-chain stack down, value-chain concerns across.
3 of 25 cells lit.
```

![The value-chain minimap of Deploying a topic commit is not integrating it](chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [Deploying a topic commit is not integrating it][6], which explains
[ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land, so
it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 3 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- DSGN × quality-control: 2 lit of 5 ADRs
- DSGN × release: 2 lit of 4 ADRs
- DSGN × deploy: 2 lit of 6 ADRs

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

### DSGN × quality-control (2 ADRs)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK#15][5]).
- [ADR-DSGN-VISUAL][2]: selected by [ADR-DSGN-VISUAL][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK#15][5]).

### DSGN × release (2 ADRs)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the release column ([ADR-DSGN-TRACK#15][5]).
- [ADR-DSGN-VISUAL][2]: selected by [ADR-DSGN-VISUAL][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the release column ([ADR-DSGN-TRACK#15][5]).

### DSGN × deploy (2 ADRs)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-DSGN-LIFE][1]: selected by [ADR-DSGN-LIFE][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the deploy column ([ADR-DSGN-TRACK#15][5]).
- [ADR-DSGN-VISUAL][2]: selected by [ADR-DSGN-VISUAL][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the deploy column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

Terms the cited ADRs define:

- [occupant][12], defined by [ADR-DSGN-LIFE#5][13]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/visual-design.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../deploying-is-not-integrating.md
[7]: ../../../../adr/glossary.md#value-chain-map
[8]: ../../../../adr/glossary.md#value-chain-stack
[9]: ../../../../adr/glossary.md#value-chain-concern
[10]: ../../../../adr/glossary.md#cell
[11]: ../../../../adr/glossary.md#lit-cell
[12]: ../../../../adr/glossary.md#occupant
[13]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
