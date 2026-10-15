# docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md

`Value-chain minimap: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations`

![Value-chain minimap of adr-dsgn-track--a-push-fires-only-touched-pipelines--operations](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.png)

The value-chain minimap of the slide `adr-dsgn-track--a-push-fires-only-touched-pipelines--operations` (operations lens). The slide supports
[ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every
other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of the
30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- DSGN × automation: 1 lit of 7 ADRs

## Key

Rows are the value-chain stack and columns the value-chain concerns, each printed as a capital code:

- `PRIN`: the PRIN row of the value-chain stack
- `DSGN`: the DSGN row of the value-chain stack
- `AUTO`: the AUTO row of the value-chain stack
- `PIPE`: the PIPE row of the value-chain stack
- `CLOUD`: the CLOUD row of the value-chain stack
- `LOCAL`: the LOCAL row of the value-chain stack
- `BUILD`: build
- `QC`: quality-control
- `RELEASE`: release
- `DEPLOY`: deploy
- `ACCESS`: access

## Why each cell is lit

### DSGN × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-DSGN-TRACK][1]: selected by [ADR-DSGN-TRACK][1]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][4]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

Terms the cited ADRs define:

- [cell][8], defined by [ADR-DSGN-TRACK#10][10]
- [deployable-unit][11], defined by [ADR-DSGN-TRACK#5][12]
- [file language][13], defined by [ADR-DSGN-TRACK#6][14]
- [lit cell][9], defined by [ADR-DSGN-TRACK#12][2]
- [root file][15], defined by [ADR-DSGN-TRACK#7][16]
- [stack violation][17], defined by [ADR-DSGN-TRACK#11][18]
- [track][19], defined by [ADR-DSGN-TRACK#1][20]
- [unlisted file][21], defined by [ADR-DSGN-TRACK#8][22]
- [value-chain concern][7], defined by [ADR-DSGN-TRACK#15][4]
- [value-chain map][5], defined by [ADR-DSGN-TRACK#16][23]
- [value-chain stack][6], defined by [ADR-DSGN-TRACK#14][3]
- [verification track][24], defined by [ADR-DSGN-TRACK#2][25]
- [world map][26], defined by [ADR-DSGN-TRACK#9][27]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../adr/glossary.md#value-chain-map
[6]: ../../adr/glossary.md#value-chain-stack
[7]: ../../adr/glossary.md#value-chain-concern
[8]: ../../adr/glossary.md#cell
[9]: ../../adr/glossary.md#lit-cell
[10]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[11]: ../../adr/glossary.md#deployable-unit
[12]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[13]: ../../adr/glossary.md#file-language
[14]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[15]: ../../adr/glossary.md#root-file
[16]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[17]: ../../adr/glossary.md#stack-violation
[18]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[19]: ../../adr/glossary.md#track
[20]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[21]: ../../adr/glossary.md#unlisted-file
[22]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[23]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[24]: ../../adr/glossary.md#verification-track
[25]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[26]: ../../adr/glossary.md#world-map
[27]: ../../adr/design/tracks.md#rule-adr-dsgn-track9
