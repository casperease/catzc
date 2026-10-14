# docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md

`Value-chain minimap: adr-dsgn-life--which-rung-gates-exist-in-code--governance`

![Value-chain minimap of adr-dsgn-life--which-rung-gates-exist-in-code--governance](adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.png)

The value-chain minimap of the slide `adr-dsgn-life--which-rung-gates-exist-in-code--governance` (governance lens). The slide supports
[ADR-AUTO-TEST][1], [ADR-DSGN-LIFE][2], [ADR-DSGN-VISUAL][3] and [ADR-FLOW-CD][4]; the highlight of those ADR codes selects what is lit, and
each reason below names the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 6 value-chain concerns (automation, build, quality-control, release, deploy, access), shades each cell by the ADRs it holds,
and lights 5 cells.

- DSGN × build: 1 lit of 5 ADRs
- DSGN × quality-control: 3 lit of 5 ADRs
- DSGN × release: 3 lit of 4 ADRs
- DSGN × deploy: 3 lit of 6 ADRs
- AUTO × quality-control: 1 lit of 10 ADRs

## Why each cell is lit

### DSGN × build (1 ADR)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-FLOW-CD][4]: selected by [ADR-FLOW-CD][4]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the build column ([ADR-DSGN-TRACK#15][7]).

### DSGN × quality-control (3 ADRs)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-DSGN-LIFE][2]: selected by [ADR-DSGN-LIFE][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK#15][7]).
- [ADR-DSGN-VISUAL][3]: selected by [ADR-DSGN-VISUAL][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the quality-control column ([ADR-DSGN-TRACK#15][7]).
- [ADR-FLOW-CD][4]: selected by [ADR-FLOW-CD][4]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the quality-control column ([ADR-DSGN-TRACK#15][7]).

### DSGN × release (3 ADRs)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-DSGN-LIFE][2]: selected by [ADR-DSGN-LIFE][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the release column ([ADR-DSGN-TRACK#15][7]).
- [ADR-DSGN-VISUAL][3]: selected by [ADR-DSGN-VISUAL][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the release column ([ADR-DSGN-TRACK#15][7]).
- [ADR-FLOW-CD][4]: selected by [ADR-FLOW-CD][4]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the release column ([ADR-DSGN-TRACK#15][7]).

### DSGN × deploy (3 ADRs)

Lit ([ADR-DSGN-TRACK#12][5]) by:

- [ADR-DSGN-LIFE][2]: selected by [ADR-DSGN-LIFE][2]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the deploy column ([ADR-DSGN-TRACK#15][7]).
- [ADR-DSGN-VISUAL][3]: selected by [ADR-DSGN-VISUAL][3]; its ADR domain `design` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its own value-chain concerns (quality-control, release and deploy) override its ADR domain's default
  (automation), so it lights the deploy column ([ADR-DSGN-TRACK#15][7]).
- [ADR-FLOW-CD][4]: selected by [ADR-FLOW-CD][4]; its ADR domain `flow` sits on the DSGN row of the value-chain stack
  ([ADR-DSGN-TRACK#14][6]); its value-chain concerns (build, quality-control, release and deploy) are its ADR domain's default, so it lights
  the deploy column ([ADR-DSGN-TRACK#15][7]).

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
- [gate][19], defined by [ADR-FLOW-CD#13][20]
- [occupant][21], defined by [ADR-DSGN-LIFE#5][22]
- [phase][23], defined by [ADR-AUTO-TEST#26][24]
- [quality gate][25], defined by [ADR-AUTO-TEST#35][26]
- [release candidate][27], defined by [ADR-FLOW-CD#14][28]
- [test][29], defined by [ADR-AUTO-TEST#42][30]
- [test file][31], defined by [ADR-AUTO-TEST#43][32]
- [test run][33], defined by [ADR-AUTO-TEST#34][34]
- [test suite][35], defined by [ADR-AUTO-TEST#37][36]
- [testing in production][37], defined by [ADR-AUTO-TEST#41][38]
- [tier][39], defined by [ADR-AUTO-TEST#13][40]
- [vertical test][41], defined by [ADR-AUTO-TEST#38][42]

[1]: ../../adr/automation/test-automation.md
[2]: ../../adr/design/commit-lifecycle.md
[3]: ../../adr/design/visual-design.md
[4]: ../../adr/flow/cd-discipline-and-promotion-flow.md
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
[19]: ../../adr/glossary.md#gate
[20]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[21]: ../../adr/glossary.md#occupant
[22]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[23]: ../../adr/glossary.md#phase
[24]: ../../adr/automation/test-automation.md#rule-adr-auto-test26
[25]: ../../adr/glossary.md#quality-gate
[26]: ../../adr/automation/test-automation.md#rule-adr-auto-test35
[27]: ../../adr/glossary.md#release-candidate
[28]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[29]: ../../adr/glossary.md#test
[30]: ../../adr/automation/test-automation.md#rule-adr-auto-test42
[31]: ../../adr/glossary.md#test-file
[32]: ../../adr/automation/test-automation.md#rule-adr-auto-test43
[33]: ../../adr/glossary.md#test-run
[34]: ../../adr/automation/test-automation.md#rule-adr-auto-test34
[35]: ../../adr/glossary.md#test-suite
[36]: ../../adr/automation/test-automation.md#rule-adr-auto-test37
[37]: ../../adr/glossary.md#testing-in-production
[38]: ../../adr/automation/test-automation.md#rule-adr-auto-test41
[39]: ../../adr/glossary.md#tier
[40]: ../../adr/automation/test-automation.md#rule-adr-auto-test13
[41]: ../../adr/glossary.md#vertical-test
[42]: ../../adr/automation/test-automation.md#rule-adr-auto-test38
