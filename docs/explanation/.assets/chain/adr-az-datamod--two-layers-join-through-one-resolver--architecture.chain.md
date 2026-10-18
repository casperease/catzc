---
catzc:
  immutable:
    with_body_sha: e52fe47cd0c5
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-az-datamod--two-layers-join-through-one-resolver--architecture.chain.md
    source: docs/explanation/.assets/adr-az-datamod--two-layers-join-through-one-resolver--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Templating and identity join through one shared check and one resolver: the value-chain minimap

```text
Where ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD sit in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of Templating and identity join through one shared check and one resolver](adr-az-datamod--two-layers-join-through-one-resolver--architecture.chain.png)

This is the value-chain minimap in the sidebar of the architecture diagram of [Templating and identity join through one shared check and one
resolver][6], which explains [ADR-AZ-CUSTOMER][1] and [ADR-AZ-DATAMOD][2]. It lights the cells of the value-chain map where the cited ADRs'
value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code
that selects it.

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

- [ADR-AZ-CUSTOMER][1]: selected by [ADR-AZ-CUSTOMER][1]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its value-chain concerns (deploy) are its ADR domain's default, so it lights the deploy column
  ([ADR-DSGN-TRACK#15][5]).
- [ADR-AZ-DATAMOD][2]: selected by [ADR-AZ-DATAMOD][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  deploy column ([ADR-DSGN-TRACK#15][5]).

### CLOUD × access (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AZ-DATAMOD][2]: selected by [ADR-AZ-DATAMOD][2]; its ADR domain `azure` sits on the CLOUD row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (deploy and access) override its ADR domain's default (deploy), so it lights the
  access column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

Terms the cited ADRs define:

- [environment class][12], defined by [ADR-AZ-DATAMOD#11][13]
- [slot][14], defined by [ADR-AZ-DATAMOD#2][15]

[1]: ../../../adr/azure/azure-customer-model.md
[2]: ../../../adr/azure/azure-data-model.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../azure/two-layers-join-through-one-resolver.md
[7]: ../../../adr/glossary.md#value-chain-map
[8]: ../../../adr/glossary.md#value-chain-stack
[9]: ../../../adr/glossary.md#value-chain-concern
[10]: ../../../adr/glossary.md#cell
[11]: ../../../adr/glossary.md#lit-cell
[12]: ../../../adr/glossary.md#environment-class
[13]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod11
[14]: ../../../adr/glossary.md#slot
[15]: ../../../adr/azure/azure-data-model.md#rule-adr-az-datamod2
