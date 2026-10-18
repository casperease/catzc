# Get-Aspect names each track's remainder, and a wrong order fails when the variants config loads: the tree minimap

```text
Which files cite ADR-DSGN-ASPECT: every file of the world map is a tile, grouped by top-level folder.
20 files lit in 8 groups.
```

![The tree minimap of Get-Aspect names each track's remainder, and a wrong order fails when the variants config loads](adr-dsgn-aspect--get-aspect-names-the-remainder--operations.tree.png)

This is the tree minimap in the sidebar of the operations diagram of [Get-Aspect names each track's remainder, and a wrong order fails when
the variants config loads][21], which explains [ADR-DSGN-ASPECT][1]. It lights every file that cites those codes, grouped by folder, so it
shows which files carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 20 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 10 lit files
- .claude: 3 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- Modules (automation/Catzc.Base.Modules): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md][2], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 55 (text).
- [docs/references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md][3], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 16 (text) and line 69 (text).
- [docs/references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md][4], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 109 (text).
- [docs/references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md][5], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 11 (text).
- [docs/references/automation/catzc-base-globs/types/Aspect.cs.md][6], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 11 (text), line 24 (text) and line 52 (text).
- [docs/references/automation/catzc-base-modules/Get-Aspect.ps1.md][7], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 15 (text).
- [docs/references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md][8], in the cell docs × markdown: selected
  by [ADR-DSGN-ASPECT][1]: the file cites it at line 50 (text).
- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 61 (text).
- [docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 12 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 28 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][12], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 916 (text).
- [.claude/plans/plan-module-kinds-tracks.md][13], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 210 (text), line 234 (text), line 266 (text), line 273 (text), line 359 (text), line 734 (text) and line 923 (text).
- [.claude/plans/prompt-module-model-1-prepare.md][14], in the cell .claude × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 18 (text).

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 171
  (text).
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the ADR's own file.

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 83 (text).

### Globs (automation/Catzc.Base.Globs, 1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][17], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 33 (text).

### Modules (automation/Catzc.Base.Modules, 1 lit file)

The group holds the files of automation/Catzc.Base.Modules; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1][18], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 1 (header).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][19], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 117 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][20], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-ASPECT][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 83 (text),
  `automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1` line 33 (text) and
  `automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1` line 1 (header).

## Keywords

- [world map][22]
- [track][23]
- [file language][24]
- [cell][25]
- [lit cell][26]
- [.claude][27]: a track
- [automation][27]: a track
- [docs][27]: a track
- [pipelines][27]: a track
- [markdown][28]: a file language
- [pipeline-yaml][28]: a file language
- [powershell][28]: a file language
- [yaml][28]: a file language

[1]: ../../../adr/design/module-aspects.md
[2]: ../../../references/.assets/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.verify.md
[3]: ../../../references/automation/catzc-base-globs/Get-ModuleGlobSet.ps1.md
[4]: ../../../references/automation/catzc-base-globs/protected-module-skip-by-hash.drawio.md
[5]: ../../../references/automation/catzc-base-globs/tests/types/Aspect.Tests.ps1.md
[6]: ../../../references/automation/catzc-base-globs/types/Aspect.cs.md
[7]: ../../../references/automation/catzc-base-modules/Get-Aspect.ps1.md
[8]: ../../../references/automation/catzc-base-qualitygates/private/Get-ModuleProtectionIdentity.ps1.md
[9]: ../../../references/automation/catzc-base-variants/configs/variants.yml.md
[10]: ../../../references/automation/catzc-base-variants/types/VariantAspect.cs.md
[11]: ../../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[12]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[13]: ../../../../.claude/plans/plan-module-kinds-tracks.md
[14]: ../../../../.claude/plans/prompt-module-model-1-prepare.md
[15]: ../../../adr/design/dora-explains.md
[16]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[18]: ../../../../automation/Catzc.Base.Modules/tests/Get-Aspect.Tests.ps1
[19]: ../../../adr/index.md
[20]: ../../../../pipelines/ci-automation.yaml
[21]: ../../design/get-aspect-names-the-remainder.md
[22]: ../../../adr/glossary.md#world-map
[23]: ../../../adr/glossary.md#track
[24]: ../../../adr/glossary.md#file-language
[25]: ../../../adr/glossary.md#cell
[26]: ../../../adr/glossary.md#lit-cell
[27]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
