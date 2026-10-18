---
catzc:
  immutable:
    with_body_sha: "0a37cd82dfd9"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.tree.md
    source: docs/explanation/.assets/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Two variables, one reader, 24 callers, and one analyzer rule for every other read: the tree minimap

```text
Which files cite ADR-FLOW-CD-DETECT: every file of the world map is a tile, grouped by top-level folder.
11 files lit in 6 groups.
```

![The tree minimap of Two variables, one reader, 24 callers, and one analyzer rule for every other read](adr-flow-cd-detect--two-variables-read-in-one-place--implementation.tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Two variables, one reader, 24 callers, and one analyzer rule for
every other read][12], which explains [ADR-FLOW-CD-DETECT][1]. It lights every file that cites those codes, grouped by folder, so it shows
which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 11 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/flow (docs/adr/flow): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][2], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 55 (text).
- [docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 58 (text).
- [docs/references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md][4], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 15 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][5], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 26 (text) and line 109 (text).
- [docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-DETECT][1]: the file cites it at line 11 (text).

### adr/flow (docs/adr/flow, 2 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/dora-explains.md][7], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 49
  (text).
- [docs/adr/flow/pipeline-detection.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][8], in the cell automation × yaml: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at
  line 99 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][9], in the cell automation × yaml: selected by [ADR-FLOW-CD-DETECT][1]:
  the file cites it at line 11 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][10], in the cell docs × markdown: selected by [ADR-FLOW-CD-DETECT][1]: the file cites it at line 131 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][11], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-DETECT][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 99 (text) and
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 11 (text).

## Keywords

- [world map][13]
- [track][14]
- [file language][15]
- [cell][16]
- [lit cell][17]
- [automation][18]: a track
- [docs][18]: a track
- [pipelines][18]: a track
- [markdown][19]: a file language
- [pipeline-yaml][19]: a file language
- [yaml][19]: a file language

[1]: ../../../adr/flow/pipeline-detection.md
[2]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[3]: ../../../references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
[4]: ../../../references/automation/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
[5]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[6]: ../../../references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
[7]: ../../../adr/flow/dora-explains.md
[8]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[9]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[10]: ../../../adr/index.md
[11]: ../../../../pipelines/ci-automation.yaml
[12]: ../../flow/two-variables-read-in-one-place.md
[13]: ../../../adr/glossary.md#world-map
[14]: ../../../adr/glossary.md#track
[15]: ../../../adr/glossary.md#file-language
[16]: ../../../adr/glossary.md#cell
[17]: ../../../adr/glossary.md#lit-cell
[18]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[19]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
