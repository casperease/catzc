# docs/.assets/explanation/tree/adr-auto-path--two-crossers-and-three-anchors--architecture.tree.md

`Tree minimap: adr-auto-path--two-crossers-and-three-anchors--architecture`

![Tree minimap of adr-auto-path--two-crossers-and-three-anchors--architecture](adr-auto-path--two-crossers-and-three-anchors--architecture.tree.png)

The tree minimap of the slide `adr-auto-path--two-crossers-and-three-anchors--architecture` (architecture lens). The slide supports
[ADR-AUTO-PATH][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 50 files in 14 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 15 lit files
- Contracts (automation/Catzc.Base.Contracts): 6 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 6 lit files
- Repository (automation/Catzc.Base.Repository): 4 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Objects (automation/Catzc.Base.Objects): 3 lit files
- Root files: 2 lit files
- .claude: 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- adr/auto (docs/adr/automation): 2 lit files
- .unordered: 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/automation/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md][2], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 17 (text) and line 31 (text).
- [docs/references/automation/catzc-base-contracts/types/ContractAsset.cs.md][3], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 17 (text), line 38 (text) and line 39 (text).
- [docs/references/automation/catzc-base-docs/configs/readme.yml.md][4], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 49 (text).
- [docs/references/automation/catzc-base-docs/types/DocMapping.cs.md][5], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 29 (text).
- [docs/references/automation/catzc-base-docs/types/DocPattern.cs.md][6], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 30 (text).
- [docs/references/automation/catzc-base-objects/types/ArtifactRef.cs.md][7], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]:
  the file cites it at line 17 (text) and line 36 (text).
- [docs/references/automation/catzc-base-objects/types/RepoRelativePath.cs.md][8], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 17 (text), line 30 (text), line 35 (text), line 36 (text), line 40 (text) and line 59
  (text).
- [docs/references/automation/catzc-base-rootconfig/configs/rootconfig.yml.md][9], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 44 (text).
- [docs/references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md][10], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 39 (text).
- [docs/references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 18 (text) and line 44 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md][12], in the cell docs × markdown:
  selected by [ADR-AUTO-PATH][1]: the file cites it at line 17 (text) and line 34 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md][13], in the cell docs × markdown:
  selected by [ADR-AUTO-PATH][1]: the file cites it at line 18 (text) and line 35 (text).
- [docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md][14], in the cell docs × markdown: selected
  by [ADR-AUTO-PATH][1]: the file cites it at line 17 (text) and line 33 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/Inspiration.cs.md][15], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 17 (text) and line 37 (text).
- [docs/references/automation/catzc-tooling-inspiration/types/InspirationRoot.cs.md][16], in the cell docs × markdown: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 17 (text), line 31 (text), line 33 (text) and line 34 (text).

### Contracts (automation/Catzc.Base.Contracts, 6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Get-Contract.ps1][17], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 20 (header) and line 32 (header).
- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][18], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]:
  the file cites it at line 22 (header) and line 51 (header).
- [automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1][19], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 21 (header) and line 39 (header).
- [automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1][20], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]:
  the file cites it at line 21 (header) and line 52 (body comment).
- [automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1][21], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 20 (header) and line 37 (text).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][22], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 21 (text).

### Tool.Inspiration (automation/Catzc.Tooling.Inspiration, 6 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1][23], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 21 (header), line 26 (header), line 27 (header) and line 30 (header).
- [automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1][24], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1][25], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 21 (header).
- [automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1][26], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 20 (header).
- [automation/Catzc.Tooling.Inspiration/types/Inspiration.cs][27], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 20 (text).
- [automation/Catzc.Tooling.Inspiration/types/InspirationRoot.cs][28], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 21 (text).

### Repository (automation/Catzc.Base.Repository, 4 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1][29], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 21 (header), line 26 (header) and line 36 (header).
- [automation/Catzc.Base.Repository/Get-RepositoryFile.ps1][30], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1][31], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 20 (header) and line 25 (header).
- [automation/Catzc.Base.Repository/Resolve-RepoPath.ps1][32], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 20 (header) and line 25 (header).

### Docs (automation/Catzc.Base.Docs, 3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][33], in the cell automation × yaml: selected by [ADR-AUTO-PATH][1]: the file cites it at
  line 156 (text).
- [automation/Catzc.Base.Docs/types/DocMapping.cs][34], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file cites it
  at line 21 (text).
- [automation/Catzc.Base.Docs/types/DocPattern.cs][35], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file cites it
  at line 21 (text).

### Objects (automation/Catzc.Base.Objects, 3 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1][36], in the cell automation × powershell: selected by
  [ADR-AUTO-PATH][1]: the file cites it at line 19 (header) and line 23 (text).
- [automation/Catzc.Base.Objects/types/ArtifactRef.cs][37], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file cites
  it at line 21 (text).
- [automation/Catzc.Base.Objects/types/RepoRelativePath.cs][38], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 21 (text).

### Root files (2 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][39], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PATH][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 21 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 26 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 36 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line 20 (header), `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line
  25 (header), `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 25 (header), `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line
  20 (header) and `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line 25 (header).
- [.gitignore][40], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PATH][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 21 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 26 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 36 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line 20 (header), `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line
  25 (header), `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 25 (header), `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line
  20 (header) and `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line 25 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-layers-vocabulary-rename-contracts.md][41], in the cell .claude × markdown: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 722 (text).
- [.claude/skills/catzc-module/SKILL.md][42], in the cell .claude × markdown: selected by [ADR-AUTO-PATH][1]: the file cites it at line 28
  (text), line 41 (text) and line 41 (text).

### ModuleSystem (automation/Catzc.Base.ModuleSystem, 2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][43], in the cell automation × powershell: selected by [ADR-AUTO-PATH][1]: the
  file cites it at line 21 (header) and line 56 (header).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][44], in the cell automation × yaml: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 57 (text).

### adr/* (the files directly in docs/adr/, 2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][45], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the file cites it at line 581 (text).
- [docs/adr/index.md][46], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the file cites it at line 167 (text).

### adr/auto (docs/adr/automation, 2 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/dora-explains.md][47], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the file cites it at line 451
  (text).
- [docs/adr/automation/path-representation.md][1], in the cell docs × markdown: selected by [ADR-AUTO-PATH][1]: the ADR's own file.

### .unordered (1 lit file)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-diagram-wave-8.md][48], in the cell .unordered × markdown: selected by [ADR-AUTO-PATH][1]: the file cites it
  at line 15 (text).

### RootConfig (automation/Catzc.Base.RootConfig, 1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/types/RootConfigFile.cs][49], in the cell automation × csharp: selected by [ADR-AUTO-PATH][1]: the file
  cites it at line 21 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][50], in the cell pipelines × pipeline-yaml: selected by [ADR-AUTO-PATH][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Contracts/Get-Contract.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/Get-Contract.ps1` line 32 (header), `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 22
  (header), `automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1` line 51 (header),
  `automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1` line 21 (header),
  `automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1` line 39 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 21 (header),
  `automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1` line 52 (body comment),
  `automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1` line 20 (header),
  `automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1` line 37 (text),
  `automation/Catzc.Base.Contracts/types/ContractAsset.cs` line 21 (text), `automation/Catzc.Base.Docs/configs/adrs.yml` line 156 (text),
  `automation/Catzc.Base.Docs/types/DocMapping.cs` line 21 (text), `automation/Catzc.Base.Docs/types/DocPattern.cs` line 21 (text),
  `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line 21 (header), `automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1` line
  56 (header), `automation/Catzc.Base.ModuleSystem/configs/glossary.yml` line 57 (text),
  `automation/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1` line 19 (header),
  `automation/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1` line 23 (text), `automation/Catzc.Base.Objects/types/ArtifactRef.cs`
  line 21 (text), `automation/Catzc.Base.Objects/types/RepoRelativePath.cs` line 21 (text),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 21 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 26 (header),
  `automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1` line 36 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line 20 (header), `automation/Catzc.Base.Repository/Get-RepositoryFile.ps1` line
  25 (header), `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 20 (header),
  `automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1` line 25 (header), `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line
  20 (header), `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1` line 25 (header),
  `automation/Catzc.Base.RootConfig/types/RootConfigFile.cs` line 21 (text),
  `automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1` line 21 (header),
  `automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1` line 26 (header),
  `automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1` line 27 (header),
  `automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1` line 30 (header),
  `automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1` line 21 (header),
  `automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1` line 20 (header),
  `automation/Catzc.Tooling.Inspiration/types/Inspiration.cs` line 20 (text) and
  `automation/Catzc.Tooling.Inspiration/types/InspirationRoot.cs` line 21 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [root file][56]
- [unlisted file][57]
- [.claude][58]: a track
- [.unordered][58]: a track
- [automation][58]: a track
- [docs][58]: a track
- [pipelines][58]: a track
- [csharp][59]: a file language
- [markdown][59]: a file language
- [pipeline-yaml][59]: a file language
- [powershell][59]: a file language
- [yaml][59]: a file language

Terms the cited ADRs define:

- [published artifact][60], defined by [ADR-AUTO-PATH#10][61]

[1]: ../../../adr/automation/path-representation.md
[2]: ../../../references/automation/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md
[3]: ../../../references/automation/catzc-base-contracts/types/ContractAsset.cs.md
[4]: ../../../references/automation/catzc-base-docs/configs/readme.yml.md
[5]: ../../../references/automation/catzc-base-docs/types/DocMapping.cs.md
[6]: ../../../references/automation/catzc-base-docs/types/DocPattern.cs.md
[7]: ../../../references/automation/catzc-base-objects/types/ArtifactRef.cs.md
[8]: ../../../references/automation/catzc-base-objects/types/RepoRelativePath.cs.md
[9]: ../../../references/automation/catzc-base-rootconfig/configs/rootconfig.yml.md
[10]: ../../../references/automation/catzc-base-rootconfig/types/RootConfigFile.cs.md
[11]: ../../../references/automation/catzc-tooling-inspiration/configs/inspiration.yml.md
[12]: ../../../references/automation/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
[13]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
[14]: ../../../references/automation/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
[15]: ../../../references/automation/catzc-tooling-inspiration/types/Inspiration.cs.md
[16]: ../../../references/automation/catzc-tooling-inspiration/types/InspirationRoot.cs.md
[17]: ../../../../automation/Catzc.Base.Contracts/Get-Contract.ps1
[18]: ../../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[19]: ../../../../automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1
[20]: ../../../../automation/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
[21]: ../../../../automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1
[22]: ../../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[23]: ../../../../automation/Catzc.Tooling.Inspiration/private/Resolve-InspirationRoot.ps1
[24]: ../../../../automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
[25]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
[26]: ../../../../automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
[27]: ../../../../automation/Catzc.Tooling.Inspiration/types/Inspiration.cs
[28]: ../../../../automation/Catzc.Tooling.Inspiration/types/InspirationRoot.cs
[29]: ../../../../automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1
[30]: ../../../../automation/Catzc.Base.Repository/Get-RepositoryFile.ps1
[31]: ../../../../automation/Catzc.Base.Repository/Get-RepositoryFolder.ps1
[32]: ../../../../automation/Catzc.Base.Repository/Resolve-RepoPath.ps1
[33]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../../automation/Catzc.Base.Docs/types/DocMapping.cs
[35]: ../../../../automation/Catzc.Base.Docs/types/DocPattern.cs
[36]: ../../../../automation/Catzc.Base.Objects/tests/types/ArtifactRef.Tests.ps1
[37]: ../../../../automation/Catzc.Base.Objects/types/ArtifactRef.cs
[38]: ../../../../automation/Catzc.Base.Objects/types/RepoRelativePath.cs
[39]: ../../../../.gitattributes
[40]: ../../../../.gitignore
[41]: ../../../../.claude/plans/plan-layers-vocabulary-rename-contracts.md
[42]: ../../../../.claude/skills/catzc-module/SKILL.md
[43]: ../../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[44]: ../../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[45]: ../../../adr/glossary.md
[46]: ../../../adr/index.md
[47]: ../../../adr/automation/dora-explains.md
[48]: ../../../../.unordered/15-10-2026/plan-diagram-wave-8.md
[49]: ../../../../automation/Catzc.Base.RootConfig/types/RootConfigFile.cs
[50]: ../../../../pipelines/ci-automation.yaml
[51]: ../../../adr/glossary.md#world-map
[52]: ../../../adr/glossary.md#track
[53]: ../../../adr/glossary.md#file-language
[54]: ../../../adr/glossary.md#cell
[55]: ../../../adr/glossary.md#lit-cell
[56]: ../../../adr/glossary.md#root-file
[57]: ../../../adr/glossary.md#unlisted-file
[58]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[59]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
[60]: ../../../adr/glossary.md#published-artifact
[61]: ../../../adr/automation/path-representation.md#rule-adr-auto-path10
