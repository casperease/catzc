---
catzc:
  immutable:
    with_body_sha: "9e2ba91940e2"
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
    source: docs/explanation/.assets/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Peers in a layer never share a file, except in the loose-fileset layer: the value-chain minimap

```text
Where ADR-FLOW-CD-GLOBS sits in the value chain: value-chain stack down, value-chain concerns across.
No cell is lit: the cited ADRs land only in the automation concern, which the AUTO row already names.
```

![The value-chain minimap of Peers in a layer never share a file, except in the loose-fileset layer](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [Peers in a layer never share a file, except in the loose-fileset
layer][2], which explains [ADR-FLOW-CD-GLOBS][1]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns
land, so it shows the part of the value chain the decision governs. Nothing is lit, so no reason follows.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 0 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

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

## Keywords

- [value-chain map][3]
- [value-chain stack][4]
- [value-chain concern][5]
- [cell][6]
- [lit cell][7]

[1]: ../../../adr/flow/durable-sha-globs.md
[2]: ../../flow/peers-in-a-layer-never-overlap.md
[3]: ../../../adr/glossary.md#value-chain-map
[4]: ../../../adr/glossary.md#value-chain-stack
[5]: ../../../adr/glossary.md#value-chain-concern
[6]: ../../../adr/glossary.md#cell
[7]: ../../../adr/glossary.md#lit-cell
