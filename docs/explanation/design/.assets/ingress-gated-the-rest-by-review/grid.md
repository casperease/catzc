---
catzc:
  immutable:
    with_body_sha: "31dc4b558389"
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
integration rules rest on code review][28], which explains [ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]. It lights
every cell of the world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has
its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 57 files
- docs × markdown: 19 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1653 files
- pwsh × yaml: 3 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [.claude/plans/plan-promotion-ladder.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text) and line 38 (text).
- [.claude/plans/value-of-plan.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 33 (text).

### docs × markdown (19 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [docs/adr/design/.assets/commit-lifecycle-states/chain.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line
  25 (text), line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/grid.md][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25
  (text), line 55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line 75 (text), line 79 (text),
  line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103 (text), line 104 (text) and line
  105 (text).
- [docs/adr/design/.assets/commit-lifecycle-states/tree.md][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25
  (text), line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text),
  line 75 (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text), line 106 (text) and line
  114 (text).
- [docs/adr/design/.assets/sync-point/chain.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 61 (text), line 61 (text), line 69 (text), line 69 (text), line 77 (text) and line 77 (text).
- [docs/adr/design/.assets/sync-point/grid.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 55 (text), line 56 (text), line 63 (text), line 65 (text), line 69 (text), line 73 (text), line 75 (text), line 79 (text), line 83
  (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 94 (text), line 103 (text), line 104 (text) and line 105
  (text).
- [docs/adr/design/.assets/sync-point/tree.md][12]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 18 (text), line 25 (text),
  line 48 (text), line 50 (text), line 54 (text), line 58 (text), line 60 (text), line 64 (text), line 68 (text), line 69 (text), line 75
  (text), line 77 (text), line 83 (text), line 85 (text), line 91 (text), line 92 (text), line 99 (text), line 106 (text) and line 114
  (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][13]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 103 (text).
- [docs/adr/design/server-remote-integration.md][2]: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.
- [docs/adr/glossary.md][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 273 (text) and line 347 (text).
- [docs/adr/index.md][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 112 (text); selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 113 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 327 (text).
- [docs/adr/repository/dora-explains.md][16]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 165 (text).
- [docs/adr/repository/repo-variants.md][3]: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.
- [docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][18]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  40 (text).
- [docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md][19]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md][20]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line
  17 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][21]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 11
  (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][22]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 11
  (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pipelines/ci-automation.yaml][23]: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text), `pwsh/Catzc.Base.Docs/configs/glossary.yml` line 484 (text) and
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 49 (text); selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 79 (text); selected by
  [ADR-REPO-VARIANT][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text) and `pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 44 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][24]: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 44 (text).

### pwsh × yaml (3 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][25]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 79 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 303 (text).
- [pwsh/Catzc.Base.Docs/configs/glossary.yml][26]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 484 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][27]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 49 (text).

## Keywords

- [world map][29]
- [track][30]
- [file language][31]
- [cell][32]
- [lit cell][33]
- [.claude][34]: a track
- [docs][34]: a track
- [pipelines][34]: a track
- [pwsh][34]: a track
- [markdown][35]: a file language
- [pipeline-yaml][35]: a file language
- [powershell][35]: a file language
- [yaml][35]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../adr/design/server-remote-integration.md
[3]: ../../../../adr/repository/repo-variants.md
[4]: ../../../../adr/design/tracks.md
[5]: ../../../../../.claude/plans/plan-promotion-ladder.md
[6]: ../../../../../.claude/plans/value-of-plan.md
[7]: ../../../../adr/design/.assets/commit-lifecycle-states/chain.md
[8]: ../../../../adr/design/.assets/commit-lifecycle-states/grid.md
[9]: ../../../../adr/design/.assets/commit-lifecycle-states/tree.md
[10]: ../../../../adr/design/.assets/sync-point/chain.md
[11]: ../../../../adr/design/.assets/sync-point/grid.md
[12]: ../../../../adr/design/.assets/sync-point/tree.md
[13]: ../../../../adr/design/dora-explains.md
[14]: ../../../../adr/glossary.md
[15]: ../../../../adr/index.md
[16]: ../../../../adr/repository/dora-explains.md
[17]: ../../../../references/pwsh/catzc-base-git/Push-Dirty.ps1.md
[18]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[19]: ../../../../references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
[20]: ../../../../references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
[21]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[22]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[23]: ../../../../../pipelines/ci-automation.yaml
[24]: ../../../../../pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[25]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[26]: ../../../../../pwsh/Catzc.Base.Docs/configs/glossary.yml
[27]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[28]: ../../ingress-gated-the-rest-by-review.md
[29]: ../../../../adr/glossary.md#world-map
[30]: ../../../../adr/glossary.md#track
[31]: ../../../../adr/glossary.md#file-language
[32]: ../../../../adr/glossary.md#cell
[33]: ../../../../adr/glossary.md#lit-cell
[34]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[35]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
