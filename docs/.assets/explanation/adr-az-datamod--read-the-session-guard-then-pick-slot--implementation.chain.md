# docs/.assets/explanation/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.chain.md

`Value-chain minimap: adr-az-datamod--read-the-session-guard-then-pick-slot--implementation`

![Value-chain minimap of adr-az-datamod--read-the-session-guard-then-pick-slot--implementation](adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.chain.png)

The value-chain minimap of the slide `adr-az-datamod--read-the-session-guard-then-pick-slot--implementation` (implementation lens). The
slide supports [ADR-AZ-DATAMOD][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects
it.

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

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  deploy column ([ADR-DSGN-TRACK#15][4]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  access column ([ADR-DSGN-TRACK#15][4]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

Terms the cited ADRs define:

- [environment class][10], defined by [ADR-AZ-DATAMOD#11][11]
- [slot][12], defined by [ADR-AZ-DATAMOD#2][13]

[1]: ../../adr/azure/azure-data-model.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../adr/glossary.md#value-chain-map
[6]: ../../adr/glossary.md#value-chain-stack
[7]: ../../adr/glossary.md#value-chain-concern
[8]: ../../adr/glossary.md#cell
[9]: ../../adr/glossary.md#lit-cell
[10]: ../../adr/glossary.md#environment-class
[11]: ../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[12]: ../../adr/glossary.md#slot
[13]: ../../adr/azure/azure-data-model.md#rule-adr-az-datamod2
