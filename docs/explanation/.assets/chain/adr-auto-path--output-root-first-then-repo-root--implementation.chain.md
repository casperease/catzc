---
catzc:
  immutable:
    with_body_sha: b7df48a20809
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-auto-path--output-root-first-then-repo-root--implementation.chain.md
    source: docs/explanation/.assets/adr-auto-path--output-root-first-then-repo-root--implementation.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Output root first, then repository root, else absolute, and out/ re-anchors on the output root: the value-chain minimap

```text
Where ADR-AUTO-PATH sits in the value chain: value-chain stack down, value-chain concerns across.
No cell is lit: the cited ADRs land only in the automation concern, which the AUTO row already names.
```

![The value-chain minimap of Output root first, then repository root, else absolute, and out/ re-anchors on the output root](adr-auto-path--output-root-first-then-repo-root--implementation.chain.png)

This is the value-chain minimap in the sidebar of the implementation diagram of [Output root first, then repository root, else absolute, and
out/ re-anchors on the output root][2], which explains [ADR-AUTO-PATH][1]. It lights the cells of the value-chain map where the cited ADRs'
value-chain concerns land, so it shows the part of the value chain the decision governs. Nothing is lit, so no reason follows.

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

Terms the cited ADRs define:

- [published artifact][8], defined by [ADR-AUTO-PATH#10][9]

[1]: ../../../adr/automation/path-representation.md
[2]: ../../automation/output-root-first-then-repo-root.md
[3]: ../../../adr/glossary.md#value-chain-map
[4]: ../../../adr/glossary.md#value-chain-stack
[5]: ../../../adr/glossary.md#value-chain-concern
[6]: ../../../adr/glossary.md#cell
[7]: ../../../adr/glossary.md#lit-cell
[8]: ../../../adr/glossary.md#published-artifact
[9]: ../../../adr/automation/path-representation.md#rule-adr-auto-path10
