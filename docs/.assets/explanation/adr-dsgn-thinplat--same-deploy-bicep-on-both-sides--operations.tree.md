# docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md

`Tree minimap: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations`

![Tree minimap of adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations` (operations lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 22 files in 5 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (10 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][2], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][6], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 74 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][7], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][8], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][9], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][10], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][11], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][12], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][14], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][15], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][16], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][17], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][1], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][18], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][19], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][20], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at
  line 96 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][21], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 628 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][22], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 89 (text).

## Keywords

- [world map][23]
- [track][24]
- [file language][25]
- [cell][26]
- [lit cell][27]
- [automation][28]: a track
- [docs][28]: a track
- [markdown][29]: a file language
- [yaml][29]: a file language

[1]: ../../adr/design/thin-platforms.md
[2]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[3]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[4]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[5]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[6]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[7]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[8]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[9]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[10]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[11]: ../../explanation/design/what-keeps-the-platform-thin.md
[12]: ../../adr/design/commit-lifecycle.md
[13]: ../../adr/design/dora-explains.md
[14]: ../../adr/design/module-aspects.md
[15]: ../../adr/design/run-modes.md
[16]: ../../adr/design/self-service.md
[17]: ../../adr/design/server-remote-integration.md
[18]: ../../adr/design/tracks.md
[19]: ../../adr/design/visual-design.md
[20]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[21]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[22]: ../../adr/index.md
[23]: ../../adr/glossary.md#world-map
[24]: ../../adr/glossary.md#track
[25]: ../../adr/glossary.md#file-language
[26]: ../../adr/glossary.md#cell
[27]: ../../adr/glossary.md#lit-cell
[28]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[29]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
