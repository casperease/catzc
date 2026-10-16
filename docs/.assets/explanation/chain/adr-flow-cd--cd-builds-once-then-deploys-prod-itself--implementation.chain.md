# docs/.assets/explanation/chain/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md

`Value-chain minimap: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation`

![Value-chain minimap of adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.png)

The value-chain minimap of the slide `adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation` (implementation lens). The slide
supports [ADR-FLOW-CD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 4 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- DSGN × build: 1 lit of 5 ADRs
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

### DSGN × build (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-FLOW-CD][1]: selected by [ADR-FLOW-CD][1]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the build column ([ADR-DSGN-TRACK#15][4]).

### DSGN × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-FLOW-CD][1]: selected by [ADR-FLOW-CD][1]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the quality-control column ([ADR-DSGN-TRACK#15][4]).

### DSGN × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-FLOW-CD][1]: selected by [ADR-FLOW-CD][1]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the release column ([ADR-DSGN-TRACK#15][4]).

### DSGN × deploy (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-FLOW-CD][1]: selected by [ADR-FLOW-CD][1]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the deploy column ([ADR-DSGN-TRACK#15][4]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

Terms the cited ADRs define:

- [gate][10], defined by [ADR-FLOW-CD#13][11]
- [release candidate][12], defined by [ADR-FLOW-CD#14][13]

[1]: ../../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../../adr/glossary.md#value-chain-map
[6]: ../../../adr/glossary.md#value-chain-stack
[7]: ../../../adr/glossary.md#value-chain-concern
[8]: ../../../adr/glossary.md#cell
[9]: ../../../adr/glossary.md#lit-cell
[10]: ../../../adr/glossary.md#gate
[11]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[12]: ../../../adr/glossary.md#release-candidate
[13]: ../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
