---
catzc:
  immutable:
    with_body_sha: "55551ab7b284"
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-auto-failfast--a-stopped-run-names-its-limit--operations.chain.md
    source: docs/explanation/.assets/adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A run past its limit stops with a message that names the limit and where to change it: the value-chain minimap

```text
Where ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST sit in the value chain: value-chain stack down, value-chain concerns across.
No cell is lit: the cited ADRs land only in the automation concern, which the AUTO row already names.
```

![The value-chain minimap of A run past its limit stops with a message that names the limit and where to change it](chain.png)

This is the value-chain minimap in the sidebar of the operations diagram of [A run past its limit stops with a message that names the limit
and where to change it][3], which explains [ADR-AUTO-DEFAULT][1] and [ADR-AUTO-FAILFAST][2]. It lights the cells of the value-chain map
where the cited ADRs' value-chain concerns land, so it shows the part of the value chain the decision governs. Nothing is lit, so no reason
follows.

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

- [value-chain map][4]
- [value-chain stack][5]
- [value-chain concern][6]
- [cell][7]
- [lit cell][8]

[1]: ../../../../adr/automation/sensible-defaults.md
[2]: ../../../../adr/automation/fail-fast-with-asserts.md
[3]: ../../a-stopped-run-names-its-limit.md
[4]: ../../../../adr/glossary.md#value-chain-map
[5]: ../../../../adr/glossary.md#value-chain-stack
[6]: ../../../../adr/glossary.md#value-chain-concern
[7]: ../../../../adr/glossary.md#cell
[8]: ../../../../adr/glossary.md#lit-cell
