---
catzc:
  immutable:
    with_body_sha: "828f54e4db9d"
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
    source: docs/explanation/.assets/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only BVT has a gate in code; the sync-point rules are ADR-only: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE and ADR-FLOW-CD sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 20 files.
```

![The world-map minimap of Only BVT has a gate in code; the sync-point rules are ADR-only](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Only BVT has a gate in code; the sync-point rules are
ADR-only][24], which explains [ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 90 files
- automation × powershell: 1 lit of 1629 files
- automation × yaml: 3 lit of 112 files
- docs × markdown: 12 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [.claude/plans/plan-fast-push-followups.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/value-of-plan.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 44 (text).

### automation × powershell (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][9]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and
  line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 97 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 18 (text).
- [pwsh/Catzc.Base.QualityGates/configs/glossary.yml][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 58 (text).

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: the ADR's own file.
- [docs/adr/flow/dora-explains.md][14]: selected by [ADR-FLOW-CD][2]: the file cites it at line 11 (text).
- [docs/adr/glossary.md][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 497 (text) and line 510 (text).
- [docs/adr/index.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 129 (text).
- [docs/references/pwsh/catzc-base-docs/configs/adrs.yml.md][17]: selected by [ADR-FLOW-CD][2]: the file cites it at line 40 (text).
- [docs/references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md][18]: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text), line
  29 (text), line 57 (text) and line 58 (text).
- [docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md][19]: selected by [ADR-FLOW-CD][2]: the file cites it at line 34 (text).
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][20]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][21]: selected by [ADR-FLOW-CD][2]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md][22]: selected by [ADR-FLOW-CD][2]: the file cites it at line 54
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][23]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text) and `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49
  (text); selected by [ADR-FLOW-CD][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 97 (text), `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 70 (text),
  `pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1` line 71 (text), `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 18
  (text) and `pwsh/Catzc.Base.QualityGates/configs/glossary.yml` line 58 (text).

## Keywords

- [world map][25]
- [track][26]
- [file language][27]
- [cell][28]
- [lit cell][29]
- [.claude][30]: a track
- [automation][30]: a track
- [docs][30]: a track
- [pipelines][30]: a track
- [markdown][31]: a file language
- [pipeline-yaml][31]: a file language
- [powershell][31]: a file language
- [yaml][31]: a file language

Terms the cited ADRs define:

- [gate][32], defined by [ADR-FLOW-CD#13][33]
- [occupant][34], defined by [ADR-DSGN-LIFE#5][35]
- [release candidate][36], defined by [ADR-FLOW-CD#14][37]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/CLAUDE.md
[7]: ../../../../../.claude/plans/plan-fast-push-followups.md
[8]: ../../../../../.claude/plans/value-of-plan.md
[9]: ../../../../../pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[10]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/glossary.yml
[13]: ../../../../adr/design/dora-explains.md
[14]: ../../../../adr/flow/dora-explains.md
[15]: ../../../../adr/glossary.md
[16]: ../../../../adr/index.md
[17]: ../../../../references/pwsh/catzc-base-docs/configs/adrs.yml.md
[18]: ../../../../references/pwsh/catzc-base-docs/types/AdrsConfig.cs.md
[19]: ../../../../references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
[20]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[21]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[22]: ../../../../references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
[23]: ../../../../../pipelines/ci-automation.yaml
[24]: ../../sync-point-rules-are-adr-only.md
[25]: ../../../../adr/glossary.md#world-map
[26]: ../../../../adr/glossary.md#track
[27]: ../../../../adr/glossary.md#file-language
[28]: ../../../../adr/glossary.md#cell
[29]: ../../../../adr/glossary.md#lit-cell
[30]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[31]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[32]: ../../../../adr/glossary.md#gate
[33]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[34]: ../../../../adr/glossary.md#occupant
[35]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[36]: ../../../../adr/glossary.md#release-candidate
[37]: ../../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
