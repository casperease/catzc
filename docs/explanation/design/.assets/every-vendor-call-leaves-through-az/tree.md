---
catzc:
  immutable:
    with_body_sha: ad766b1ed219
    repo_status: locked
    path: docs/explanation/design/.assets/every-vendor-call-leaves-through-az/tree.md
    source: docs/explanation/design/.assets/every-vendor-call-leaves-through-az/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every vendor call leaves cats through the az CLI: the tree minimap

```text
Which files cite ADR-AZ-CLI and ADR-DSGN-THINPLAT: every file of the world map is a tile, grouped by top-level folder.
9 files lit in 7 groups.
```

![The tree minimap of Every vendor call leaves cats through the az CLI](tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Every vendor call leaves cats through the az CLI][10], which
explains [ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 9 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/azure (docs/adr/azure): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- .claude: 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 94 (text).
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 27
  (text).
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-explanation-drift-gaps.md][5], in the cell .claude × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line
  114 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][6], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 285 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 111 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][7], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-CLI][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 258 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 551 (text); selected by [ADR-DSGN-THINPLAT][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 75 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][8], in the cell pwsh × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line 258 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 75 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][9], in the cell pwsh × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  551 (text).

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

[1]: ../../../../adr/azure/prefer-az-cli.md
[2]: ../../../../adr/design/thin-platforms.md
[3]: ../../../../adr/azure/dora-explains.md
[4]: ../../../../adr/design/dora-explains.md
[5]: ../../../../../.claude/plans/plan-explanation-drift-gaps.md
[6]: ../../../../adr/index.md
[7]: ../../../../../pipelines/ci-automation.yaml
[8]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[10]: ../../every-vendor-call-leaves-through-az.md
[11]: ../../../../adr/glossary.md#world-map
[12]: ../../../../adr/glossary.md#track
[13]: ../../../../adr/glossary.md#file-language
[14]: ../../../../adr/glossary.md#cell
[15]: ../../../../adr/glossary.md#lit-cell
[16]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[17]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
