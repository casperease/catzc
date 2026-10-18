---
catzc:
  immutable:
    with_body_sha: "9d0f5deecfbf"
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.chain.md
    source: docs/explanation/.assets/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A sibling is an idea, never a reference: the value-chain minimap

```text
Where ADR-AUTO-GO and ADR-PRIN-ONELIVE sit in the value chain: value-chain stack down, value-chain concerns across.
2 of 25 cells lit.
```

![The value-chain minimap of A sibling is an idea, never a reference](chain.png)

This is the value-chain minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][6], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights the cells of the value-chain map where the cited ADRs' value-chain concerns land, so
it shows the part of the value chain the decision governs. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 2 cells, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- PRIN × release: 1 lit of 33 ADRs
- AUTO × quality-control: 1 lit of 17 ADRs

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

### PRIN × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-PRIN-ONELIVE][2]: selected by [ADR-PRIN-ONELIVE][2]; its ADR domain `principles` sits on the PRIN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (release) override its ADR domain's default (automation, build, quality-control,
  release, deploy and access), so it lights the release column ([ADR-DSGN-TRACK#15][5]).

### AUTO × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AUTO-GO][1]: selected by [ADR-AUTO-GO][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control) override its ADR domain's default (automation), so it lights the
  quality-control column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

Terms the cited ADRs define:

- [go test module][12], defined by [ADR-AUTO-GO#2][13]

[1]: ../../../../adr/automation/go/go-test-artifacts.md
[2]: ../../../../adr/principles/one-living-version.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../a-sibling-is-an-idea-never-a-reference.md
[7]: ../../../../adr/glossary.md#value-chain-map
[8]: ../../../../adr/glossary.md#value-chain-stack
[9]: ../../../../adr/glossary.md#value-chain-concern
[10]: ../../../../adr/glossary.md#cell
[11]: ../../../../adr/glossary.md#lit-cell
[12]: ../../../../adr/glossary.md#go-test-module
[13]: ../../../../adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2
