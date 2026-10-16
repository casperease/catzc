# docs/.assets/explanation/adr-az-datamod--four-gates-hold-the-session-rule--governance.chain.md

`Value-chain minimap: adr-az-datamod--four-gates-hold-the-session-rule--governance`

![Value-chain minimap of adr-az-datamod--four-gates-hold-the-session-rule--governance](adr-az-datamod--four-gates-hold-the-session-rule--governance.chain.png)

The value-chain minimap of the slide `adr-az-datamod--four-gates-hold-the-session-rule--governance` (governance lens). The slide supports
[ADR-AZ-DATAMOD][1] and [ADR-AZ-NAMING][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

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

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  deploy column ([ADR-DSGN-TRACK#15][5]).
- [ADR-AZ-NAMING][2]: selected by [ADR-AZ-NAMING][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its value-chain concerns (deploy) are its ADR domain's default, so it lights the deploy column
  ([ADR-DSGN-TRACK#15][5]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AZ-DATAMOD][1]: selected by [ADR-AZ-DATAMOD][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  access column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][6]
- [value-chain stack][7]
- [value-chain concern][8]
- [cell][9]
- [lit cell][10]

Terms the cited ADRs define:

- [environment class][11], defined by [ADR-AZ-DATAMOD#11][12]
- [slot][13], defined by [ADR-AZ-DATAMOD#2][14]

[1]: ../../adr/azure/azure-data-model.md
[2]: ../../adr/azure/azure-naming-standard.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../adr/glossary.md#value-chain-map
[7]: ../../adr/glossary.md#value-chain-stack
[8]: ../../adr/glossary.md#value-chain-concern
[9]: ../../adr/glossary.md#cell
[10]: ../../adr/glossary.md#lit-cell
[11]: ../../adr/glossary.md#environment-class
[12]: ../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[13]: ../../adr/glossary.md#slot
[14]: ../../adr/azure/azure-data-model.md#rule-adr-az-datamod2
