# docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md

`Grid minimap: adr-dsgn-life--four-domains-promote-one-artifact--architecture`

![Grid minimap of adr-dsgn-life--four-domains-promote-one-artifact--architecture](adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-life--four-domains-promote-one-artifact--architecture` (architecture lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 9 files
- automation × csharp: 2 lit of 219 files
- automation × powershell: 3 lit of 1412 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 37 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).
- [.claude/drawio/STYLE.md][8]: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][9]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][10]: selected by [ADR-FLOW-CD][2]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][11]: selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][13]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][16]: selected by [ADR-FLOW-CD][2]: the file cites it at line 62 (text).

### docs × markdown (37 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][17]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][18]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][19]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][20]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][21]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][22]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][23]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][24]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][25]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][26]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][27]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][28]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][29]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][30]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][31]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-FLOW-CD][2]: the file cites
  it at line 107 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][32]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][33]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][34]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][35]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][36]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][37]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][38]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][39]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][40]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text), line
  50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][41]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][42]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][43]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][44]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][45]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text), line
  34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][46]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][47]: selected by [ADR-FLOW-CD][2]: the file cites it at line 16 (text), line 48 (text),
  line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][48]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text),
  line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][49]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text), line
  47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][50]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][51]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

## Keywords

- [world map][52]
- [track][53]
- [file language][54]
- [cell][55]
- [lit cell][56]
- [.claude][57]: a track
- [automation][57]: a track
- [docs][57]: a track
- [csharp][58]: a file language
- [markdown][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

Terms the cited ADRs define:

- [gate][59], defined by [ADR-FLOW-CD#13][60]
- [occupant][61], defined by [ADR-DSGN-LIFE#5][62]
- [release candidate][63], defined by [ADR-FLOW-CD#14][64]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../.claude/drawio/STYLE.md
[9]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[10]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[11]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[12]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[13]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[14]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[16]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[17]: ../../adr/design/dora-explains.md
[18]: ../../adr/design/module-aspects.md
[19]: ../../adr/design/run-modes.md
[20]: ../../adr/design/self-service.md
[21]: ../../adr/design/server-remote-integration.md
[22]: ../../adr/design/thin-platforms.md
[23]: ../../adr/design/tracks.md
[24]: ../../adr/design/visual-design.md
[25]: ../../adr/flow/dora-explains.md
[26]: ../../adr/flow/durable-sha-globs.md
[27]: ../../adr/flow/pipeline-detection.md
[28]: ../../adr/flow/pipeline-runner-pattern.md
[29]: ../../adr/flow/pipeline-types.md
[30]: ../../adr/glossary.md
[31]: ../../adr/index.md
[32]: ../../explanation/design/clients-bridge-to-one-server.md
[33]: ../../explanation/design/code-wires-only-the-first-rungs.md
[34]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[35]: ../../explanation/design/deploying-is-not-integrating.md
[36]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[37]: ../../explanation/design/every-deploy-stage-is-main-only.md
[38]: ../../explanation/design/four-domains-promote-one-artifact.md
[39]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[40]: ../../explanation/design/integrators-depend-on-an-occupant.md
[41]: ../../explanation/design/merging-to-main-is-what-deploys.md
[42]: ../../explanation/design/one-way-climb-three-endings.md
[43]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[44]: ../../explanation/design/sync-from-the-last-certified-commit.md
[45]: ../../explanation/design/sync-point-rules-are-adr-only.md
[46]: ../../explanation/design/which-rung-gates-exist-in-code.md
[47]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[48]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[49]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[50]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[51]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[52]: ../../adr/glossary.md#world-map
[53]: ../../adr/glossary.md#track
[54]: ../../adr/glossary.md#file-language
[55]: ../../adr/glossary.md#cell
[56]: ../../adr/glossary.md#lit-cell
[57]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[59]: ../../adr/glossary.md#gate
[60]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[61]: ../../adr/glossary.md#occupant
[62]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[63]: ../../adr/glossary.md#release-candidate
[64]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
