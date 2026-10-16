# docs/.assets/explanation/chain/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md

`Value-chain minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Value-chain minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.png)

The value-chain minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide
supports [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]; the highlight of those ADR codes selects what is lit, and
each reason below names the code that selects it.

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

## Why each cell is lit

## Keywords

- [value-chain map][4]
- [value-chain stack][5]
- [value-chain concern][6]
- [cell][7]
- [lit cell][8]

Terms the cited ADRs define:

- [cell][7], defined by [ADR-DSGN-TRACK#10][9]
- [deployable-unit][10], defined by [ADR-DSGN-TRACK#5][11]
- [domain][12], defined by [ADR-REPO-FOLDERS#5][13]
- [file language][14], defined by [ADR-DSGN-TRACK#6][15]
- [lit cell][8], defined by [ADR-DSGN-TRACK#12][16]
- [place][17], defined by [ADR-DSGN-TRACK#1][18]
- [root file][19], defined by [ADR-DSGN-TRACK#7][20]
- [stack violation][21], defined by [ADR-DSGN-TRACK#11][22]
- [track][23], defined by [ADR-DSGN-TRACK#1][18]
- [unlisted file][24], defined by [ADR-DSGN-TRACK#8][25]
- [value-chain concern][6], defined by [ADR-DSGN-TRACK#15][26]
- [value-chain map][4], defined by [ADR-DSGN-TRACK#16][27]
- [value-chain stack][5], defined by [ADR-DSGN-TRACK#14][28]
- [verification track][29], defined by [ADR-DSGN-TRACK#2][30]
- [world map][31], defined by [ADR-DSGN-TRACK#9][32]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/repository/conventional-folders.md
[4]: ../../../adr/glossary.md#value-chain-map
[5]: ../../../adr/glossary.md#value-chain-stack
[6]: ../../../adr/glossary.md#value-chain-concern
[7]: ../../../adr/glossary.md#cell
[8]: ../../../adr/glossary.md#lit-cell
[9]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[10]: ../../../adr/glossary.md#deployable-unit
[11]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[12]: ../../../adr/glossary.md#domain
[13]: ../../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[14]: ../../../adr/glossary.md#file-language
[15]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[16]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[17]: ../../../adr/glossary.md#place
[18]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[19]: ../../../adr/glossary.md#root-file
[20]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[21]: ../../../adr/glossary.md#stack-violation
[22]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[23]: ../../../adr/glossary.md#track
[24]: ../../../adr/glossary.md#unlisted-file
[25]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[26]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[27]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[28]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[29]: ../../../adr/glossary.md#verification-track
[30]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[31]: ../../../adr/glossary.md#world-map
[32]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9
