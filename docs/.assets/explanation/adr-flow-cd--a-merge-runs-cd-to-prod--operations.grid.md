# docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md

`Grid minimap: adr-flow-cd--a-merge-runs-cd-to-prod--operations`

![Grid minimap of adr-flow-cd--a-merge-runs-cd-to-prod--operations](adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.png)

The grid minimap of the slide `adr-flow-cd--a-merge-runs-cd-to-prod--operations` (operations lens). The slide supports [ADR-FLOW-CD][1]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 5 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 2 lit of 9 files
- automation × csharp: 2 lit of 219 files
- automation × powershell: 3 lit of 1398 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 28 lit of 469 files

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][8]: selected by [ADR-FLOW-CD][1]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][9]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][12]: selected by [ADR-FLOW-CD][1]: the file cites it at line 105 (body comment) and line 118
  (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][13]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][14]: selected by [ADR-FLOW-CD][1]: the file cites it at line 62 (text).

### docs × markdown (28 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][15]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][16]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][17]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][18]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][19]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][20]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][21]: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][22]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][23]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][24]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 74 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][25]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][26]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][27]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][28]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][29]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][30]: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][31]: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][32]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][33]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][34]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 50 (text) and line 51 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][35]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line 34
  (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][36]: selected by [ADR-FLOW-CD][1]: the file cites it at line 60 (text), line
  60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][37]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text), line 48 (text),
  line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][38]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][39]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line
  47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][40]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][41]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

## Keywords

- [world map][42]
- [track][43]
- [file language][44]
- [cell][45]
- [lit cell][46]
- [.claude][47]: a track
- [automation][47]: a track
- [docs][47]: a track
- [csharp][48]: a file language
- [markdown][48]: a file language
- [powershell][48]: a file language
- [yaml][48]: a file language

Terms the cited ADRs define:

- [gate][49], defined by [ADR-FLOW-CD#13][50]
- [release candidate][51], defined by [ADR-FLOW-CD#14][52]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/CLAUDE.md
[6]: ../../../.claude/drawio/STYLE.md
[7]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[8]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[9]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[10]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[11]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[12]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[13]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[14]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[15]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[16]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[17]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[18]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[19]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[20]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[21]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[22]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[23]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[24]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[25]: ../../adr/flow/dora-explains.md
[26]: ../../adr/flow/durable-sha-globs.md
[27]: ../../adr/flow/pipeline-detection.md
[28]: ../../adr/flow/pipeline-runner-pattern.md
[29]: ../../adr/flow/pipeline-types.md
[30]: ../../adr/glossary.md
[31]: ../../adr/index.md
[32]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[33]: ../../explanation/design/four-domains-promote-one-artifact.md
[34]: ../../explanation/design/integrators-depend-on-an-occupant.md
[35]: ../../explanation/design/sync-point-rules-are-adr-only.md
[36]: ../../explanation/design/which-rung-gates-exist-in-code.md
[37]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[38]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[39]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[40]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[41]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[42]: ../../adr/glossary.md#world-map
[43]: ../../adr/glossary.md#track
[44]: ../../adr/glossary.md#file-language
[45]: ../../adr/glossary.md#cell
[46]: ../../adr/glossary.md#lit-cell
[47]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[48]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[49]: ../../adr/glossary.md#gate
[50]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[51]: ../../adr/glossary.md#release-candidate
[52]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
