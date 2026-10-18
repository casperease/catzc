---
catzc:
  immutable:
    with_body_sha: f952d4904d3a
    repo_status: locked
    path: docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference/grid.md
    source: docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A sibling is an idea, never a reference: the world-map minimap

```text
Where the files that cite ADR-AUTO-GO and ADR-PRIN-ONELIVE sit in the repository: tracks down, file languages across.
6 of 342 cells lit, holding 49 files.
```

![The world-map minimap of A sibling is an idea, never a reference](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][51], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights every cell of the world map that holds a file citing those codes, so it shows where
the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 61 files
- docs × markdown: 35 lit of 2781 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × csharp: 2 lit of 295 files, touched
- pwsh × powershell: 4 lit of 1653 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-GO][1]: the file cites it at line 59 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 61 (text) and line 146 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][5]: selected by [ADR-AUTO-GO][1]: the file cites it at line 118 (text).

### docs × markdown (35 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][6]: selected by [ADR-AUTO-GO][1]: the file cites it at line 563 (text).
- [docs/adr/automation/go/go-test-artifacts.md][1]: selected by [ADR-AUTO-GO][1]: the ADR's own file.
- [docs/adr/glossary.md][7]: selected by [ADR-AUTO-GO][1]: the file cites it at line 689 (text).
- [docs/adr/index.md][8]: selected by [ADR-AUTO-GO][1]: the file cites it at line 180 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 72 (text).
- [docs/adr/principles/dora-explains.md][9]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 84 (text).
- [docs/adr/principles/one-living-version.md][2]: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.
- [docs/how-to/getting-started/automation/go/index.md][10]: selected by [ADR-AUTO-GO][1]: the file cites it at line 4 (text).
- [docs/references/agent-contracts.md][11]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 28 (text).
- [docs/references/note-file-kind.md][12]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 38 (text).
- [docs/references/pwsh/.assets/tools-yml-install-dispatch/diagram.drawio.verify.md][13]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 72 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][14]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 8 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][15]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md][16]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md][17]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][18]: selected by [ADR-AUTO-GO][1]: the file cites it at line 20 (text)
  and line 82 (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md][19]: selected by [ADR-AUTO-GO][1]: the file cites it at line 100 (text).
- [docs/references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md][20]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md][21]: selected by [ADR-AUTO-GO][1]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md][22]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md][23]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md][24]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][25]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md][26]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][27]: selected by [ADR-AUTO-GO][1]: the file cites it
  at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md][28]: selected by [ADR-AUTO-GO][1]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md][29]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md][30]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md][31]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md][32]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][33]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md][34]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 73 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md][35]: selected by [ADR-AUTO-GO][1]: the file cites it at line 182
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][36]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md][37]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md][38]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][39]: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 149 (text), `pwsh/Catzc.Base.Git/configs/gitignore.yml` line 101 (text),
  `pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 45 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml` line 16 (text)
  and `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 73 (text); selected by [ADR-PRIN-ONELIVE][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 34 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 60 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 66 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 94 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 99 (text),
  `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1`
  line 1 (header), `pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs` line 5 (body comment) and
  `pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs` line 12 (body comment).

### pwsh × csharp (2 lit files, touched)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs][40]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 5 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs][41]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 12 (body comment)
  (a passing mention only).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][42]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][43]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text).
- [pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][44]: selected by [ADR-AUTO-GO][1]: the file cites it at line 73
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1][45]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1
  (header).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][46]: selected by [ADR-AUTO-GO][1]: the file cites it at line 149 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][47]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 60 (text) and line 66 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][48]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 94 (text) and line 99
  (text).
- [pwsh/Catzc.Base.Git/configs/gitignore.yml][49]: selected by [ADR-AUTO-GO][1]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][50]: selected by [ADR-AUTO-GO][1]: the file cites it at line 16 (text).

## Keywords

- [world map][52]
- [track][53]
- [file language][54]
- [cell][55]
- [lit cell][56]
- [.claude][57]: a track
- [docs][57]: a track
- [pipelines][57]: a track
- [pwsh][57]: a track
- [csharp][58]: a file language
- [markdown][58]: a file language
- [pipeline-yaml][58]: a file language
- [powershell][58]: a file language
- [yaml][58]: a file language

[1]: ../../../../adr/automation/go/go-test-artifacts.md
[2]: ../../../../adr/principles/one-living-version.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[6]: ../../../../adr/automation/dora-explains.md
[7]: ../../../../adr/glossary.md
[8]: ../../../../adr/index.md
[9]: ../../../../adr/principles/dora-explains.md
[10]: ../../../../how-to/getting-started/automation/go/index.md
[11]: ../../../../references/agent-contracts.md
[12]: ../../../../references/note-file-kind.md
[13]: ../../../../references/pwsh/.assets/tools-yml-install-dispatch/diagram.drawio.verify.md
[14]: ../../../../references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[15]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[16]: ../../../../references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
[17]: ../../../../references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
[18]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[19]: ../../../../references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md
[20]: ../../../../references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
[21]: ../../../../references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md
[22]: ../../../../references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md
[23]: ../../../../references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md
[24]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md
[25]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[26]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
[27]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[28]: ../../../../references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
[29]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
[30]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
[31]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
[32]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md
[33]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[34]: ../../../../references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md
[35]: ../../../../references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md
[36]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[37]: ../../../../references/pwsh/internal/Catzc.Internal.Loader.psm1.md
[38]: ../../../../references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
[39]: ../../../../../pipelines/ci-automation.yaml
[40]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs
[41]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs
[42]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[43]: ../../../../../pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[44]: ../../../../../pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[45]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
[46]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[47]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[48]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[49]: ../../../../../pwsh/Catzc.Base.Git/configs/gitignore.yml
[50]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[51]: ../../a-sibling-is-an-idea-never-a-reference.md
[52]: ../../../../adr/glossary.md#world-map
[53]: ../../../../adr/glossary.md#track
[54]: ../../../../adr/glossary.md#file-language
[55]: ../../../../adr/glossary.md#cell
[56]: ../../../../adr/glossary.md#lit-cell
[57]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[58]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
