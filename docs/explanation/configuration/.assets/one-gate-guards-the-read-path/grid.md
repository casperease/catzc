---
catzc:
  immutable:
    with_body_sha: "791fa0165152"
    repo_status: locked
    path: docs/explanation/configuration/.assets/one-gate-guards-the-read-path/grid.md
    source: docs/explanation/configuration/.assets/one-gate-guards-the-read-path/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# One quality gate guards the config read path, and it checks only the typed step: the world-map minimap

```text
Where the files that cite ADR-AUTO-TEST, ADR-CONF-ADDRESSING and ADR-CONF-LOADING sit in the repository: tracks down, file languages across.
5 of 342 cells lit, holding 34 files.
```

![The world-map minimap of One quality gate guards the config read path, and it checks only the typed step](grid.png)

This is the world-map minimap in the sidebar of the governance diagram of [One quality gate guards the config read path, and it checks only
the typed step][36], which explains [ADR-AUTO-TEST][1], [ADR-CONF-ADDRESSING][2] and [ADR-CONF-LOADING][3]. It lights every cell of the
world map that holds a file citing those codes, so it shows where the decision lives in the repository. Each lit cell has its reason below,
naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 5 lit of 89 files
- docs × markdown: 26 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × powershell: 1 lit of 1651 files
- pwsh × yaml: 1 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (5 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 54 (text).
- [.claude/agents/test-optimization.md][6]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 5 (text).
- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 80 (text) and line 83 (text);
  selected by [ADR-CONF-LOADING][3]: the file cites it at line 32 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][8]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 204 (text).
- [.claude/skills/test-speed/SKILL.md][9]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 4 (text).

### docs × markdown (26 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [docs/adr/automation/dora-explains.md][10]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 140 (text).
- [docs/adr/automation/test-automation.md][1]: selected by [ADR-AUTO-TEST][1]: the ADR's own file.
- [docs/adr/configuration/config-value-addressing.md][2]: selected by [ADR-CONF-ADDRESSING][2]: the ADR's own file.
- [docs/adr/configuration/dora-explains.md][11]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 28 (text); selected by
  [ADR-CONF-LOADING][3]: the file cites it at line 11 (text).
- [docs/adr/configuration/module-config-loading.md][3]: selected by [ADR-CONF-LOADING][3]: the ADR's own file.
- [docs/adr/index.md][12]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 158 (text); selected by [ADR-CONF-ADDRESSING][2]: the
  file cites it at line 239 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 238 (text).
- [docs/references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md][13]: selected by
  [ADR-AUTO-TEST][1]: the file cites it at line 44 (text).
- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][14]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][15]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it
  at line 14 (text).
- [docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md][16]: selected by [ADR-CONF-LOADING][3]: the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-docs/types/DocsConfig.cs.md][17]: selected by [ADR-CONF-LOADING][3]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md][18]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 136
  (text).
- [docs/references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md][19]: selected by [ADR-AUTO-TEST][1]: the
  file cites it at line 95 (text).
- [docs/references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md][20]: selected by [ADR-CONF-LOADING][3]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][21]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line 63
  (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][22]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it at line
  56 (text).
- [docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md][23]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 43
  (text).
- [docs/references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md][24]: selected by [ADR-CONF-LOADING][3]: the file cites it at line
  40 (text).
- [docs/references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md][25]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 14
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md][26]: selected by [ADR-AUTO-TEST][1]: the file cites it at line
  42 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md][27]: selected by [ADR-CONF-LOADING][3]: the file
  cites it at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md][28]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 101 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md][29]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md][30]: selected by [ADR-CONF-LOADING][3]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][31]: selected by [ADR-CONF-ADDRESSING][2]: the file cites it
  at line 20 (text).
- [docs/references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md][32]: selected by [ADR-AUTO-TEST][1]: the file
  cites it at line 15 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pipelines/ci-automation.yaml][33]: selected by [ADR-AUTO-TEST][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 125 (text) and `pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1`
  line 1 (header); selected by [ADR-CONF-ADDRESSING][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it
  at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text); selected by [ADR-CONF-LOADING][3]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 208 (text).

### pwsh × powershell (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1][34]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 1 (header).

### pwsh × yaml (1 lit file)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][4]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][4]). Lit ([ADR-DSGN-TRACK-LITCELL][4]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][35]: selected by [ADR-AUTO-TEST][1]: the file cites it at line 125 (text); selected by
  [ADR-CONF-ADDRESSING][2]: the file cites it at line 209 (text); selected by [ADR-CONF-LOADING][3]: the file cites it at line 208 (text).

## Keywords

- [world map][37]
- [track][38]
- [file language][39]
- [cell][40]
- [lit cell][41]
- [.claude][42]: a track
- [docs][42]: a track
- [pipelines][42]: a track
- [pwsh][42]: a track
- [markdown][43]: a file language
- [pipeline-yaml][43]: a file language
- [powershell][43]: a file language
- [yaml][43]: a file language

[1]: ../../../../adr/automation/test-automation.md
[2]: ../../../../adr/configuration/config-value-addressing.md
[3]: ../../../../adr/configuration/module-config-loading.md
[4]: ../../../../adr/design/tracks.md
[5]: ../../../../../.claude/CLAUDE.md
[6]: ../../../../../.claude/agents/test-optimization.md
[7]: ../../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[9]: ../../../../../.claude/skills/test-speed/SKILL.md
[10]: ../../../../adr/automation/dora-explains.md
[11]: ../../../../adr/configuration/dora-explains.md
[12]: ../../../../adr/index.md
[13]: ../../../../references/.assets/automation/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.verify.md
[14]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[15]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[16]: ../../../../references/pwsh/catzc-base-docs/Build-Readme.ps1.md
[17]: ../../../../references/pwsh/catzc-base-docs/types/DocsConfig.cs.md
[18]: ../../../../references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
[19]: ../../../../references/pwsh/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.md
[20]: ../../../../references/pwsh/catzc-base-git/types/GitIgnoreConfig.cs.md
[21]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[22]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[23]: ../../../../references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
[24]: ../../../../references/pwsh/catzc-base-modulesystem/Copy-CatzcModule.ps1.md
[25]: ../../../../references/pwsh/catzc-base-modulesystem/configs/artifacts.yml.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/configs/terminology.yml.md
[27]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
[28]: ../../../../references/pwsh/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
[29]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Get-TestTagViolations.Tests.ps1.md
[30]: ../../../../references/pwsh/catzc-base-rootconfig/types/RootConfigFiles.cs.md
[31]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[32]: ../../../../references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md
[33]: ../../../../../pipelines/ci-automation.yaml
[34]: ../../../../../pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1
[35]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[36]: ../../one-gate-guards-the-read-path.md
[37]: ../../../../adr/glossary.md#world-map
[38]: ../../../../adr/glossary.md#track
[39]: ../../../../adr/glossary.md#file-language
[40]: ../../../../adr/glossary.md#cell
[41]: ../../../../adr/glossary.md#lit-cell
[42]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[43]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
