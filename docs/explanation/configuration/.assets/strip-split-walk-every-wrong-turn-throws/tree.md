---
catzc:
  immutable:
    with_body_sha: "9edd7fcdcd9f"
    repo_status: locked
    path: docs/explanation/configuration/.assets/strip-split-walk-every-wrong-turn-throws/tree.md
    source: docs/explanation/configuration/.assets/strip-split-walk-every-wrong-turn-throws/diagram.drawio.png
    role: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Strip, split, read once, walk one segment at a time; every wrong turn throws: the tree minimap

```text
Which files cite ADR-CONF-ADDRESSING: every file of the world map is a tile, grouped by top-level folder.
10 files lit in 5 groups.
```

![The tree minimap of Strip, split, read once, walk one segment at a time; every wrong turn throws](tree.png)

This is the tree minimap in the sidebar of the implementation diagram of [Strip, split, read once, walk one segment at a time; every wrong
turn throws][11], which explains [ADR-CONF-ADDRESSING][1]. It lights every file that cites those codes, grouped by folder, so it shows which
files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `pwsh/` by module, under `docs/adr/` by ADR
domain), and lights 10 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 5 lit files
- adr/conf (docs/adr/configuration): 2 lit files
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file
- Docs (pwsh/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md][2], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the
  file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md][3], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 14 (text).
- [docs/references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md][4], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]:
  the file cites it at line 63 (text).
- [docs/references/pwsh/catzc-base-languages/New-PythonProject.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 56 (text).
- [docs/references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-CONF-ADDRESSING][1]: the file cites it at line 20 (text).

### adr/conf (docs/adr/configuration, 2 lit files)

The group holds the files of docs/adr/configuration; each sits in its world-map cell and is lit by:

- [docs/adr/configuration/config-value-addressing.md][1], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the ADR's own
  file.
- [docs/adr/configuration/dora-explains.md][7], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line
  28 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][8], in the cell docs × markdown: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 239 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][9], in the cell pipelines × pipeline-yaml: selected by [ADR-CONF-ADDRESSING][1]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `pwsh/Catzc.Base.Docs/configs/adrs.yml` line 209 (text).

### Docs (pwsh/Catzc.Base.Docs, 1 lit file)

The group holds the files of pwsh/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [pwsh/Catzc.Base.Docs/configs/adrs.yml][10], in the cell pwsh × yaml: selected by [ADR-CONF-ADDRESSING][1]: the file cites it at line 209
  (text).

## Keywords

- [world map][12]
- [track][13]
- [file language][14]
- [cell][15]
- [lit cell][16]
- [docs][17]: a track
- [pipelines][17]: a track
- [pwsh][17]: a track
- [markdown][18]: a file language
- [pipeline-yaml][18]: a file language
- [yaml][18]: a file language

[1]: ../../../../adr/configuration/config-value-addressing.md
[2]: ../../../../references/pwsh/catzc-base-config/Get-ConfigValue.ps1.md
[3]: ../../../../references/pwsh/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
[4]: ../../../../references/pwsh/catzc-base-languages/New-GoWorkspace.ps1.md
[5]: ../../../../references/pwsh/catzc-base-languages/New-PythonProject.ps1.md
[6]: ../../../../references/pwsh/catzc-tooling-environment/Write-EnvironmentSet.ps1.md
[7]: ../../../../adr/configuration/dora-explains.md
[8]: ../../../../adr/index.md
[9]: ../../../../../pipelines/ci-automation.yaml
[10]: ../../../../../pwsh/Catzc.Base.Docs/configs/adrs.yml
[11]: ../../strip-split-walk-every-wrong-turn-throws.md
[12]: ../../../../adr/glossary.md#world-map
[13]: ../../../../adr/glossary.md#track
[14]: ../../../../adr/glossary.md#file-language
[15]: ../../../../adr/glossary.md#cell
[16]: ../../../../adr/glossary.md#lit-cell
[17]: ../../../../../pwsh/Catzc.Base.Variants/configs/variants.yml
[18]: ../../../../../pwsh/Catzc.Base.Languages/configs/languages.yml
