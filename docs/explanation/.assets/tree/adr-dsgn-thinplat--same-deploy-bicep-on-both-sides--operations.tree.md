# docs/explanation/.assets/tree/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md

`Tree minimap: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations`

![Tree minimap of adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations` (operations lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 8 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (2 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-concern-axis.md][2], in the cell .unordered × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it
  at line 88 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][3], in the cell .unordered × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 81 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 67
  (text).
- [docs/adr/design/thin-platforms.md][1], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at
  line 93 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][6], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 671 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][7], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 107 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][8], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-THINPLAT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 93 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 671 (text).

## Keywords

- [world map][9]
- [track][10]
- [file language][11]
- [cell][12]
- [lit cell][13]
- [.unordered][14]: a track
- [automation][14]: a track
- [docs][14]: a track
- [pipelines][14]: a track
- [markdown][15]: a file language
- [pipeline-yaml][15]: a file language
- [yaml][15]: a file language

[1]: ../../../adr/design/thin-platforms.md
[2]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[3]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[4]: ../../../adr/design/dora-explains.md
[5]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[7]: ../../../adr/index.md
[8]: ../../../../pipelines/ci-automation.yaml
[9]: ../../../adr/glossary.md#world-map
[10]: ../../../adr/glossary.md#track
[11]: ../../../adr/glossary.md#file-language
[12]: ../../../adr/glossary.md#cell
[13]: ../../../adr/glossary.md#lit-cell
[14]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[15]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
