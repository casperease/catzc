---
catzc:
  immutable:
    with_body_sha: ef2acb49118c
    repo_status: locked
    path: docs/explanation/design/.assets/ingress-gated-the-rest-by-review/grid.md
    source: docs/explanation/design/.assets/ingress-gated-the-rest-by-review/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Only ingress is checked by gates; the source-of-truth and integration rules rest on code review: the world-map minimap

```text
Where the files that cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE and ADR-REPO-VARIANT sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 26 files.
```

![The world-map minimap of Only ingress is checked by gates; the source-of-truth and integration rules rest on code review](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Only ingress is checked by gates; the source-of-truth and
integration rules rest on code review][30], which explains [ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 8 lit of 89 files
- docs × markdown: 13 lit of 2761 files
- pipelines × pipeline-yaml: 1 lit of 13 files
- pwsh × powershell: 1 lit of 1649 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (8 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][7]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 125 (text).
- [.claude/plans/plan-fast-push-followups.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text) and line 37 (text).
- [.claude/plans/plan-promotion-ladder.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text), line 34 (text) and line
  82 (text).
- [.claude/plans/prompt-drift-gaps-1-aspect-move.md][10]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 13 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 20 (text).
- [.claude/plans/task-explanation-drift-gaps.md][12]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 35 (text).
- [.claude/plans/task-loose-ends.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55 (text).
- [.claude/plans/value-of-plan.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 36 (text) and line 43 (text).

### docs × markdown (13 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 103 (text).
- [docs/adr/design/server-remote-integration.md][2]: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.
- [docs/adr/glossary.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 272 (text) and line 345 (text).
- [docs/adr/index.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 113 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 327 (text).
- [docs/adr/repository/dora-explains.md][18]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 165 (text).
- [docs/adr/repository/repo-variants.md][3]: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][19]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][20]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  39 (text).
- [docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md][21]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md][22]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][23]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][24]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 11
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][4]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pipelines/ci-automation.yaml][25]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text); selected by
  [ADR-REPO-VARIANT][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text) and `pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 44 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language powershell
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][26]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 44 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][27]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 79 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 303 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][28]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][29]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

## Keywords

- [world map][31]
- [track][32]
- [file language][33]
- [cell][34]
- [lit cell][35]
- [.claude][36]: a track
- [docs][36]: a track
- [pipelines][36]: a track
- [pwsh][36]: a track
- [markdown][37]: a file language
- [pipeline-yaml][37]: a file language
- [powershell][37]: a file language
- [yaml][37]: a file language

Terms the cited ADRs define:

- [occupant][38], defined by [ADR-DSGN-LIFE#5][39]
- [staging slot][40], defined by [ADR-DSGN-LIFE#5][39]

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/server-remote-integration.md
[3]: ../../../../adr/repository/repo-variants.md
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[8]: ../../../../../.claude/plans/plan-fast-push-followups.md
[9]: ../../../../../.claude/plans/plan-promotion-ladder.md
[10]: ../../../../../.claude/plans/prompt-drift-gaps-1-aspect-move.md
[11]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[12]: ../../../../../.claude/plans/task-explanation-drift-gaps.md
[13]: ../../../../../.claude/plans/task-loose-ends.md
[14]: ../../../../../.claude/plans/value-of-plan.md
[15]: ../../../../adr/design/dora-explains.md
[16]: ../../../../adr/glossary.md
[17]: ../../../../adr/index.md
[18]: ../../../../adr/repository/dora-explains.md
[19]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[20]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[21]: ../../../../references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
[22]: ../../../../references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
[23]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[24]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[25]: ../../../../../pipelines/ci-automation.yaml
[26]: ../../../../../pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[27]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[29]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[30]: ../../ingress-gated-the-rest-by-review.md
[31]: ../../../../adr/glossary.md#world-map
[32]: ../../../../adr/glossary.md#track
[33]: ../../../../adr/glossary.md#file-language
[34]: ../../../../adr/glossary.md#cell
[35]: ../../../../adr/glossary.md#lit-cell
[36]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[37]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[38]: ../../../../adr/glossary.md#occupant
[39]: ../../../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[40]: ../../../../adr/glossary.md#staging-slot
