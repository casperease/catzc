# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md

`Value-chain minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Value-chain minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.png)

The value-chain minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide
supports [ADR-DSGN-TRACK][1], [ADR-FLOW-CD-GLOBS][2] and [ADR-REPO-FOLDERS][3]; the highlight of those ADR codes selects what is lit, and
each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 2 cells, filled in ink.
Every other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of
the 30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain
map.

- DSGN × automation: 2 lit of 7 ADRs
- AUTO × automation: 1 lit of 64 ADRs

## Key

Rows are the value-chain stack and columns the value-chain concerns, each printed as a capital code:

- `PRIN`: the PRIN row of the value-chain stack
- `DSGN`: the DSGN row of the value-chain stack
- `AUTO`: the AUTO row of the value-chain stack
- `PIPE`: the PIPE row of the value-chain stack
- `CLOUD`: the CLOUD row of the value-chain stack
- `AUTOMA`: automation
- `BUILD`: build
- `QC`: quality-control
- `RELEAS`: release
- `DEPLOY`: deploy
- `ACCESS`: access

## Why each cell is lit

### DSGN × automation (2 ADRs)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-DSGN-TRACK][1]: selected by [ADR-DSGN-TRACK][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][6]).
- [ADR-FLOW-CD-GLOBS][2]: selected by [ADR-FLOW-CD-GLOBS][2]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (automation) override its ADR domain's default (build, quality-control, release and
  deploy), so it lights the automation column ([ADR-DSGN-TRACK#15][6]).

### AUTO × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-REPO-FOLDERS][3]: selected by [ADR-REPO-FOLDERS][3]; its ADR domain `repository` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][6]).

## Keywords

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

Terms the cited ADRs define:

- [cell][10], defined by [ADR-DSGN-TRACK#10][12]
- [deployable-unit][13], defined by [ADR-DSGN-TRACK#5][14]
- [domain][15], defined by [ADR-REPO-FOLDERS#5][16]
- [file language][17], defined by [ADR-DSGN-TRACK#6][18]
- [lit cell][11], defined by [ADR-DSGN-TRACK#12][4]
- [root file][19], defined by [ADR-DSGN-TRACK#7][20]
- [stack violation][21], defined by [ADR-DSGN-TRACK#11][22]
- [track][23], defined by [ADR-DSGN-TRACK#1][24]
- [unlisted file][25], defined by [ADR-DSGN-TRACK#8][26]
- [value-chain concern][9], defined by [ADR-DSGN-TRACK#15][6]
- [value-chain map][7], defined by [ADR-DSGN-TRACK#16][27]
- [value-chain stack][8], defined by [ADR-DSGN-TRACK#14][5]
- [verification track][28], defined by [ADR-DSGN-TRACK#2][29]
- [world map][30], defined by [ADR-DSGN-TRACK#9][31]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/repository/conventional-folders.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[7]: ../../adr/glossary.md#value-chain-map
[8]: ../../adr/glossary.md#value-chain-stack
[9]: ../../adr/glossary.md#value-chain-concern
[10]: ../../adr/glossary.md#cell
[11]: ../../adr/glossary.md#lit-cell
[12]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[13]: ../../adr/glossary.md#deployable-unit
[14]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[15]: ../../adr/glossary.md#domain
[16]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[17]: ../../adr/glossary.md#file-language
[18]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[19]: ../../adr/glossary.md#root-file
[20]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[21]: ../../adr/glossary.md#stack-violation
[22]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[23]: ../../adr/glossary.md#track
[24]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[25]: ../../adr/glossary.md#unlisted-file
[26]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[27]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[28]: ../../adr/glossary.md#verification-track
[29]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[30]: ../../adr/glossary.md#world-map
[31]: ../../adr/design/tracks.md#rule-adr-dsgn-track9
