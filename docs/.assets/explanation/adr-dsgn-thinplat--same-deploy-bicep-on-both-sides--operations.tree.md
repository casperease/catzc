# docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md

`Tree minimap: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations`

![Tree minimap of adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations` (operations lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 37 files in 5 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][2], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][3], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][4], in the cell docs × markdown: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38
  (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md][5], in the cell docs × markdown: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36
  (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][10], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][11], in the cell docs ×
  markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][12], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 43 (text), line 46 (text), line 53 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 114 (text), line 116 (text), line 118
  (text) and line 122 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md][13], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 74 (text), line 76 (text), line 78 (text), line 81 (text),
  line 83 (text), line 84 (text), line 87 (text), line 90 (text), line 92 (text), line 96 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 150 (text), line 157
  (text) and line 164 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][14], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][18], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 29 (text), line 29 (text), line 37 (text) and line 37 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][20], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 45 (text), line 48 (text), line 55 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 186 (text), line 187 (text), line 190 (text), line 191 (text), line 194 (text), line 198 (text), line 201
  (text) and line 204 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md][21], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 160 (text), line 162 (text), line 164 (text), line 167 (text), line
  169 (text), line 170 (text), line 173 (text), line 178 (text), line 181 (text), line 184 (text), line 191 (text), line 193 (text), line
  195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 247 (text), line
  254 (text) and line 269 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][22], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][23], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][24], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][25], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][26], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file
  cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][27], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][28], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][29], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][30], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][31], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][32], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][1], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][33], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][34], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][35], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at
  line 96 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/terminology.yml][36], in the cell automation × yaml: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 664 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][37], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 89 (text).

## Keywords

- [world map][38]
- [track][39]
- [file language][40]
- [cell][41]
- [lit cell][42]
- [automation][43]: a track
- [docs][43]: a track
- [markdown][44]: a file language
- [yaml][44]: a file language

[1]: ../../adr/design/thin-platforms.md
[2]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[3]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[4]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[5]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
[6]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[7]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[8]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[9]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
[10]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[11]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[12]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[13]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
[14]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[15]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[16]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[17]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
[18]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[19]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[20]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[21]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
[22]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[23]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[24]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[25]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[26]: ../../explanation/design/what-keeps-the-platform-thin.md
[27]: ../../adr/design/commit-lifecycle.md
[28]: ../../adr/design/dora-explains.md
[29]: ../../adr/design/module-aspects.md
[30]: ../../adr/design/run-modes.md
[31]: ../../adr/design/self-service.md
[32]: ../../adr/design/server-remote-integration.md
[33]: ../../adr/design/tracks.md
[34]: ../../adr/design/visual-design.md
[35]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[36]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[37]: ../../adr/index.md
[38]: ../../adr/glossary.md#world-map
[39]: ../../adr/glossary.md#track
[40]: ../../adr/glossary.md#file-language
[41]: ../../adr/glossary.md#cell
[42]: ../../adr/glossary.md#lit-cell
[43]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[44]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
