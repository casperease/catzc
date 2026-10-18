---
catzc:
  immutable:
    with_body_sha: e531d5f37036
    repo_status: locked
    path: docs/explanation/repository/.assets/an-edit-lands-at-the-next-import/tree.md
    source: docs/explanation/repository/.assets/an-edit-lands-at-the-next-import/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# An edit to a variant lands at the next import, and a wrong value fails once, at load: the tree minimap

```text
Which files cite ADR-REPO-VARIANT: every file of the world map is a tile, grouped by top-level folder.
14 files lit in 7 groups.
```

![The tree minimap of An edit to a variant lands at the next import, and a wrong value fails once, at load](tree.png)

This is the tree minimap in the sidebar of the operations diagram of [An edit to a variant lands at the next import, and a wrong value fails
once, at load][15], which explains [ADR-REPO-VARIANT][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 14 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- .claude: 3 lit files
- adr/repo (docs/adr/repository): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- ModuleSystem (pwsh/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md][2], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][1]: the file cites it at line 39 (text).
- [docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][1]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][5], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the
  file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][6], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]:
  the file cites it at line 11 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][7], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at
  line 125 (text).
- [.claude/plans/prompt-drift-gaps-1-aspect-move.md][8], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites
  it at line 13 (text).
- [.claude/plans/task-explanation-drift-gaps.md][9], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at
  line 35 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][10], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 165
  (text).
- [docs/adr/repository/repo-variants.md][1], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][11], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 327 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][12], in the cell pipelines × pipeline-yaml: selected by [ADR-REPO-VARIANT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text) and
  `pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 44 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][13], in the cell pwsh × yaml: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 303
  (text).

### ModuleSystem (pwsh/Catzc.Base.ModuleSystem, 1 lit file)

The group holds the files of pwsh/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][14], in the cell pwsh × powershell: selected by [ADR-REPO-VARIANT][1]: the file
  cites it at line 44 (text).

## Keywords

- [world map][16]
- [track][17]
- [file language][18]
- [cell][19]
- [lit cell][20]
- [.claude][21]: a track
- [docs][21]: a track
- [pipelines][21]: a track
- [pwsh][21]: a track
- [markdown][22]: a file language
- [pipeline-yaml][22]: a file language
- [powershell][22]: a file language
- [yaml][22]: a file language

[1]: ../../../../adr/repository/repo-variants.md
[2]: ../../../../references/pwsh/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
[3]: ../../../../references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
[4]: ../../../../references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
[5]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[6]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[7]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[8]: ../../../../../.claude/plans/prompt-drift-gaps-1-aspect-move.md
[9]: ../../../../../.claude/plans/task-explanation-drift-gaps.md
[10]: ../../../../adr/repository/dora-explains.md
[11]: ../../../../adr/index.md
[12]: ../../../../../pipelines/ci-automation.yaml
[13]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../../../../pwsh/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[15]: ../../an-edit-lands-at-the-next-import.md
[16]: ../../../../adr/glossary.md#world-map
[17]: ../../../../adr/glossary.md#track
[18]: ../../../../adr/glossary.md#file-language
[19]: ../../../../adr/glossary.md#cell
[20]: ../../../../adr/glossary.md#lit-cell
[21]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[22]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
