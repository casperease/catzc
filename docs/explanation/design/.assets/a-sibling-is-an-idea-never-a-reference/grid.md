---
catzc:
  immutable:
    with_body_sha: fd375f6a82b8
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
4 of 342 cells lit, holding 34 files.
```

![The world-map minimap of A sibling is an idea, never a reference](grid.png)

This is the world-map minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][36], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights every cell of the world map that holds a file citing those codes, so it shows where
the decision lives in the repository. Each lit cell has its reason below, naming the code that selects it.

## What the minimap shows

The grid crosses the 18 tracks (rows) with the 19 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (288 of the 342 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 14 lit of 89 files
- docs × markdown: 17 lit of 2763 files
- pipelines × pipeline-yaml: 1 lit of 14 files
- pwsh × yaml: 2 lit of 115 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (14 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file
language markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [.claude/CLAUDE.md][4]: selected by [ADR-AUTO-GO][1]: the file cites it at line 59 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 61 (text) and line 146 (text).
- [.claude/plans/decisions-2026-10-16.md][5]: selected by [ADR-AUTO-GO][1]: the file cites it at line 45 (text).
- [.claude/plans/decisions-2026-10-18.md][6]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 36 (text) and line 39 (text).
- [.claude/plans/plan-adr-code-language.md][7]: selected by [ADR-AUTO-GO][1]: the file cites it at line 73 (text) and line 110 (text);
  selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 110 (text) and line 225 (text).
- [.claude/plans/plan-assert-wait.md][8]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 67 (text), line 72 (text), line 76
  (text) and line 143 (text).
- [.claude/plans/plan-automation-word-residue.md][9]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text) and line 380
  (text).
- [.claude/plans/plan-diagram-folders.md][10]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 40 (text), line 73 (text) and
  line 80 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][11]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 104 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][12]: selected by [ADR-AUTO-GO][1]: the file cites it at line 251 (text);
  selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 102 (text).
- [.claude/plans/prompt-diagram-folders-1-kit-and-commands.md][13]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 19 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][14]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 15 (text).
- [.claude/plans/questionnaire-2026-10-16.md][15]: selected by [ADR-AUTO-GO][1]: the file cites it at line 154 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 504 (text) and line 603 (text).
- [.claude/plans/task-diagram-folders.md][16]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 57 (text).
- [.claude/plans/value-of-plan.md][17]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 38 (text).

### docs × markdown (17 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.md` names the file language
markdown ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [docs/adr/automation/dora-explains.md][18]: selected by [ADR-AUTO-GO][1]: the file cites it at line 563 (text).
- [docs/adr/automation/go/go-test-artifacts.md][1]: selected by [ADR-AUTO-GO][1]: the ADR's own file.
- [docs/adr/index.md][19]: selected by [ADR-AUTO-GO][1]: the file cites it at line 182 (text); selected by [ADR-PRIN-ONELIVE][2]: the file
  cites it at line 74 (text).
- [docs/adr/principles/dora-explains.md][20]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 84 (text).
- [docs/adr/principles/one-living-version.md][2]: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.
- [docs/how-to/getting-started/automation/go/index.md][21]: selected by [ADR-AUTO-GO][1]: the file cites it at line 4 (text).
- [docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md][22]: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text).
- [docs/references/adr-terminology-key.md][23]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 8 (text) and line 11 (text).
- [docs/references/agent-contracts.md][24]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 28 (text).
- [docs/references/note-file-kind.md][25]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 37 (text).
- [docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md][26]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md][27]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 26
  (text).
- [docs/references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md][28]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at
  line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md][29]: selected by [ADR-AUTO-GO][1]: the file cites it at line 15
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][30]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16
  (text).
- [docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md][31]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md][32]: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 17 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yaml` names the
file language pipeline-yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pipelines/ci-automation.yaml][33]: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing itself carries its globset's citations,
  which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 149 (text) and `pwsh/Catzc.Base.Git/configs/gitignore.yml` line 101 (text);
  selected by [ADR-PRIN-ONELIVE][2]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 34 (text).

### pwsh × yaml (2 lit files)

Placed: the root folder `pwsh/` names the track pwsh ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER][3]); the extension `.yml` names the file
language yaml ([ADR-DSGN-TRACK-FILELANGUAGE][3]). Lit ([ADR-DSGN-TRACK-LITCELL][3]) by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][34]: selected by [ADR-AUTO-GO][1]: the file cites it at line 149 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text).
- [pwsh/Catzc.Base.Git/configs/gitignore.yml][35]: selected by [ADR-AUTO-GO][1]: the file cites it at line 101 (text).

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
- [yaml][43]: a file language

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
[19]: ../../../../adr/index.md
[20]: ../../../../adr/principles/dora-explains.md
[21]: ../../../../how-to/getting-started/automation/go/index.md
[22]: ../../../../references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md
[23]: ../../../../references/adr-terminology-key.md
[24]: ../../../../references/agent-contracts.md
[25]: ../../../../references/note-file-kind.md
[26]: ../../../../references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
[27]: ../../../../references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
[28]: ../../../../references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
[29]: ../../../../references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
[30]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[31]: ../../../../references/pwsh/internal/Catzc.Internal.Loader.psm1.md
[32]: ../../../../references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
[33]: ../../../../../pipelines/ci-automation.yaml
[34]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[35]: ../../../../../pwsh/Catzc.Base.Git/configs/gitignore.yml
[36]: ../../a-sibling-is-an-idea-never-a-reference.md
[37]: ../../../../adr/glossary.md#world-map
[38]: ../../../../adr/glossary.md#track
[39]: ../../../../adr/glossary.md#file-language
[40]: ../../../../adr/glossary.md#cell
[41]: ../../../../adr/glossary.md#lit-cell
[42]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[43]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
