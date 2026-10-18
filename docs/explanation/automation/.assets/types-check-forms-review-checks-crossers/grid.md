---
catzc:
  immutable:
    with_body_sha: "30a2ca3e6b17"
    repo_status: locked
    path: docs/explanation/automation/.assets/types-check-forms-review-checks-crossers/grid.md
    source: docs/explanation/automation/.assets/types-check-forms-review-checks-crossers/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Three types check path forms at construction, and the crossing rules are left to review: the world-map minimap

```text
Where the files that cite ADR-AUTO-PATH sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 37 files.
```

![The world-map minimap of Three types check path forms at construction, and the crossing rules are left to review](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [Three types check path forms at construction, and the crossing
rules are left to review][39], which explains [ADR-AUTO-PATH][1]. It lights every cell of the world map that holds a file citing those
codes, so it shows where the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 89 files
- docs × markdown: 28 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 4 lit of 1651 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [.claude/plans/plan-explanation-drift-gaps.md][3]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 63 (text) and line 113
  (text).
- [.claude/skills/catzc-module/SKILL.md][4]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 27 (text), line 28 (text), line 41
  (text) and line 41 (text).

### docs × markdown (28 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [docs/adr/automation/dora-explains.md][5]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 401 (text).
- [docs/adr/automation/path-representation.md][1]: selected by [ADR-AUTO-PATH][1]: the ADR's own file.
- [docs/adr/glossary.md][6]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 793 (text).
- [docs/adr/index.md][7]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 171 (text).
- [docs/references/pwsh/catzc-base-contracts/Get-Contract.ps1.md][8]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md][9]: selected by [ADR-AUTO-PATH][1]: the file cites it at line
  44 (text).
- [docs/references/pwsh/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md][10]: selected by [ADR-AUTO-PATH][1]: the file cites it
  at line 29 (text).
- [docs/references/pwsh/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md][11]: selected by [ADR-AUTO-PATH][1]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-contracts/types/ContractAsset.cs.md][12]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 17
  (text) and line 18 (text).
- [docs/references/pwsh/catzc-base-docs/configs/readme.yml.md][13]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 30 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocMapping.cs.md][14]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocPattern.cs.md][15]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][16]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 42
  (text).
- [docs/references/pwsh/catzc-base-objects/types/ArtifactRef.cs.md][17]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-base-objects/types/RepoRelativePath.cs.md][18]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 11
  (text), line 16 (text), line 17 (text), line 21 (text) and line 40 (text).
- [docs/references/pwsh/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md][19]: selected by [ADR-AUTO-PATH][1]: the file cites it at
  line 15 (text) and line 23 (text).
- [docs/references/pwsh/catzc-base-repository/Get-RepositoryFile.ps1.md][20]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-repository/Get-RepositoryFolder.ps1.md][21]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-repository/Resolve-RepoPath.ps1.md][22]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-rootconfig/configs/rootconfig.yml.md][23]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 28
  (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFile.cs.md][24]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 23
  (text).
- [docs/references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md][25]: selected by [ADR-AUTO-PATH][1]: the file cites it at line
  24 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md][26]: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 15 (text), line 16 (text) and line 19 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md][27]: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][28]: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 14 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md][29]: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-tooling-inspiration/types/Inspiration.cs.md][30]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 17
  (text).
- [docs/references/pwsh/catzc-tooling-inspiration/types/InspirationRoot.cs.md][31]: selected by [ADR-AUTO-PATH][1]: the file cites it at
  line 12 (text), line 14 (text) and line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pipelines/ci-automation.yaml][32]: selected by [ADR-AUTO-PATH][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 27 (text),
  `pwsh/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1` line 13 (text), `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 140 (text),
  `pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml` line 37 (text), `pwsh/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1` line 1
  (text) and `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` line 36 (text).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][33]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 27 (text).
- [pwsh/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1][34]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 13 (text).
- [pwsh/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1][35]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1][36]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 36 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][2]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][2]). Lit ([ADR-DSGN-TRACK-LITCELL][2]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][37]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 140 (text).
- [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml][38]: selected by [ADR-AUTO-PATH][1]: the file cites it at line 37 (text).

## Keywords

- [world map][40]
- [track][41]
- [file language][42]
- [cell][43]
- [lit cell][44]
- [.claude][45]: a track
- [docs][45]: a track
- [pipelines][45]: a track
- [pwsh][45]: a track
- [markdown][46]: a file language
- [pipeline-yaml][46]: a file language
- [powershell][46]: a file language
- [yaml][46]: a file language

[1]: ../../../../adr/automation/path-representation.md
[2]: ../../../../adr/design/tracks.md
[3]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[4]: ../../../../../.claude/skills/catzc-module/SKILL.md
[5]: ../../../../adr/automation/dora-explains.md
[6]: ../../../../adr/glossary.md
[7]: ../../../../adr/index.md
[8]: ../../../../references/pwsh/catzc-base-contracts/Get-Contract.ps1.md
[9]: ../../../../references/pwsh/catzc-base-contracts/Publish-ContractRelease.ps1.md
[10]: ../../../../references/pwsh/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md
[11]: ../../../../references/pwsh/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md
[12]: ../../../../references/pwsh/catzc-base-contracts/types/ContractAsset.cs.md
[13]: ../../../../references/pwsh/catzc-base-docs/configs/readme.yml.md
[14]: ../../../../references/pwsh/catzc-base-docs/types/DocMapping.cs.md
[15]: ../../../../references/pwsh/catzc-base-docs/types/DocPattern.cs.md
[16]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[17]: ../../../../references/pwsh/catzc-base-objects/types/ArtifactRef.cs.md
[18]: ../../../../references/pwsh/catzc-base-objects/types/RepoRelativePath.cs.md
[19]: ../../../../references/pwsh/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
[20]: ../../../../references/pwsh/catzc-base-repository/Get-RepositoryFile.ps1.md
[21]: ../../../../references/pwsh/catzc-base-repository/Get-RepositoryFolder.ps1.md
[22]: ../../../../references/pwsh/catzc-base-repository/Resolve-RepoPath.ps1.md
[23]: ../../../../references/pwsh/catzc-base-rootconfig/configs/rootconfig.yml.md
[24]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFile.cs.md
[25]: ../../../../references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md
[26]: ../../../../references/pwsh/catzc-tooling-inspiration/private/Resolve-InspirationRoot.ps1.md
[27]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
[28]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[29]: ../../../../references/pwsh/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
[30]: ../../../../references/pwsh/catzc-tooling-inspiration/types/Inspiration.cs.md
[31]: ../../../../references/pwsh/catzc-tooling-inspiration/types/InspirationRoot.cs.md
[32]: ../../../../../pipelines/ci-automation.yaml
[33]: ../../../../../pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[34]: ../../../../../pwsh/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1
[35]: ../../../../../pwsh/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1
[36]: ../../../../../pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
[37]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[38]: ../../../../../pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
[39]: ../../types-check-forms-review-checks-crossers.md
[40]: ../../../../adr/glossary.md#world-map
[41]: ../../../../adr/glossary.md#track
[42]: ../../../../adr/glossary.md#file-language
[43]: ../../../../adr/glossary.md#cell
[44]: ../../../../adr/glossary.md#lit-cell
[45]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[46]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
