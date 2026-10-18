---
catzc:
  immutable:
    with_body_sha: d86880f7eb42
    repo_status: locked
    path: docs/explanation/.assets/grid/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.grid.md
    source: docs/explanation/.assets/adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A sibling is an idea, never a reference: the world-map minimap

```text
Where the files that cite ADR-AUTO-GO and ADR-PRIN-ONELIVE sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 64 files.
```

![The world-map minimap of A sibling is an idea, never a reference](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][68], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights every cell of the world map that holds a file citing those codes, so it shows where
the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 16 lit of 90 files
- automation × csharp: 2 lit of 289 files, touched
- automation × powershell: 4 lit of 1629 files
- automation × yaml: 6 lit of 112 files
- docs × markdown: 35 lit of 2742 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (16 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-AUTO-GO][1]: the file cites it at line 59 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 61 (text) and line 143 (text).
- [.claude/plans/decisions-2026-10-16.md][7]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 114 (text) and line 160 (text).
- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][8]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 104 (text) and
  line 326 (text).
- [.claude/plans/plan-assert-wait.md][9]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text), line 77 (text), line 81
  (text) and line 143 (text).
- [.claude/plans/plan-bounded-folder-enumeration.md][10]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 166 (text), line 208
  (text) and line 348 (text).
- [.claude/plans/plan-config-defaults.md][11]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 62 (text) and line 154 (text).
- [.claude/plans/plan-file-head-immutable-edges-classes.md][12]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 147 (text),
  line 279 (text) and line 388 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][13]: selected by [ADR-AUTO-GO][1]: the file cites it at line 399 (text) and
  line 733 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 104 (text), line 229 (text) and line 681 (text).
- [.claude/plans/plan-materialization-of-knowledge.md][14]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 27 (text).
- [.claude/plans/plan-module-kinds-tracks.md][15]: selected by [ADR-AUTO-GO][1]: the file cites it at line 302 (text) and line 448 (text);
  selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 223 (text), line 264 (text), line 404 (text), line 532 (text), line 571
  (text), line 673 (text) and line 1039 (text).
- [.claude/plans/prompt-automation-layers-continue.md][16]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 56 (text).
- [.claude/plans/prompt-config-defaults-continue.md][17]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 56 (text).
- [.claude/plans/prompt-k8s-kinds-1-prepare.md][18]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 20 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][19]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 21 (text).
- [.claude/plans/questionnaire-2026-10-16.md][20]: selected by [ADR-AUTO-GO][1]: the file cites it at line 154 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 504 (text) and line 603 (text).
- [.claude/plans/task-adr-auto-material.md][21]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 26 (text).

### automation × csharp (2 lit files, touched)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs][22]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 5 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs][23]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 12 (body comment)
  (a passing mention only).

### automation × powershell (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][24]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][25]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text).
- [pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][26]: selected by [ADR-AUTO-GO][1]: the file cites it at line 75
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1][27]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1
  (header).

### automation × yaml (6 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][28]: selected by [ADR-AUTO-GO][1]: the file cites it at line 149 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][29]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 60 (body comment) and line 66
  (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][30]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 87 (text) and line 92
  (text).
- [pwsh/Catzc.Base.Git/configs/gitignore.yml][31]: selected by [ADR-AUTO-GO][1]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][32]: selected by [ADR-AUTO-GO][1]: the file cites it at line 16 (text).
- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][33]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 555 (text).

### docs × markdown (35 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/automation/dora-explains.md][34]: selected by [ADR-AUTO-GO][1]: the file cites it at line 563 (text).
- [docs/adr/automation/go/go-test-artifacts.md][1]: selected by [ADR-AUTO-GO][1]: the ADR's own file.
- [docs/adr/glossary.md][35]: selected by [ADR-AUTO-GO][1]: the file cites it at line 659 (text).
- [docs/adr/index.md][36]: selected by [ADR-AUTO-GO][1]: the file cites it at line 180 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 72 (text).
- [docs/adr/principles/dora-explains.md][37]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 84 (text).
- [docs/adr/principles/one-living-version.md][2]: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.
- [docs/how-to/getting-started/automation/go/index.md][38]: selected by [ADR-AUTO-GO][1]: the file cites it at line 4 (text).
- [docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md][39]: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text).
- [docs/references/agent-contracts.md][40]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 28 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][41]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 8 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][42]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md][43]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md][44]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][45]: selected by [ADR-AUTO-GO][1]: the file cites it at line 20 (text)
  and line 82 (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md][46]: selected by [ADR-AUTO-GO][1]: the file cites it at line 100 (text).
- [docs/references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md][47]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md][48]: selected by [ADR-AUTO-GO][1]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md][49]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md][50]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md][51]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][52]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md][53]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][54]: selected by [ADR-AUTO-GO][1]: the file cites it
  at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md][55]: selected by [ADR-AUTO-GO][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md][56]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md][57]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md][58]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md][59]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][60]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md][61]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 73 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md][62]: selected by [ADR-AUTO-GO][1]: the file cites it at line 182
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][63]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md][64]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md][65]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text).
- [docs/references/note-file-kind.md][66]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 37 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/ci-automation.yaml][67]: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 149 (text), `pwsh/Catzc.Base.Git/configs/gitignore.yml` line 101 (text),
  `pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 45 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml` line 16 (text)
  and `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 75 (text); selected by [ADR-PRIN-ONELIVE][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 34 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 60 (body comment), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 66 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 87 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 92 (text),
  `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 555
  (text), `pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1` line 1 (header),
  `pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs` line 5 (body comment) and `pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs`
  line 12 (body comment).

## Keywords

- [world map][69]
- [track][70]
- [file language][71]
- [cell][72]
- [lit cell][73]
- [.claude][74]: a track
- [automation][74]: a track
- [docs][74]: a track
- [pipelines][74]: a track
- [csharp][75]: a file language
- [markdown][75]: a file language
- [pipeline-yaml][75]: a file language
- [powershell][75]: a file language
- [yaml][75]: a file language

Terms the cited ADRs define:

- [go test module][76], defined by [ADR-AUTO-GO#2][77]

[1]: ../../../../adr/automation/go/go-test-artifacts.md
[2]: ../../../../adr/principles/one-living-version.md
[3]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../../../.claude/CLAUDE.md
[7]: ../../../../../.claude/plans/decisions-2026-10-16.md
[8]: ../../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[9]: ../../../../../.claude/plans/plan-assert-wait.md
[10]: ../../../../../.claude/plans/plan-bounded-folder-enumeration.md
[11]: ../../../../../.claude/plans/plan-config-defaults.md
[12]: ../../../../../.claude/plans/plan-file-head-immutable-edges-classes.md
[13]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[14]: ../../../../../.claude/plans/plan-materialization-of-knowledge.md
[15]: ../../../../../.claude/plans/plan-module-kinds-tracks.md
[16]: ../../../../../.claude/plans/prompt-automation-layers-continue.md
[17]: ../../../../../.claude/plans/prompt-config-defaults-continue.md
[18]: ../../../../../.claude/plans/prompt-k8s-kinds-1-prepare.md
[19]: ../../../../../.claude/plans/prompt-module-model-1-prepare.md
[20]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[21]: ../../../../../.claude/plans/task-adr-auto-material.md
[22]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs
[23]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs
[24]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[25]: ../../../../../pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[26]: ../../../../../pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[27]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
[28]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[30]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[31]: ../../../../../pwsh/Catzc.Base.Git/configs/gitignore.yml
[32]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[33]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[34]: ../../../../adr/automation/dora-explains.md
[35]: ../../../../adr/glossary.md
[36]: ../../../../adr/index.md
[37]: ../../../../adr/principles/dora-explains.md
[38]: ../../../../how-to/getting-started/automation/go/index.md
[39]: ../../../../references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md
[40]: ../../../../references/agent-contracts.md
[41]: ../../../../references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[42]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[43]: ../../../../references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
[44]: ../../../../references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
[45]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[46]: ../../../../references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md
[47]: ../../../../references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
[48]: ../../../../references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md
[49]: ../../../../references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md
[50]: ../../../../references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md
[51]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md
[52]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[53]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
[54]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[55]: ../../../../references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
[56]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
[57]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
[58]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
[59]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md
[60]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[61]: ../../../../references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md
[62]: ../../../../references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md
[63]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[64]: ../../../../references/pwsh/internal/Catzc.Internal.Loader.psm1.md
[65]: ../../../../references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
[66]: ../../../../references/note-file-kind.md
[67]: ../../../../../pipelines/ci-automation.yaml
[68]: ../../a-sibling-is-an-idea-never-a-reference.md
[69]: ../../../../adr/glossary.md#world-map
[70]: ../../../../adr/glossary.md#track
[71]: ../../../../adr/glossary.md#file-language
[72]: ../../../../adr/glossary.md#cell
[73]: ../../../../adr/glossary.md#lit-cell
[74]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[75]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
[76]: ../../../../adr/glossary.md#go-test-module
[77]: ../../../../adr/automation/go/go-test-artifacts.md#rule-adr-auto-go2
