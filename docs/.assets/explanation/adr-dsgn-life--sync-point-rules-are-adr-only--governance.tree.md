# docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md

`Tree minimap: adr-dsgn-life--sync-point-rules-are-adr-only--governance`

![Tree minimap of adr-dsgn-life--sync-point-rules-are-adr-only--governance](adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.png)

The tree minimap of the slide `adr-dsgn-life--sync-point-rules-are-adr-only--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 68 files in 9 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 40 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- adr/flow (docs/adr/flow): 6 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (40 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][4], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][5], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 71 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][10], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][12], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][13], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][14], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 65 (text) and line 74 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 65
  (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][15], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67
  (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][18], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][19], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][21], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 74 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][26], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][27], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][28], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][29], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][30], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][31], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][32], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][33], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][34], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][35], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][36], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][2]:
  the file cites it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and
  line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][37], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][38], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][39], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][40], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][41], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][42], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][43], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][44], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][45], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][46], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][47], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][48], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][49], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][50], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][51], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][52], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][54], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][56], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][57], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).
- [.claude/drawio/STYLE.md][58], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][59], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][60], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][61], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][62], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][63], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][64], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 70 (text) and line 71 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][65], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][66], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][67], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][68], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 62 (text).

## Keywords

- [world map][69]
- [track][70]
- [file language][71]
- [cell][72]
- [lit cell][73]
- [.claude][74]: a track
- [automation][74]: a track
- [docs][74]: a track
- [csharp][75]: a file language
- [markdown][75]: a file language
- [powershell][75]: a file language
- [yaml][75]: a file language

Terms the cited ADRs define:

- [gate][76], defined by [ADR-FLOW-CD#13][77]
- [occupant][78], defined by [ADR-DSGN-LIFE#5][79]
- [release candidate][80], defined by [ADR-FLOW-CD#14][81]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[4]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[5]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[6]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[7]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[8]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[9]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[10]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[11]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[12]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[13]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[14]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[15]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[16]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[17]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[18]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[19]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[20]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[21]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[22]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[23]: ../../explanation/design/clients-bridge-to-one-server.md
[24]: ../../explanation/design/code-wires-only-the-first-rungs.md
[25]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[26]: ../../explanation/design/deploying-is-not-integrating.md
[27]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[28]: ../../explanation/design/every-deploy-stage-is-main-only.md
[29]: ../../explanation/design/four-domains-promote-one-artifact.md
[30]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[31]: ../../explanation/design/integrators-depend-on-an-occupant.md
[32]: ../../explanation/design/merging-to-main-is-what-deploys.md
[33]: ../../explanation/design/one-way-climb-three-endings.md
[34]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[35]: ../../explanation/design/sync-from-the-last-certified-commit.md
[36]: ../../explanation/design/sync-point-rules-are-adr-only.md
[37]: ../../explanation/design/which-rung-gates-exist-in-code.md
[38]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[39]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[40]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[41]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[42]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[43]: ../../adr/design/dora-explains.md
[44]: ../../adr/design/module-aspects.md
[45]: ../../adr/design/run-modes.md
[46]: ../../adr/design/self-service.md
[47]: ../../adr/design/server-remote-integration.md
[48]: ../../adr/design/thin-platforms.md
[49]: ../../adr/design/tracks.md
[50]: ../../adr/design/visual-design.md
[51]: ../../adr/flow/dora-explains.md
[52]: ../../adr/flow/durable-sha-globs.md
[53]: ../../adr/flow/pipeline-detection.md
[54]: ../../adr/flow/pipeline-runner-pattern.md
[55]: ../../adr/flow/pipeline-types.md
[56]: ../../../.claude/CLAUDE.md
[57]: ../../../.claude/agents/write-drawio-files.md
[58]: ../../../.claude/drawio/STYLE.md
[59]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[60]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[61]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[62]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[63]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[64]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[65]: ../../adr/glossary.md
[66]: ../../adr/index.md
[67]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[68]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[69]: ../../adr/glossary.md#world-map
[70]: ../../adr/glossary.md#track
[71]: ../../adr/glossary.md#file-language
[72]: ../../adr/glossary.md#cell
[73]: ../../adr/glossary.md#lit-cell
[74]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[75]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[76]: ../../adr/glossary.md#gate
[77]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[78]: ../../adr/glossary.md#occupant
[79]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[80]: ../../adr/glossary.md#release-candidate
[81]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
