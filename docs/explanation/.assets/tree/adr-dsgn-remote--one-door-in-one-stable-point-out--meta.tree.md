# docs/explanation/.assets/tree/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md

`Tree minimap: adr-dsgn-remote--one-door-in-one-stable-point-out--meta`

![Tree minimap of adr-dsgn-remote--one-door-in-one-stable-point-out--meta](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.png)

The tree minimap of the slide `adr-dsgn-remote--one-door-in-one-stable-point-out--meta` (meta lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 7 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (2 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-concern-axis.md][2], in the cell .unordered × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 92 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][3], in the cell .unordered × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites
  it at line 100 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 143
  (text).
- [docs/adr/design/server-remote-integration.md][1], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5], in the cell automation × yaml: selected by [ADR-DSGN-REMOTE][1]: the file cites it at
  line 97 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][6], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 111 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][7], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-REMOTE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 97 (text).

## Keywords

- [world map][8]
- [track][9]
- [file language][10]
- [cell][11]
- [lit cell][12]
- [.unordered][13]: a track
- [automation][13]: a track
- [docs][13]: a track
- [pipelines][13]: a track
- [markdown][14]: a file language
- [pipeline-yaml][14]: a file language
- [yaml][14]: a file language

[1]: ../../../adr/design/server-remote-integration.md
[2]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[3]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[4]: ../../../adr/design/dora-explains.md
[5]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../adr/index.md
[7]: ../../../../pipelines/ci-automation.yaml
[8]: ../../../adr/glossary.md#world-map
[9]: ../../../adr/glossary.md#track
[10]: ../../../adr/glossary.md#file-language
[11]: ../../../adr/glossary.md#cell
[12]: ../../../adr/glossary.md#lit-cell
[13]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[14]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
