# Every vendor call leaves cats through the az CLI: the tree minimap

```text
Which files cite ADR-AZ-CLI and ADR-DSGN-THINPLAT: every file of the world map is a tile, grouped by top-level folder.
20 files lit in 8 groups.
```

![The tree minimap of Every vendor call leaves cats through the az CLI](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Every vendor call leaves cats through the az CLI][21], which
explains [ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 20 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 10 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (docs/ outside docs/adr/, 10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][3], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 60 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliBicep.ps1.md][4], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md][5], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 22 (text).
- [docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md][6], in the cell docs × markdown: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 21 (text).
- [docs/references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md][7], in the cell docs × markdown: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 26 (text).
- [docs/references/automation/catzc-azure-cli/Install-AzCliBicep.ps1.md][8], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-azure-cli/Test-AzCliBicep.ps1.md][9], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 23 (text).
- [docs/references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md][10], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 22 (text).
- [docs/references/automation/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md][11], in the cell docs × markdown: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 21 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][12], in the cell docs × markdown: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 101 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][13], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 7 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][14], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 565 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 657 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 94 (text).
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 27
  (text).
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][17], in the cell .claude × markdown: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 158 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][18], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  258 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 75 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][19], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 283 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 109 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][20], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-CLI][1]: a pipeline that cites nothing
  itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 258 (text),
  `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 7 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 565 (text); selected by [ADR-DSGN-THINPLAT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 75 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 657 (text).

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
- [yaml][28]: a file language

[1]: ../../../adr/azure/prefer-az-cli.md
[2]: ../../../adr/design/thin-platforms.md
[3]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[4]: ../../../references/automation/catzc-azure-cli/Assert-AzCliBicep.ps1.md
[5]: ../../../references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md
[6]: ../../../references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
[7]: ../../../references/automation/catzc-azure-cli/Get-AzCliSubscriptionAccessState.ps1.md
[8]: ../../../references/automation/catzc-azure-cli/Install-AzCliBicep.ps1.md
[9]: ../../../references/automation/catzc-azure-cli/Test-AzCliBicep.ps1.md
[10]: ../../../references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md
[11]: ../../../references/automation/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md
[12]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[13]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[14]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[15]: ../../../adr/azure/dora-explains.md
[16]: ../../../adr/design/dora-explains.md
[17]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[18]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[19]: ../../../adr/index.md
[20]: ../../../../pipelines/ci-automation.yaml
[21]: ../../design/every-vendor-call-leaves-through-az.md
[22]: ../../../adr/glossary.md#world-map
[23]: ../../../adr/glossary.md#track
[24]: ../../../adr/glossary.md#file-language
[25]: ../../../adr/glossary.md#cell
[26]: ../../../adr/glossary.md#lit-cell
[27]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[28]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
