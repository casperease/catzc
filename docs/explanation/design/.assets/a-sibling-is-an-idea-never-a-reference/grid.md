---
catzc:
  immutable:
    with_body_sha: "8b43752a880a"
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
6 of 342 cells lit, holding 62 files.
```

![The world-map minimap of A sibling is an idea, never a reference](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][64], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights every cell of the world map that holds a file citing those codes, so it shows where
the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 14 lit of 89 files
- docs × markdown: 36 lit of 2767 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × csharp: 2 lit of 293 files, touched
- pwsh × powershell: 4 lit of 1651 files
- pwsh × yaml: 5 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (14 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-GO][1]: the file cites it at line 59 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 61 (text) and line 146 (text).
- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 114 (text) and line 160 (text).
- [.claude/plans/decisions-2026-10-18.md][6]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 36 (text) and line 39 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-AUTO-GO][1]: the file cites it at line 73 (text), line 110 (text) and line
  110 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 110 (text), line 110 (text), line 110 (text) and line 226 (text).
- [.claude/plans/plan-assert-wait.md][8]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 67 (text), line 72 (text), line 76
  (text) and line 143 (text).
- [.claude/plans/plan-automation-word-residue.md][9]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text) and line 380
  (text).
- [.claude/plans/plan-diagram-folders.md][10]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 40 (text), line 73 (text) and
  line 80 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][11]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 104 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][12]: selected by [ADR-AUTO-GO][1]: the file cites it at line 252 (text);
  selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 102 (text).
- [.claude/plans/prompt-diagram-folders-1-kit-and-commands.md][13]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 19 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][14]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 15 (text).
- [.claude/plans/questionnaire-2026-10-16.md][15]: selected by [ADR-AUTO-GO][1]: the file cites it at line 154 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 504 (text) and line 603 (text).
- [.claude/plans/task-diagram-folders.md][16]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][17]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 38 (text).

### docs × markdown (36 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][18]: selected by [ADR-AUTO-GO][1]: the file cites it at line 563 (text).
- [docs/adr/automation/go/go-test-artifacts.md][1]: selected by [ADR-AUTO-GO][1]: the ADR's own file.
- [docs/adr/glossary.md][19]: selected by [ADR-AUTO-GO][1]: the file cites it at line 688 (text).
- [docs/adr/index.md][20]: selected by [ADR-AUTO-GO][1]: the file cites it at line 180 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 72 (text).
- [docs/adr/principles/dora-explains.md][21]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 84 (text).
- [docs/adr/principles/one-living-version.md][2]: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.
- [docs/how-to/getting-started/automation/go/index.md][22]: selected by [ADR-AUTO-GO][1]: the file cites it at line 4 (text).
- [docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md][23]: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text).
- [docs/references/adr-terminology-key.md][24]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 8 (text) and line 11 (text).
- [docs/references/agent-contracts.md][25]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 28 (text).
- [docs/references/note-file-kind.md][26]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md][27]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 8 (text).
- [docs/references/pwsh/catzc-base-docs/types/CheckModes.cs.md][28]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 13 (text).
- [docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md][29]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md][30]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md][31]: selected by [ADR-AUTO-GO][1]: the file cites it at line 20 (text)
  and line 82 (text).
- [docs/references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md][32]: selected by [ADR-AUTO-GO][1]: the file cites it at line 100 (text).
- [docs/references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md][33]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md][34]: selected by [ADR-AUTO-GO][1]: the file cites it at line
  16 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md][35]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md][36]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md][37]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/configs/comments.yml.md][38]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  15 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md][39]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 17 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md][40]: selected by [ADR-AUTO-GO][1]: the file cites it
  at line 20 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md][41]: selected by [ADR-AUTO-GO][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md][42]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md][43]: selected by [ADR-PRIN-ONELIVE][2]: the file cites
  it at line 14 (text).
- [docs/references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md][44]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 12 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md][45]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 13 (text).
- [docs/references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md][46]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 15 (text).
- [docs/references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md][47]: selected by [ADR-AUTO-GO][1]: the file cites
  it at line 73 (text).
- [docs/references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md][48]: selected by [ADR-AUTO-GO][1]: the file cites it at line 182
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][49]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md][50]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md][51]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][52]: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 149 (text), `pwsh/Catzc.Base.Git/configs/gitignore.yml` line 101 (text),
  `pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 45 (text), `pwsh/Catzc.Base.Languages/configs/glossary.yml` line 16 (text)
  and `pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1` line 73 (text); selected by [ADR-PRIN-ONELIVE][2]: a pipeline that
  cites nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 34 (text),
  `pwsh/Catzc.Base.Docs/configs/agents.yml` line 60 (text), `pwsh/Catzc.Base.Docs/configs/agents.yml` line 66 (text),
  `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 87 (text), `pwsh/Catzc.Base.Docs/configs/capabilities.yml` line 92 (text),
  `pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1` line 1 (text), `pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1`
  line 1 (header), `pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs` line 5 (body comment) and
  `pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs` line 12 (body comment).

### pwsh × csharp (2 lit files, touched)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.cs` names the file language
csharp ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs][53]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 5 (body
  comment) (a passing mention only).
- [pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs][54]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 12 (body comment)
  (a passing mention only).

### pwsh × powershell (4 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1][55]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1 (text).
- [pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][56]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text).
- [pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1][57]: selected by [ADR-AUTO-GO][1]: the file cites it at line 73
  (text).
- [pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1][58]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 1
  (header).

### pwsh × yaml (5 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][59]: selected by [ADR-AUTO-GO][1]: the file cites it at line 149 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text).
- [pwsh/Catzc.Base.Docs/configs/agents.yml][60]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 60 (text) and line 66 (text).
- [pwsh/Catzc.Base.Docs/configs/capabilities.yml][61]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 87 (text) and line 92
  (text).
- [pwsh/Catzc.Base.Git/configs/gitignore.yml][62]: selected by [ADR-AUTO-GO][1]: the file cites it at line 101 (text).
- [pwsh/Catzc.Base.Languages/configs/glossary.yml][63]: selected by [ADR-AUTO-GO][1]: the file cites it at line 16 (text).

## Keywords

- [world map][65]
- [track][66]
- [file language][67]
- [cell][68]
- [lit cell][69]
- [.claude][70]: a track
- [docs][70]: a track
- [pipelines][70]: a track
- [pwsh][70]: a track
- [csharp][71]: a file language
- [markdown][71]: a file language
- [pipeline-yaml][71]: a file language
- [powershell][71]: a file language
- [yaml][71]: a file language

[1]: ../../../../adr/automation/go/go-test-artifacts.md
[2]: ../../../../adr/principles/one-living-version.md
[3]: ../../../../adr/design/tracks.md
[4]: ../../../../../.claude/CLAUDE.md
[5]: ../../../../../.claude/plans/decisions-2026-10-16.md
[6]: ../../../../../.claude/plans/decisions-2026-10-18.md
[7]: ../../../../../.claude/plans/plan-adr-code-language.md
[8]: ../../../../../.claude/plans/plan-assert-wait.md
[9]: ../../../../../.claude/plans/plan-automation-word-residue.md
[10]: ../../../../../.claude/plans/plan-diagram-folders.md
[11]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[12]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[13]: ../../../../../.claude/plans/prompt-diagram-folders-1-kit-and-commands.md
[14]: ../../../../../.claude/plans/prompt-diagram-folders-2-adrs.md
[15]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[16]: ../../../../../.claude/plans/task-diagram-folders.md
[17]: ../../../../../.claude/plans/value-of-plan.md
[18]: ../../../../adr/automation/dora-explains.md
[19]: ../../../../adr/glossary.md
[20]: ../../../../adr/index.md
[21]: ../../../../adr/principles/dora-explains.md
[22]: ../../../../how-to/getting-started/automation/go/index.md
[23]: ../../../../references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md
[24]: ../../../../references/adr-terminology-key.md
[25]: ../../../../references/agent-contracts.md
[26]: ../../../../references/note-file-kind.md
[27]: ../../../../references/pwsh/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
[28]: ../../../../references/pwsh/catzc-base-docs/types/CheckModes.cs.md
[29]: ../../../../references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
[30]: ../../../../references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
[31]: ../../../../references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[32]: ../../../../references/pwsh/catzc-base-languages/Invoke-GoTest.ps1.md
[33]: ../../../../references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
[34]: ../../../../references/pwsh/catzc-base-languages/private/Get-EngineContract.ps1.md
[35]: ../../../../references/pwsh/catzc-base-qualitygates/Build-CommentView.ps1.md
[36]: ../../../../references/pwsh/catzc-base-qualitygates/Export-Comments.ps1.md
[37]: ../../../../references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md
[38]: ../../../../references/pwsh/catzc-base-qualitygates/configs/comments.yml.md
[39]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
[40]: ../../../../references/pwsh/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
[41]: ../../../../references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
[42]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Build-CommentView.Tests.ps1.md
[43]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Export-Comments.Tests.ps1.md
[44]: ../../../../references/pwsh/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
[45]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentPageMap.cs.md
[46]: ../../../../references/pwsh/catzc-base-qualitygates/types/CommentsConfig.cs.md
[47]: ../../../../references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md
[48]: ../../../../references/pwsh/catzc-base-vscode/configs/vscode-settings.yml.md
[49]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[50]: ../../../../references/pwsh/internal/Catzc.Internal.Loader.psm1.md
[51]: ../../../../references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
[52]: ../../../../../pipelines/ci-automation.yaml
[53]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentBlockKind.cs
[54]: ../../../../../pwsh/Catzc.Base.QualityGates/types/CommentEngine.cs
[55]: ../../../../../pwsh/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
[56]: ../../../../../pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[57]: ../../../../../pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
[58]: ../../../../../pwsh/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
[59]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[60]: ../../../../../pwsh/Catzc.Base.Docs/configs/agents.yml
[61]: ../../../../../pwsh/Catzc.Base.Docs/configs/capabilities.yml
[62]: ../../../../../pwsh/Catzc.Base.Git/configs/gitignore.yml
[63]: ../../../../../pwsh/Catzc.Base.Languages/configs/glossary.yml
[64]: ../../a-sibling-is-an-idea-never-a-reference.md
[65]: ../../../../adr/glossary.md#world-map
[66]: ../../../../adr/glossary.md#track
[67]: ../../../../adr/glossary.md#file-language
[68]: ../../../../adr/glossary.md#cell
[69]: ../../../../adr/glossary.md#lit-cell
[70]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[71]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
