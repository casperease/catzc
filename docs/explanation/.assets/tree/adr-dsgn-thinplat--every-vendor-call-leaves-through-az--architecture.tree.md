---
catzc:
  immutable:
    with_body_sha: "8e0bf66fb33d"
    repo_status: locked
    path: docs/explanation/.assets/tree/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
    source: docs/explanation/.assets/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.png
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    tracktype: documentation
---

# Every vendor call leaves cats through the az CLI: the tree minimap

```text
Which files cite ADR-AZ-CLI and ADR-DSGN-THINPLAT: every file of the world map is a tile, grouped by top-level folder.
21 files lit in 9 groups.
```

![The tree minimap of Every vendor call leaves cats through the az CLI](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

This is the tree minimap in the sidebar of the architecture diagram of [Every vendor call leaves cats through the az CLI][22], which
explains [ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]. It lights every file that cites those codes, grouped by folder, so it shows which files
carry the decision. Each lit group has its reason below, naming the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 21 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- .claude: 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- adr/azure (docs/adr/azure): 2 lit files
- adr/dsgn (docs/adr/design): 2 lit files
- docs (docs/ outside docs/adr/): 2 lit files
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

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/plans/plan-adr-link-cleanup-prose-to-pages.md][11], in the cell .claude × markdown: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 185 (text).
- [.claude/plans/plan-file-meta-head-policy.md][12], in the cell .claude × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line
  111 (text).

### QualityGates (automation/Catzc.Base.QualityGates, 2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][13], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 26 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][14], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 584 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 676 (text).

### adr/azure (docs/adr/azure, 2 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/dora-explains.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 125 (text).
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the ADR's own file.

### adr/dsgn (docs/adr/design, 2 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/dora-explains.md][16], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 66
  (text).
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the ADR's own file.

### docs (docs/ outside docs/adr/, 2 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md][17], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 16 (text) and line 79 (text).
- [docs/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md][18], in the cell docs × markdown: selected by
  [ADR-AZ-CLI][1]: the file cites it at line 16 (text) and line 122 (text).

### Docs (automation/Catzc.Base.Docs, 1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][19], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  277 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 94 (text).

### adr/* (the files directly in docs/adr/, 1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][20], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 283 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 109 (text).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][21], in the cell pipelines × pipeline-yaml: selected by [ADR-AZ-CLI][1]: a pipeline that cites nothing
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
  `automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1` line 33 (header), `automation/Catzc.Base.Docs/configs/adrs.yml` line 277
  (text), `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml` line 26 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 584 (text); selected by [ADR-DSGN-THINPLAT][2]: a pipeline that cites
  nothing itself carries its globset's citations, which cite it at `automation/Catzc.Base.Docs/configs/adrs.yml` line 94 (text) and
  `automation/Catzc.Base.QualityGates/configs/terminology.yml` line 676 (text).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [.claude][28]: a track
- [automation][28]: a track
- [docs][28]: a track
- [pipelines][28]: a track
- [markdown][29]: a file language
- [pipeline-yaml][29]: a file language
- [powershell][29]: a file language
- [yaml][29]: a file language

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
[11]: ../../../../.claude/plans/plan-adr-link-cleanup-prose-to-pages.md
[12]: ../../../../.claude/plans/plan-file-meta-head-policy.md
[13]: ../../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[14]: ../../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[15]: ../../../adr/azure/dora-explains.md
[16]: ../../../adr/design/dora-explains.md
[17]: ../../../references/.assets/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
[18]: ../../../references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.md
[19]: ../../../../automation/Catzc.Base.Docs/configs/adrs.yml
[20]: ../../../adr/index.md
[21]: ../../../../pipelines/ci-automation.yaml
[22]: ../../design/every-vendor-call-leaves-through-az.md
[23]: ../../../adr/glossary.md#world-map
[24]: ../../../adr/glossary.md#track
[25]: ../../../adr/glossary.md#file-language
[26]: ../../../adr/glossary.md#cell
[27]: ../../../adr/glossary.md#lit-cell
[28]: ../../../../automation/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../../automation/Catzc.Base.Languages/configs/languages.yml
