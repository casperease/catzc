# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md

`Tree minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Tree minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

The tree minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 19 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- .unordered: 4 lit files
- adr/dsgn (docs/adr/design): 3 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- docs (docs/ outside docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Variants (automation/Catzc.Base.Variants): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### .unordered (4 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-adr-consistency.md][4], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 100 (text), line 183 (text) and line 268 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 106 (text) and line
  257 (text).
- [.unordered/15-10-2026/plan-concern-axis.md][5], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 91 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 92 (text).
- [.unordered/15-10-2026/plan-diagram-wave-8.md][6], in the cell .unordered × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it
  at line 25 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][7], in the cell .unordered × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 84 (text), line 86 (text), line 86 (text), line 97 (text), line 99 (text), line 101 (text) and line 101 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text).

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 121 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 142 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][9], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 23 (header), line 51 (header) and line 124 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][10], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 68 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][11], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 201 (text).
- [docs/adr/index.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 107 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 108 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 316 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 197
  (text).
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.

### docs (docs/ outside docs/adr/, 2 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-variants/configs/variants.yml.md][14], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 29 (text).
- [docs/references/automation/catzc-base-variants/types/VariantsConfig.cs.md][15], in the cell docs × markdown: selected by
  [ADR-REPO-VARIANT][3]: the file cites it at line 30 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-module-kinds-tracks.md][16], in the cell .claude × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at
  line 754 (text) and line 807 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][17], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 95 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 96 (text); selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 314 (text).

### Variants (automation/Catzc.Base.Variants, 1 lit file)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][18], in the cell automation × csharp: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 23 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][19], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-LIFE][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 95 (text) and
  `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 68 (text); selected by [ADR-DSGN-REMOTE][2]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 96 (text); selected by
  [ADR-REPO-VARIANT][3]: a pipeline that cites nothing itself carries its globset's citations, which cite it at
  `automation/Catzc.Base.Docs/configs/adrs.yml` line 314 (text), `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 23
  (header), `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 51 (header),
  `automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1` line 124 (text) and `automation/Catzc.Base.Variants/types/VariantsConfig.cs`
  line 23 (text).

## Keywords

- [world map][20]
- [track][21]
- [file language][22]
- [cell][23]
- [lit cell][24]
- [.claude][25]: a track
- [.unordered][25]: a track
- [automation][25]: a track
- [docs][25]: a track
- [pipelines][25]: a track
- [csharp][26]: a file language
- [markdown][26]: a file language
- [pipeline-yaml][26]: a file language
- [powershell][26]: a file language
- [yaml][26]: a file language

Terms the cited ADRs define:

- [occupant][27], defined by [ADR-DSGN-LIFE#5][28]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: ../../../.unordered/15-10-2026/plan-adr-consistency.md
[5]: ../../../.unordered/15-10-2026/plan-concern-axis.md
[6]: ../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[7]: ../../../.unordered/15-10-2026/plan-explanation-drift.md
[8]: ../../adr/design/dora-explains.md
[9]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[10]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[11]: ../../adr/glossary.md
[12]: ../../adr/index.md
[13]: ../../adr/repository/dora-explains.md
[14]: ../../references/automation/catzc-base-variants/configs/variants.yml.md
[15]: ../../references/automation/catzc-base-variants/types/VariantsConfig.cs.md
[16]: ../../../.claude/plans/plan-module-kinds-tracks.md
[17]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[18]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[19]: ../../../pipelines/ci-automation.yaml
[20]: ../../adr/glossary.md#world-map
[21]: ../../adr/glossary.md#track
[22]: ../../adr/glossary.md#file-language
[23]: ../../adr/glossary.md#cell
[24]: ../../adr/glossary.md#lit-cell
[25]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[26]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[27]: ../../adr/glossary.md#occupant
[28]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
