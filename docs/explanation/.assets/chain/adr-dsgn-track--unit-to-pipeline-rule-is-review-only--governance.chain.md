---
catzc:
  immutable:
    with_body_sha: faab3ce36bc3
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
    source: docs/explanation/.assets/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the value-chain minimap

```text
Where ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS sit in the value chain: value-chain stack down, value-chain concerns across.
No cell is lit: the cited ADRs land only in the automation concern, which the AUTO row already names.
```

![The value-chain minimap of Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [Tracks and deployable-units have a gate in code, but one unit
to one pipeline is held by review alone][4], which explains [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]. It lights
the cells of the value-chain map where the cited ADRs' value-chain concerns land, so it shows the part of the value chain the decision
governs. Nothing is lit, so no reason follows.

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

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

Terms the cited ADRs define:

- [cell][8], defined by [ADR-DSGN-TRACK#10][10]
- [deployable-unit][11], defined by [ADR-DSGN-TRACK#5][12]
- [domain][13], defined by [ADR-REPO-FOLDERS#5][14]
- [file language][15], defined by [ADR-DSGN-TRACK#6][16]
- [import][17], defined by [ADR-DSGN-TRACK#17][18]
- [landing address][19], defined by [ADR-DSGN-TRACK#17][18]
- [lit cell][9], defined by [ADR-DSGN-TRACK#12][20]
- [place][21], defined by [ADR-DSGN-TRACK#1][22]
- [root file][23], defined by [ADR-DSGN-TRACK#7][24]
- [sorting][25], defined by [ADR-DSGN-TRACK#17][18]
- [stack violation][26], defined by [ADR-DSGN-TRACK#11][27]
- [track][28], defined by [ADR-DSGN-TRACK#1][22]
- [unlisted file][29], defined by [ADR-DSGN-TRACK#8][30]
- [unordered track][31], defined by [ADR-DSGN-TRACK#17][18]
- [value-chain concern][7], defined by [ADR-DSGN-TRACK#15][32]
- [value-chain map][5], defined by [ADR-DSGN-TRACK#16][33]
- [value-chain stack][6], defined by [ADR-DSGN-TRACK#14][34]
- [verification track][35], defined by [ADR-DSGN-TRACK#2][36]
- [world map][37], defined by [ADR-DSGN-TRACK#9][38]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../design/unit-to-pipeline-rule-is-review-only.md
[5]: ../../../adr/glossary.md#value-chain-map
[6]: ../../../adr/glossary.md#value-chain-stack
[7]: ../../../adr/glossary.md#value-chain-concern
[8]: ../../../adr/glossary.md#cell
[9]: ../../../adr/glossary.md#lit-cell
[10]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[11]: ../../../adr/glossary.md#deployable-unit
[12]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[13]: ../../../adr/glossary.md#domain
[14]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[15]: ../../../adr/glossary.md#file-language
[16]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[17]: ../../../adr/glossary.md#import
[18]: ../../../adr/design/tracks.md#rule-adr-dsgn-track17
[19]: ../../../adr/glossary.md#landing-address
[20]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[21]: ../../../adr/glossary.md#place
[22]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[23]: ../../../adr/glossary.md#root-file
[24]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[25]: ../../../adr/glossary.md#sorting
[26]: ../../../adr/glossary.md#stack-violation
[27]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[28]: ../../../adr/glossary.md#track
[29]: ../../../adr/glossary.md#unlisted-file
[30]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[31]: ../../../adr/glossary.md#unordered-track
[32]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[33]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[34]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[35]: ../../../adr/glossary.md#verification-track
[36]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[37]: ../../../adr/glossary.md#world-map
[38]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9
