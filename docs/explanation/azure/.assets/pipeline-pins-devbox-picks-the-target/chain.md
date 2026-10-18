---
catzc:
  immutable:
    with_body_sha: "55cf61c7ba12"
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.chain.md
    source: docs/explanation/.assets/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A pipeline pins the subscription it expects; a devbox picks the target with az account set: the value-chain minimap

```text
Where ADR-AZ-DATAMOD sits in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of A pipeline pins the subscription it expects; a devbox picks the target with az account set](chain.png)

This is the value-chain minimap in the sidebar of the operations diagram of [A pipeline pins the subscription it expects; a devbox picks the
target with az account set][5], which explains [ADR-AZ-DATAMOD][1]. It lights the cells of the value-chain map where the cited ADRs'
value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code
that selects it.

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

- [value-chain map][6]
- [value-chain stack][7]
- [value-chain concern][8]
- [cell][9]
- [lit cell][10]

Terms the cited ADRs define:

- [environment class][11], defined by [ADR-AZ-DATAMOD#11][12]
- [slot][13], defined by [ADR-AZ-DATAMOD#2][14]

[1]: ../../../../adr/azure/azure-data-model.md
[2]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../pipeline-pins-devbox-picks-the-target.md
[6]: ../../../../adr/glossary.md#value-chain-map
[7]: ../../../../adr/glossary.md#value-chain-stack
[8]: ../../../../adr/glossary.md#value-chain-concern
[9]: ../../../../adr/glossary.md#cell
[10]: ../../../../adr/glossary.md#lit-cell
[11]: ../../../../adr/glossary.md#environment-class
[12]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[13]: ../../../../adr/glossary.md#slot
[14]: ../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2
