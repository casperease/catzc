# docs/explanation/.assets/chain/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md

`Value-chain minimap: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture`

![Value-chain minimap of adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.png)

The value-chain minimap of the slide `adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture` (architecture lens). The slide
supports [ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

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

- [value-chain map][2]
- [value-chain stack][3]
- [value-chain concern][4]
- [cell][5]
- [lit cell][6]

Terms the cited ADRs define:

- [cell][5], defined by [ADR-DSGN-TRACK#10][7]
- [deployable-unit][8], defined by [ADR-DSGN-TRACK#5][9]
- [file language][10], defined by [ADR-DSGN-TRACK#6][11]
- [lit cell][6], defined by [ADR-DSGN-TRACK#12][12]
- [place][13], defined by [ADR-DSGN-TRACK#1][14]
- [root file][15], defined by [ADR-DSGN-TRACK#7][16]
- [stack violation][17], defined by [ADR-DSGN-TRACK#11][18]
- [track][19], defined by [ADR-DSGN-TRACK#1][14]
- [unlisted file][20], defined by [ADR-DSGN-TRACK#8][21]
- [value-chain concern][4], defined by [ADR-DSGN-TRACK#15][22]
- [value-chain map][2], defined by [ADR-DSGN-TRACK#16][23]
- [value-chain stack][3], defined by [ADR-DSGN-TRACK#14][24]
- [verification track][25], defined by [ADR-DSGN-TRACK#2][26]
- [world map][27], defined by [ADR-DSGN-TRACK#9][28]

[1]: ../../../adr/design/tracks.md
[2]: ../../../adr/glossary.md#value-chain-map
[3]: ../../../adr/glossary.md#value-chain-stack
[4]: ../../../adr/glossary.md#value-chain-concern
[5]: ../../../adr/glossary.md#cell
[6]: ../../../adr/glossary.md#lit-cell
[7]: ../../../adr/design/tracks.md#rule-adr-dsgn-track10
[8]: ../../../adr/glossary.md#deployable-unit
[9]: ../../../adr/design/tracks.md#rule-adr-dsgn-track5
[10]: ../../../adr/glossary.md#file-language
[11]: ../../../adr/design/tracks.md#rule-adr-dsgn-track6
[12]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[13]: ../../../adr/glossary.md#place
[14]: ../../../adr/design/tracks.md#rule-adr-dsgn-track1
[15]: ../../../adr/glossary.md#root-file
[16]: ../../../adr/design/tracks.md#rule-adr-dsgn-track7
[17]: ../../../adr/glossary.md#stack-violation
[18]: ../../../adr/design/tracks.md#rule-adr-dsgn-track11
[19]: ../../../adr/glossary.md#track
[20]: ../../../adr/glossary.md#unlisted-file
[21]: ../../../adr/design/tracks.md#rule-adr-dsgn-track8
[22]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[23]: ../../../adr/design/tracks.md#rule-adr-dsgn-track16
[24]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[25]: ../../../adr/glossary.md#verification-track
[26]: ../../../adr/design/tracks.md#rule-adr-dsgn-track2
[27]: ../../../adr/glossary.md#world-map
[28]: ../../../adr/design/tracks.md#rule-adr-dsgn-track9
