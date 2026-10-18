---
catzc:
  immutable:
    with_body_sha: "8c1da78180d4"
    repo_status: locked
    path: docs/explanation/.assets/chain/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
    source: docs/explanation/.assets/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Gates check the source of each globset and the trigger, but not the git reflection or the identity: the value-chain minimap

```text
Where ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS sit in the value chain: value-chain stack down, value-chain concerns across.
1 of 25 cells lit.
```

![The value-chain minimap of Gates check the source of each globset and the trigger, but not the git reflection or the identity](adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.png)

This is the value-chain minimap in the sidebar of the governance diagram of [Gates check the source of each globset and the trigger, but not
the git reflection or the identity][6], which explains [ADR-AUTO-TEST][1] and [ADR-FLOW-CD-GLOBS][2]. It lights the cells of the value-chain
map where the cited ADRs' value-chain concerns land, so it shows the part of the value chain the decision governs. Each lit cell has its
reason below, naming the code that selects it.

## What the minimap shows

Value-chain map: value-chain stack × value-chain concerns. The grid crosses the 5 rows of the value-chain stack (PRIN, DSGN, AUTO, PIPE,
CLOUD) with the 5 value-chain concerns (build, quality-control, release, deploy, access) and lights 1 cell, filled in ink. Every other cell
is idle, a grey box: it holds ADRs the slide does not cite, or none, because no ADR's value-chain concern lands there (5 of the 25 cells
hold none). The minimap shows where the slide sits, not how many ADRs a cell holds; that count belongs to the full value-chain map.

- AUTO × quality-control: 1 lit of 17 ADRs

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

- [value-chain map][7]
- [value-chain stack][8]
- [value-chain concern][9]
- [cell][10]
- [lit cell][11]

Terms the cited ADRs define:

- [all tests][12], defined by [ADR-AUTO-TEST#36][13]
- [build verification test][14], defined by [ADR-AUTO-TEST#24][15]
- [category][16], defined by [ADR-AUTO-TEST#1][17]
- [phase][18], defined by [ADR-AUTO-TEST#26][19]
- [quality gate][20], defined by [ADR-AUTO-TEST#35][21]
- [test][22], defined by [ADR-AUTO-TEST#42][23]
- [test file][24], defined by [ADR-AUTO-TEST#43][25]
- [test run][26], defined by [ADR-AUTO-TEST#34][27]
- [test suite][28], defined by [ADR-AUTO-TEST#37][29]
- [testing in production][30], defined by [ADR-AUTO-TEST#41][31]
- [tier][32], defined by [ADR-AUTO-TEST#13][33]
- [vertical test][34], defined by [ADR-AUTO-TEST#38][35]

[1]: ../../../adr/automation/test-automation.md
[2]: ../../../adr/flow/durable-sha-globs.md
[3]: ../../../adr/design/tracks.md#rule-adr-dsgn-track12
[4]: ../../../adr/design/tracks.md#rule-adr-dsgn-track14
[5]: ../../../adr/design/tracks.md#rule-adr-dsgn-track15
[6]: ../../flow/gates-check-source-and-trigger.md
[7]: ../../../adr/glossary.md#value-chain-map
[8]: ../../../adr/glossary.md#value-chain-stack
[9]: ../../../adr/glossary.md#value-chain-concern
[10]: ../../../adr/glossary.md#cell
[11]: ../../../adr/glossary.md#lit-cell
[12]: ../../../adr/glossary.md#all-tests
[13]: ../../../adr/automation/test-automation.md#rule-adr-auto-test36
[14]: ../../../adr/glossary.md#build-verification-test
[15]: ../../../adr/automation/test-automation.md#rule-adr-auto-test24
[16]: ../../../adr/glossary.md#category
[17]: ../../../adr/automation/test-automation.md#rule-adr-auto-test1
[18]: ../../../adr/glossary.md#phase
[19]: ../../../adr/automation/test-automation.md#rule-adr-auto-test26
[20]: ../../../adr/glossary.md#quality-gate
[21]: ../../../adr/automation/test-automation.md#rule-adr-auto-test35
[22]: ../../../adr/glossary.md#test
[23]: ../../../adr/automation/test-automation.md#rule-adr-auto-test42
[24]: ../../../adr/glossary.md#test-file
[25]: ../../../adr/automation/test-automation.md#rule-adr-auto-test43
[26]: ../../../adr/glossary.md#test-run
[27]: ../../../adr/automation/test-automation.md#rule-adr-auto-test34
[28]: ../../../adr/glossary.md#test-suite
[29]: ../../../adr/automation/test-automation.md#rule-adr-auto-test37
[30]: ../../../adr/glossary.md#testing-in-production
[31]: ../../../adr/automation/test-automation.md#rule-adr-auto-test41
[32]: ../../../adr/glossary.md#tier
[33]: ../../../adr/automation/test-automation.md#rule-adr-auto-test13
[34]: ../../../adr/glossary.md#vertical-test
[35]: ../../../adr/automation/test-automation.md#rule-adr-auto-test38
