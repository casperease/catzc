# docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md

`Tree minimap: adr-dsgn-life--four-domains-promote-one-artifact--architecture`

![Tree minimap of adr-dsgn-life--four-domains-promote-one-artifact--architecture](adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-life--four-domains-promote-one-artifact--architecture` (architecture lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 48 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 20 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- adr/flow (docs/adr/flow): 6 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (20 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/clients-bridge-to-one-server.md][3], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][11], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][13], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][14], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][16], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][2]:
  the file cites it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and
  line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][18], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][19], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][20], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][21], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][22], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][26], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][27], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][28], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][29], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][30], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][31], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][32], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][33], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][34], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][35], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][36], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][37], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).
- [.claude/drawio/STYLE.md][38], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][39], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][40], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][41], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][42], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][43], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][44], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 70 (text) and line 71 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][45], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][46], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][47], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][48], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 62 (text).

## Keywords

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [.claude][54]: a track
- [automation][54]: a track
- [docs][54]: a track
- [csharp][55]: a file language
- [markdown][55]: a file language
- [powershell][55]: a file language
- [yaml][55]: a file language

Terms the cited ADRs define:

- [gate][56], defined by [ADR-FLOW-CD#13][57]
- [occupant][58], defined by [ADR-DSGN-LIFE#5][59]
- [release candidate][60], defined by [ADR-FLOW-CD#14][61]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../explanation/design/clients-bridge-to-one-server.md
[4]: ../../explanation/design/code-wires-only-the-first-rungs.md
[5]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[6]: ../../explanation/design/deploying-is-not-integrating.md
[7]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[8]: ../../explanation/design/every-deploy-stage-is-main-only.md
[9]: ../../explanation/design/four-domains-promote-one-artifact.md
[10]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[11]: ../../explanation/design/integrators-depend-on-an-occupant.md
[12]: ../../explanation/design/merging-to-main-is-what-deploys.md
[13]: ../../explanation/design/one-way-climb-three-endings.md
[14]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[15]: ../../explanation/design/sync-from-the-last-certified-commit.md
[16]: ../../explanation/design/sync-point-rules-are-adr-only.md
[17]: ../../explanation/design/which-rung-gates-exist-in-code.md
[18]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[19]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[20]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[21]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[22]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[23]: ../../adr/design/dora-explains.md
[24]: ../../adr/design/module-aspects.md
[25]: ../../adr/design/run-modes.md
[26]: ../../adr/design/self-service.md
[27]: ../../adr/design/server-remote-integration.md
[28]: ../../adr/design/thin-platforms.md
[29]: ../../adr/design/tracks.md
[30]: ../../adr/design/visual-design.md
[31]: ../../adr/flow/dora-explains.md
[32]: ../../adr/flow/durable-sha-globs.md
[33]: ../../adr/flow/pipeline-detection.md
[34]: ../../adr/flow/pipeline-runner-pattern.md
[35]: ../../adr/flow/pipeline-types.md
[36]: ../../../.claude/CLAUDE.md
[37]: ../../../.claude/agents/write-drawio-files.md
[38]: ../../../.claude/drawio/STYLE.md
[39]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[40]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[41]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[42]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[43]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[44]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[45]: ../../adr/glossary.md
[46]: ../../adr/index.md
[47]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[48]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[49]: ../../adr/glossary.md#world-map
[50]: ../../adr/glossary.md#track
[51]: ../../adr/glossary.md#file-language
[52]: ../../adr/glossary.md#cell
[53]: ../../adr/glossary.md#lit-cell
[54]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[56]: ../../adr/glossary.md#gate
[57]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[58]: ../../adr/glossary.md#occupant
[59]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[60]: ../../adr/glossary.md#release-candidate
[61]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
