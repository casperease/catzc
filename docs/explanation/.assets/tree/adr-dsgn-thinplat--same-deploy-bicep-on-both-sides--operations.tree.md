---
catzc:
  immutable:
    with_body_sha: a016298c25f2
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
    source: docs/explanation/.assets/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription: the tree minimap

```text
Which files cite ADR-DSGN-THINPLAT: every file of the world map is a tile, grouped by top-level folder.
6 files lit in 5 groups.
```

![The tree minimap of A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [A developer and a pipeline type the same Deploy-Bicep; only the
pipeline must pin the subscription][7], which explains [ADR-DSGN-THINPLAT][1]. It lights every file that cites those codes, grouped by
folder, so it shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 6 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 2 lit files
- Docs (pwsh/Catzc.Base.Docs): 1 lit file
- QualityGates (pwsh/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 27
  (text).
- [docs/adr/design/thin-platforms.md][1], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the ADR's own file.

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][3], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at
  line 75 (text).

### QualityGates (pwsh/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of pwsh/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.QualityGates/configs/terminology.yml][4], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 657 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][5], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 109 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][6], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-THINPLAT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 75 (text) and
  `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` line 657 (text).

## Keywords

- [world map][8]
- [track][9]
- [file language][10]
- [cell][11]
- [lit cell][12]
- [automation][13]: a track
- [docs][13]: a track
- [pipelines][13]: a track
- [markdown][14]: a file language
- [pipeline-yaml][14]: a file language
- [yaml][14]: a file language

[1]: ../../../adr/design/thin-platforms.md
[2]: ../../../adr/design/dora-explains.md
[3]: ../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[4]: ../../../../pwsh/Catzc.Base.QualityGates/configs/terminology.yml
[5]: ../../../adr/index.md
[6]: ../../../../pipelines/ci-automation.yaml
[7]: ../../design/same-deploy-bicep-on-both-sides.md
[8]: ../../../adr/glossary.md#world-map
[9]: ../../../adr/glossary.md#track
[10]: ../../../adr/glossary.md#file-language
[11]: ../../../adr/glossary.md#cell
[12]: ../../../adr/glossary.md#lit-cell
[13]: ../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[14]: ../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
