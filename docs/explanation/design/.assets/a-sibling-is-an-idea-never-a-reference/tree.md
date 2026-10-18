---
catzc:
  immutable:
    with_body_sha: "69d5a10c59a7"
    repo_status: locked
    path: docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference/tree.md
    source: docs/explanation/design/.assets/a-sibling-is-an-idea-never-a-reference/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A sibling is an idea, never a reference: the tree minimap

```text
Which files cite ADR-AUTO-GO and ADR-PRIN-ONELIVE: every file of the world map is a tile, grouped by top-level folder.
34 files lit in 8 groups.
```

![The tree minimap of A sibling is an idea, never a reference](tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A sibling is an idea, never a reference][35], which explains
[ADR-AUTO-GO][1] and [ADR-PRIN-ONELIVE][2]. It lights every file that cites those codes, grouped by folder, so it shows which files carry
the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 34 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 14 lit files
- docs (docs/ outside docs/adr/): 12 lit files
- adr/auto (docs/adr/automation): 2 lit files
- adr/prin (docs/adr/principles): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- Git (pwsh/Catzc.Base.Git): 1 lit file

## Why each group is lit

### .claude (14 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][3], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 59 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 61 (text) and line 146 (text).
- [.claude/plans/decisions-2026-10-16.md][4], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 45
  (text).
- [.claude/plans/decisions-2026-10-18.md][5], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  36 (text) and line 39 (text).
- [.claude/plans/plan-adr-code-language.md][6], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 73
  (text) and line 110 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 110 (text) and line 225 (text).
- [.claude/plans/plan-assert-wait.md][7], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 67
  (text), line 72 (text), line 76 (text) and line 143 (text).
- [.claude/plans/plan-automation-word-residue.md][8], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 34 (text) and line 380 (text).
- [.claude/plans/plan-diagram-folders.md][9], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  40 (text), line 73 (text) and line 80 (text).
- [.claude/plans/plan-explanation-drift-gaps.md][10], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 104 (text).
- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][11], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file
  cites it at line 251 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 102 (text).
- [.claude/plans/prompt-diagram-folders-1-kit-and-commands.md][12], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 19 (text).
- [.claude/plans/prompt-diagram-folders-2-adrs.md][13], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it
  at line 15 (text).
- [.claude/plans/questionnaire-2026-10-16.md][14], in the cell .claude × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line
  154 (text); selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 504 (text) and line 603 (text).
- [.claude/plans/task-diagram-folders.md][15], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line
  57 (text).
- [.claude/plans/value-of-plan.md][16], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 38
  (text).

### docs (docs/ outside docs/adr/, 12 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/how-to/getting-started/automation/go/index.md][17], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at
  line 4 (text).
- [docs/references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md][18], in the cell docs ×
  markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 72 (text).
- [docs/references/adr-terminology-key.md][19], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 8
  (text) and line 11 (text).
- [docs/references/agent-contracts.md][20], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 28
  (text).
- [docs/references/note-file-kind.md][21], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 37
  (text).
- [docs/references/pwsh/catzc-base-files/Get-InputStamp.ps1.md][22], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 23 (text).
- [docs/references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md][23], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]:
  the file cites it at line 26 (text).
- [docs/references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md][24], in the cell docs × markdown: selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 21 (text).
- [docs/references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md][25], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]:
  the file cites it at line 15 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Importer.psm1.md][26], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md][27], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 16 (text).
- [docs/references/pwsh/internal/Catzc.Internal.Vendor.psm1.md][28], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the
  file cites it at line 17 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][29], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 563
  (text).
- [docs/adr/automation/go/go-test-artifacts.md][1], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the ADR's own file.

### adr/prin (docs/adr/principles, 2 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/dora-explains.md][30], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 84
  (text).
- [docs/adr/principles/one-living-version.md][2], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][2]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][31], in the cell docs × markdown: selected by [ADR-AUTO-GO][1]: the file cites it at line 182 (text); selected by
  [ADR-PRIN-ONELIVE][2]: the file cites it at line 74 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][32], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-GO][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 149 (text) and
  `pwsh/Catzc.Base.Git/configs/gitignore.yml` line 101 (text); selected by [ADR-PRIN-ONELIVE][2]: a pipeline that cites nothing itself
  carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 34 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][33], in the cell pwsh × yaml: selected by [ADR-AUTO-GO][1]: the file cites it at line 149 (text);
  selected by [ADR-PRIN-ONELIVE][2]: the file cites it at line 34 (text).

### Git (pwsh/Catzc.Base.Git, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Git/configs/gitignore.yml][34], in the cell pwsh × yaml: selected by [ADR-AUTO-GO][1]: the file cites it at line 101
  (text).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [.claude][41]: a track
- [docs][41]: a track
- [pipelines][41]: a track
- [pwsh][41]: a track
- [markdown][42]: a file language
- [pipeline-yaml][42]: a file language
- [yaml][42]: a file language

[1]: ../../../../adr/automation/go/go-test-artifacts.md
[2]: ../../../../adr/principles/one-living-version.md
[3]: ../../../../../.claude/CLAUDE.md
[4]: ../../../../../.claude/plans/decisions-2026-10-16.md
[5]: ../../../../../.claude/plans/decisions-2026-10-18.md
[6]: ../../../../../.claude/plans/plan-adr-code-language.md
[7]: ../../../../../.claude/plans/plan-assert-wait.md
[8]: ../../../../../.claude/plans/plan-automation-word-residue.md
[9]: ../../../../../.claude/plans/plan-diagram-folders.md
[10]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[11]: ../../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[12]: ../../../../../.claude/plans/prompt-diagram-folders-1-kit-and-commands.md
[13]: ../../../../../.claude/plans/prompt-diagram-folders-2-adrs.md
[14]: ../../../../../.claude/plans/questionnaire-2026-10-16.md
[15]: ../../../../../.claude/plans/task-diagram-folders.md
[16]: ../../../../../.claude/plans/value-of-plan.md
[17]: ../../../../how-to/getting-started/automation/go/index.md
[18]: ../../../../references/.assets/automation/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.verify.md
[19]: ../../../../references/adr-terminology-key.md
[20]: ../../../../references/agent-contracts.md
[21]: ../../../../references/note-file-kind.md
[22]: ../../../../references/pwsh/catzc-base-files/Get-InputStamp.ps1.md
[23]: ../../../../references/pwsh/catzc-base-files/Write-FileIfChanged.ps1.md
[24]: ../../../../references/pwsh/catzc-base-languages/Test-GeneratedFileCurrent.ps1.md
[25]: ../../../../references/pwsh/catzc-base-qualitygates/private/Invoke-Gofmt.ps1.md
[26]: ../../../../references/pwsh/internal/Catzc.Internal.Importer.psm1.md
[27]: ../../../../references/pwsh/internal/Catzc.Internal.Loader.psm1.md
[28]: ../../../../references/pwsh/internal/Catzc.Internal.Vendor.psm1.md
[29]: ../../../../adr/automation/dora-explains.md
[30]: ../../../../adr/principles/dora-explains.md
[31]: ../../../../adr/index.md
[32]: ../../../../../pipelines/ci-automation.yaml
[33]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../../../pwsh/Catzc.Base.Git/configs/gitignore.yml
[35]: ../../a-sibling-is-an-idea-never-a-reference.md
[36]: ../../../../adr/glossary.md#world-map
[37]: ../../../../adr/glossary.md#track
[38]: ../../../../adr/glossary.md#file-language
[39]: ../../../../adr/glossary.md#cell
[40]: ../../../../adr/glossary.md#lit-cell
[41]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[42]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
