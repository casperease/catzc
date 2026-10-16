# docs/.assets/explanation/chain/adr-auto-path--one-out-string-two-places--operations.chain.md

`Value-chain minimap: adr-auto-path--one-out-string-two-places--operations`

![Value-chain minimap of adr-auto-path--one-out-string-two-places--operations](adr-auto-path--one-out-string-two-places--operations.chain.png)

The value-chain minimap of the slide `adr-auto-path--one-out-string-two-places--operations` (operations lens). The slide supports
[ADR-AUTO-PATH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

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

- [published artifact][7], defined by [ADR-AUTO-PATH#10][8]

[1]: ../../../adr/automation/path-representation.md
[2]: ../../../adr/glossary.md#value-chain-map
[3]: ../../../adr/glossary.md#value-chain-stack
[4]: ../../../adr/glossary.md#value-chain-concern
[5]: ../../../adr/glossary.md#cell
[6]: ../../../adr/glossary.md#lit-cell
[7]: ../../../adr/glossary.md#published-artifact
[8]: ../../../adr/automation/path-representation.md#rule-adr-auto-path10
