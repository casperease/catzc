# docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md

`Tree minimap: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta`

![Tree minimap of adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta` (meta lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 17 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/dsgn (docs/adr/design): 9 lit files
- docs (docs/ outside docs/adr/): 5 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][3], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][4], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][5], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][6], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][7], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][1], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][8], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][9], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### docs (5 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][10], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][11], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][12], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][13], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][14], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][15], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at
  line 96 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][16], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 670 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][17], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 89 (text).

## Keywords

- [world map][18]
- [track][19]
- [file language][20]
- [cell][21]
- [lit cell][22]
- [automation][23]: a track
- [docs][23]: a track
- [markdown][24]: a file language
- [yaml][24]: a file language

[1]: ../../adr/design/thin-platforms.md
[2]: ../../adr/design/commit-lifecycle.md
[3]: ../../adr/design/dora-explains.md
[4]: ../../adr/design/module-aspects.md
[5]: ../../adr/design/run-modes.md
[6]: ../../adr/design/self-service.md
[7]: ../../adr/design/server-remote-integration.md
[8]: ../../adr/design/tracks.md
[9]: ../../adr/design/visual-design.md
[10]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[11]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[12]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[13]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[14]: ../../explanation/design/what-keeps-the-platform-thin.md
[15]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[16]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[17]: ../../adr/index.md
[18]: ../../adr/glossary.md#world-map
[19]: ../../adr/glossary.md#track
[20]: ../../adr/glossary.md#file-language
[21]: ../../adr/glossary.md#cell
[22]: ../../adr/glossary.md#lit-cell
[23]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[24]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
