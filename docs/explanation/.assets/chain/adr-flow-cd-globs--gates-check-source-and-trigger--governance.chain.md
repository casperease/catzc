# docs/explanation/.assets/chain/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md

`Value-chain minimap: adr-flow-cd-globs--gates-check-source-and-trigger--governance`

![Value-chain minimap of adr-flow-cd-globs--gates-check-source-and-trigger--governance](adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.png)

The value-chain minimap of the slide `adr-flow-cd-globs--gates-check-source-and-trigger--governance` (governance lens). The slide supports
[ADR-AUTO-TEST][1] and [ADR-FLOW-CD-GLOBS][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × quality-control: 1 lit of 15 ADRs

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

### AUTO × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK#12][3]) by:

- [ADR-AUTO-TEST][1]: selected by [ADR-AUTO-TEST][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][4]); its own value-chain concerns (quality-control) override its ADR domain's default (automation), so it lights the
  quality-control column ([ADR-DSGN-TRACK#15][5]).

## Keywords

- [value-chain map][6]
- [value-chain stack][7]
- [value-chain concern][8]
- [cell][9]
- [lit cell][10]

Terms the cited ADRs define:

- [all tests][11], defined by [ADR-AUTO-TEST#36][12]
- [build verification test][13], defined by [ADR-AUTO-TEST#24][14]
- [category][15], defined by [ADR-AUTO-TEST#1][16]
- [phase][17], defined by [ADR-AUTO-TEST#26][18]
- [quality gate][19], defined by [ADR-AUTO-TEST#35][20]
- [test][21], defined by [ADR-AUTO-TEST#42][22]
- [test file][23], defined by [ADR-AUTO-TEST#43][24]
- [test run][25], defined by [ADR-AUTO-TEST#34][26]
- [test suite][27], defined by [ADR-AUTO-TEST#37][28]
- [testing in production][29], defined by [ADR-AUTO-TEST#41][30]
- [tier][31], defined by [ADR-AUTO-TEST#13][32]
- [vertical test][33], defined by [ADR-AUTO-TEST#38][34]

[1]: ../../../adr/automation/test-automation.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../../adr/glossary.md#value-chain-map
[7]: ../../../adr/glossary.md#value-chain-stack
[8]: ../../../adr/glossary.md#value-chain-concern
[9]: ../../../adr/glossary.md#cell
[10]: ../../../adr/glossary.md#lit-cell
[11]: ../../../adr/glossary.md#all-tests
[12]: ../../../adr/automation/test-automation.md#rule-adr-auto-test36
[13]: ../../../adr/glossary.md#build-verification-test
[14]: ../../../adr/automation/test-automation.md#rule-adr-auto-test24
[15]: ../../../adr/glossary.md#category
[16]: ../../../adr/automation/test-automation.md#rule-adr-auto-test1
[17]: ../../../adr/glossary.md#phase
[18]: ../../../adr/automation/test-automation.md#rule-adr-auto-test26
[19]: ../../../adr/glossary.md#quality-gate
[20]: ../../../adr/automation/test-automation.md#rule-adr-auto-test35
[21]: ../../../adr/glossary.md#test
[22]: ../../../adr/automation/test-automation.md#rule-adr-auto-test42
[23]: ../../../adr/glossary.md#test-file
[24]: ../../../adr/automation/test-automation.md#rule-adr-auto-test43
[25]: ../../../adr/glossary.md#test-run
[26]: ../../../adr/automation/test-automation.md#rule-adr-auto-test34
[27]: ../../../adr/glossary.md#test-suite
[28]: ../../../adr/automation/test-automation.md#rule-adr-auto-test37
[29]: ../../../adr/glossary.md#testing-in-production
[30]: ../../../adr/automation/test-automation.md#rule-adr-auto-test41
[31]: ../../../adr/glossary.md#tier
[32]: ../../../adr/automation/test-automation.md#rule-adr-auto-test13
[33]: ../../../adr/glossary.md#vertical-test
[34]: ../../../adr/automation/test-automation.md#rule-adr-auto-test38
