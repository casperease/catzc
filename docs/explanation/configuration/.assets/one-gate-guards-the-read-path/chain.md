---
catzc:
  immutable:
    with_body_sha: "3846302d42f2"
    repo_status: locked
    path: docs/explanation/configuration/.assets/one-gate-guards-the-read-path/chain.md
    source: docs/explanation/configuration/.assets/one-gate-guards-the-read-path/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One quality gate guards the config read path, and it checks only the typed step: the value-chain minimap

```text
Where ADR-AUTO-TEST, ADR-CONF-ADDRESSING and ADR-CONF-LOADING sit in the value chain: value-chain stack down, value-chain concerns across.
1 of 25 cells lit.
```

![The value-chain minimap of One quality gate guards the config read path, and it checks only the typed step](chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [One quality gate guards the config read path, and it checks
only the typed step][7], which explains [ADR-AUTO-TEST][1], [ADR-CONF-ADDRESSING][2] and [ADR-CONF-LOADING][3]. It lights the cells of the
value-chain map where the cited ADRs' value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell
has its reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × quality-control: 1 lit of 18 ADRs

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

Lit ([ADR-DSGN-TRACK#12][4]) by:

- [ADR-AUTO-TEST][1]: selected by [ADR-AUTO-TEST][1]; its ADR domain `automation` sits on the AUTO row of the value-chain stack
  ([ADR-DSGN-TRACK#14][5]); its own value-chain concerns (quality-control) override its ADR domain's default (automation), so it lights the
  quality-control column ([ADR-DSGN-TRACK#15][6]).

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

[1]: ../../../../adr/automation/test-automation.md
[2]: ../../../../adr/configuration/config-value-addressing.md
[3]: ../../../../adr/configuration/module-config-loading.md
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track14
[6]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track15
[7]: ../../one-gate-guards-the-read-path.md
[8]: ../../../../adr/glossary.md#value-chain-map
[9]: ../../../../adr/glossary.md#value-chain-stack
[10]: ../../../../adr/glossary.md#value-chain-concern
[11]: ../../../../adr/glossary.md#cell
[12]: ../../../../adr/glossary.md#lit-cell
[13]: ../../../../adr/glossary.md#all-tests
[14]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test36
[15]: ../../../../adr/glossary.md#build-verification-test
[16]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test24
[17]: ../../../../adr/glossary.md#category
[18]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test1
[19]: ../../../../adr/glossary.md#phase
[20]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test26
[21]: ../../../../adr/glossary.md#quality-gate
[22]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test35
[23]: ../../../../adr/glossary.md#test
[24]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test42
[25]: ../../../../adr/glossary.md#test-file
[26]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test43
[27]: ../../../../adr/glossary.md#test-run
[28]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test34
[29]: ../../../../adr/glossary.md#test-suite
[30]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test37
[31]: ../../../../adr/glossary.md#testing-in-production
[32]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test41
[33]: ../../../../adr/glossary.md#tier
[34]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test13
[35]: ../../../../adr/glossary.md#vertical-test
[36]: ../../../../adr/automation/test-automation.md#rule-adr-auto-test38
