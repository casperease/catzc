---
catzc:
  immutable:
    with_body_sha: "9a1653857b55"
    repo_status: locked
    path: docs/explanation/design/.assets/four-domains-promote-one-artifact/tree.md
    source: docs/explanation/design/.assets/four-domains-promote-one-artifact/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Four pipeline kinds promote one artifact that CI built once: the tree minimap

```text
Which files cite ADR-DSGN-LIFE: every file of the world map is a tile, grouped by top-level folder.
9 files lit in 5 groups.
```

![The tree minimap of Four pipeline kinds promote one artifact that CI built once](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Four pipeline kinds promote one artifact that CI built once][10],
which explains [ADR-DSGN-LIFE][1]. It lights every file that cites those codes, grouped by folder, so it shows which files carry the
decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 9 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .claude: 4 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### .claude (4 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-promotion-ladder.md][2], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12
  (text), line 34 (text) and line 94 (text).
- [.claude/plans/prompt-promotion-ladder-1-build.md][3], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 20 (text).
- [.claude/plans/task-loose-ends.md][4], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 55
  (text).
- [.claude/plans/value-of-plan.md][5], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 35 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 82 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 114 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][8], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 78 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][9], in the cell pwsh × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 78 (text).

## Keywords

- [world map][11]
- [track][12]
- [file language][13]
- [cell][14]
- [lit cell][15]
- [.claude][16]: a track
- [docs][16]: a track
- [pipelines][16]: a track
- [pwsh][16]: a track
- [markdown][17]: a file language
- [pipeline-yaml][17]: a file language
- [yaml][17]: a file language

[1]: ../../../../adr/design/commit-lifecycle.md
[2]: ../../../../../.claude/plans/plan-promotion-ladder.md
[3]: ../../../../../.claude/plans/prompt-promotion-ladder-1-build.md
[4]: ../../../../../.claude/plans/task-loose-ends.md
[5]: ../../../../../.claude/plans/value-of-plan.md
[6]: ../../../../adr/design/dora-explains.md
[7]: ../../../../adr/index.md
[8]: ../../../../../pipelines/ci-automation.yaml
[9]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../four-domains-promote-one-artifact.md
[11]: ../../../../adr/glossary.md#world-map
[12]: ../../../../adr/glossary.md#track
[13]: ../../../../adr/glossary.md#file-language
[14]: ../../../../adr/glossary.md#cell
[15]: ../../../../adr/glossary.md#lit-cell
[16]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
