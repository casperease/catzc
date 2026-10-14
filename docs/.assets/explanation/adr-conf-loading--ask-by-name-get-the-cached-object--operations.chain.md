# docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md

`Value-chain minimap: adr-conf-loading--ask-by-name-get-the-cached-object--operations`

![Value-chain minimap of adr-conf-loading--ask-by-name-get-the-cached-object--operations](adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.png)

The value-chain minimap of the slide `adr-conf-loading--ask-by-name-get-the-cached-object--operations` (operations lens). The slide supports
[ADR-CONF-LOADING][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every
other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of the
30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × automation: 1 lit of 63 ADRs

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

### AUTO × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][2]) by:

- [ADR-CONF-LOADING][1]: selected by [ADR-CONF-LOADING][1]; its ADR domain `configuration` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][3]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][4]).

## Keywords

- [value-chain map][5]
- [value-chain stack][6]
- [value-chain concern][7]
- [cell][8]
- [lit cell][9]

[1]: ../../adr/configuration/module-config-loading.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[5]: ../../adr/glossary.md#value-chain-map
[6]: ../../adr/glossary.md#value-chain-stack
[7]: ../../adr/glossary.md#value-chain-concern
[8]: ../../adr/glossary.md#cell
[9]: ../../adr/glossary.md#lit-cell
