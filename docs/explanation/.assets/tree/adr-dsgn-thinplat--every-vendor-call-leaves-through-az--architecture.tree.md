# docs/explanation/.assets/tree/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md

`Tree minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Tree minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 20 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- .unordered: 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### Az.Cli (automation/Catzc.Azure.Cli, 8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][3], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 22 (header) and line 32 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][4], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 21 (header) and line 36 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][5], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 22 (header) and line 35 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][6], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 21 (header) and line 41 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][7], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 20 (header) and line 30 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][8], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 22 (header) and line 35 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][9], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 21 (header) and line 35 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][10], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 21 (header) and line 33 (header).

### .unordered (2 lit files)

The group holds the files of .unordered; each sits in its world-map cell and is lit by:

- [.unordered/15-10-2026/plan-concern-axis.md][11], in the cell .unordered × markdown: selected by [ADR-DSGN-THINPLAT][2]: the file cites it
  at line 88 (text).
- [.unordered/15-10-2026/plan-explanation-drift.md][12], in the cell .unordered × markdown: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 42 (text), line 50 (text) and line 61 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 81 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][13], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 26 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][14], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 581 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 671 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 126 (text).
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 67
  (text).
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][17], in the cell .claude × markdown: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 178 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][18], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  272 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 93 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][19], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 277 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 107 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][20], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-CLI][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1` line 22 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1` line 32 (header), `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 21
  (header), `automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1` line 36 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 22 (header),
  `automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1` line 35 (header),
  `automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1` line 41 (header), `automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1`
  line 20 (header), `automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1` line 30 (header), `automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1`
  line 22 (header), `automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1` line 35 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1`
  line 21 (header), `automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1` line 35 (header),
  `automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1` line 21 (header),
  `automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1` line 33 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 272
  (text), `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 26 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 581 (text); selected by [ADR-DSGN-THINPLAT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 93 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 671 (text).

## Keywords

- [world map][21]
- [track][22]
- [file language][23]
- [cell][24]
- [lit cell][25]
- [.claude][26]: a track
- [.unordered][26]: a track
- [automation][26]: a track
- [docs][26]: a track
- [pipelines][26]: a track
- [markdown][27]: a file language
- [pipeline-yaml][27]: a file language
- [powershell][27]: a file language
- [yaml][27]: a file language

[1]: ../../../adr/azure/prefer-az-cli.md
[2]: ../../../adr/design/thin-platforms.md
[3]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[4]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[5]: ../../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[6]: ../../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[7]: ../../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[8]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[9]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[10]: ../../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[11]: ../../../../.unordered/15-10-2026/plan-concern-axis.md
[12]: ../../../../.unordered/15-10-2026/plan-explanation-drift.md
[13]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[14]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[15]: ../../../adr/azure/dora-explains.md
[16]: ../../../adr/design/dora-explains.md
[17]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[18]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../../adr/index.md
[20]: ../../../../pipelines/ci-automation.yaml
[21]: ../../../adr/glossary.md#world-map
[22]: ../../../adr/glossary.md#track
[23]: ../../../adr/glossary.md#file-language
[24]: ../../../adr/glossary.md#cell
[25]: ../../../adr/glossary.md#lit-cell
[26]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[27]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
