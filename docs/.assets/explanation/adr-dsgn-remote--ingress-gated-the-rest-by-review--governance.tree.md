# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md

`Tree minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Tree minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

The tree minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 13 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 3 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- Variants (automation/Catzc.Base.Variants): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/repo (docs/adr/repository): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### adr/dsgn (docs/adr/design, 3 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the ADR's own file.
- [docs/adr/design/dora-explains.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 84 (text);
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 105 (text).
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the ADR's own file.

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][5], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 29 (header) and line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][6], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

### Variants (automation/Catzc.Base.Variants, 2 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][7], in the cell automation × yaml: selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 1 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][8], in the cell automation × csharp: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 93 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 294 (text).

### adr/repo (docs/adr/repository, 2 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/dora-explains.md][11], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the file cites it at line 149
  (text).
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][12], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][13], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text); selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 316 (text).

## Keywords

- [world map][14]
- [track][15]
- [file language][16]
- [cell][17]
- [lit cell][18]
- [.claude][7]: a track
- [automation][7]: a track
- [docs][7]: a track
- [csharp][19]: a file language
- [markdown][19]: a file language
- [powershell][19]: a file language
- [yaml][19]: a file language

Terms the cited ADRs define:

- [occupant][20], defined by [ADR-DSGN-LIFE#5][21]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: ../../adr/design/dora-explains.md
[5]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[6]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[7]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[8]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[9]: ../../adr/glossary.md
[10]: ../../adr/index.md
[11]: ../../adr/repository/dora-explains.md
[12]: ../../../.claude/agents/write-drawio-files.md
[13]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[14]: ../../adr/glossary.md#world-map
[15]: ../../adr/glossary.md#track
[16]: ../../adr/glossary.md#file-language
[17]: ../../adr/glossary.md#cell
[18]: ../../adr/glossary.md#lit-cell
[19]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[20]: ../../adr/glossary.md#occupant
[21]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
