# docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md

`Value-chain minimap: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance`

![Value-chain minimap of adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance](adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.png)

The value-chain minimap of the slide `adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance` (governance lens). The slide
supports [ADR-AUTO-TEST][1], [ADR-FLOW-CD-GLOBS][2], [ADR-PRIN-ONELIVE][3] and [ADR-REPO-PROTGLOB][4]; the highlight of those ADR codes
selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access) and lights 4 cells, filled in ink.
Every other cell is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (7 of
the 30 cells hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain
map.

- PRIN × release: 1 lit of 32 ADRs
- DSGN × automation: 1 lit of 7 ADRs
- AUTO × automation: 1 lit of 63 ADRs
- AUTO × quality-control: 1 lit of 10 ADRs

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

### PRIN × release (1 ADR)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-PRIN-ONELIVE][3]: selected by [ADR-PRIN-ONELIVE][3]; its ADR domain `principles` sits on the PRIN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (release) override its ADR domain's default (automation, build, quality-control,
  release, deploy and access), so it lights the release column ([ADR-DSGN-TRACK#15][7]).

### DSGN × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-FLOW-CD-GLOBS][2]: selected by [ADR-FLOW-CD-GLOBS][2]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (automation) override its ADR domain's default (build, quality-control, release and
  deploy), so it lights the automation column ([ADR-DSGN-TRACK#15][7]).

### AUTO × automation (1 ADR)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-REPO-PROTGLOB][4]: selected by [ADR-REPO-PROTGLOB][4]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its value-chain concerns (automation) are its ADR domain's default, so it lights the automation column
  ([ADR-DSGN-TRACK#15][7]).

### AUTO × quality-control (1 ADR)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-AUTO-TEST][1]: selected by [ADR-AUTO-TEST][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control) override its ADR domain's default (automation), so it lights the
  quality-control column ([ADR-DSGN-TRACK#15][7]).

## Keywords

- [value-chain map][8]
- [value-chain stack][9]
- [value-chain concern][10]
- [cell][11]
- [lit cell][12]

Terms the cited ADRs define:

- [all tests][13], defined by [ADR-AUTO-TEST#36][14]
- [build verification test][15], defined by [ADR-AUTO-TEST#24][16]
- [category][17], defined by [ADR-AUTO-TEST#1][18]
- [phase][19], defined by [ADR-AUTO-TEST#26][20]
- [quality gate][21], defined by [ADR-AUTO-TEST#35][22]
- [test][23], defined by [ADR-AUTO-TEST#42][24]
- [test file][25], defined by [ADR-AUTO-TEST#43][26]
- [test run][27], defined by [ADR-AUTO-TEST#34][28]
- [test suite][29], defined by [ADR-AUTO-TEST#37][30]
- [testing in production][31], defined by [ADR-AUTO-TEST#41][32]
- [tier][33], defined by [ADR-AUTO-TEST#13][34]
- [vertical test][35], defined by [ADR-AUTO-TEST#38][36]

[1]: ../../adr/automation/test-automation.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/principles/one-living-version.md
[4]: ../../adr/repository/protected-globs.md
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[7]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[8]: ../../adr/glossary.md#value-chain-map
[9]: ../../adr/glossary.md#value-chain-stack
[10]: ../../adr/glossary.md#value-chain-concern
[11]: ../../adr/glossary.md#cell
[12]: ../../adr/glossary.md#lit-cell
[13]: ../../adr/glossary.md#all-tests
[14]: ../../adr/automation/test-automation.md#rule-adr-auto-test36
[15]: ../../adr/glossary.md#build-verification-test
[16]: ../../adr/automation/test-automation.md#rule-adr-auto-test24
[17]: ../../adr/glossary.md#category
[18]: ../../adr/automation/test-automation.md#rule-adr-auto-test1
[19]: ../../adr/glossary.md#phase
[20]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[21]: ../../adr/glossary.md#quality-gate
[22]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[23]: ../../adr/glossary.md#test
[24]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[25]: ../../adr/glossary.md#test-file
[26]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[27]: ../../adr/glossary.md#test-run
[28]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[29]: ../../adr/glossary.md#test-suite
[30]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[31]: ../../adr/glossary.md#testing-in-production
[32]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[33]: ../../adr/glossary.md#tier
[34]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[35]: ../../adr/glossary.md#vertical-test
[36]: ../../adr/automation/test-automation.md#rule-adr-auto-test38
