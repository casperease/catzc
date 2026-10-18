---
catzc:
  immutable:
    with_body_sha: d8d8d23513ad
    repo_status: locked
    path: docs/explanation/repository/.assets/one-home-one-read-path-one-vocabulary/tree.md
    source: docs/explanation/repository/.assets/one-home-one-read-path-one-vocabulary/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A repo-wide switch has one home, one read path and one guard vocabulary: the tree minimap

```text
Which files cite ADR-REPO-VARIANT: every file of the world map is a tile, grouped by top-level folder.
12 files lit in 6 groups.
```

![The tree minimap of A repo-wide switch has one home, one read path and one guard vocabulary](tree.png)

This is the tree minimap in the sidebar of the meta diagram of [A repo-wide switch has one home, one read path and one guard
vocabulary][13], which explains [ADR-REPO-VARIANT][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 12 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 4 lit files
- .claude: 3 lit files
- adr/repo (docs/adr/repository): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 4 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md][2], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][1]: the file cites it at line 16 (text).
- [docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][1]: the file cites it at line 17 (text).
- [docs/references/pwsh/catzc-base-variants/configs/variants.yml.md][4], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the
  file cites it at line 11 (text).
- [docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md][5], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]:
  the file cites it at line 11 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][6], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at
  line 125 (text).
- [.claude/plans/prompt-drift-gaps-1-aspect-move.md][7], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites
  it at line 13 (text).
- [.claude/plans/task-explanation-drift-gaps.md][8], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at
  line 35 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][9], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 165
  (text).
- [docs/adr/repository/repo-variants.md][1], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the ADR's own file.

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][10], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 329 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][11], in the cell pipelines × pipeline-yaml: selected by [ADR-REPO-VARIANT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 303 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][12], in the cell pwsh × yaml: selected by [ADR-REPO-VARIANT][1]: the file cites it at line 303
  (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [.claude][19]: a track
- [docs][19]: a track
- [pipelines][19]: a track
- [pwsh][19]: a track
- [markdown][20]: a file language
- [pipeline-yaml][20]: a file language
- [yaml][20]: a file language

[1]: ../../../../adr/repository/repo-variants.md
[2]: ../../../../references/pwsh/catzc-base-variants/Get-AspectDeclaration.ps1.md
[3]: ../../../../references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md
[4]: ../../../../references/pwsh/catzc-base-variants/configs/variants.yml.md
[5]: ../../../../references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
[6]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[7]: ../../../../../.claude/plans/prompt-drift-gaps-1-aspect-move.md
[8]: ../../../../../.claude/plans/task-explanation-drift-gaps.md
[9]: ../../../../adr/repository/dora-explains.md
[10]: ../../../../adr/index.md
[11]: ../../../../../pipelines/ci-automation.yaml
[12]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[13]: ../../one-home-one-read-path-one-vocabulary.md
[14]: ../../../../adr/glossary.md#world-map
[15]: ../../../../adr/glossary.md#track
[16]: ../../../../adr/glossary.md#file-language
[17]: ../../../../adr/glossary.md#cell
[18]: ../../../../adr/glossary.md#lit-cell
[19]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[20]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
