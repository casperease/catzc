# docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md

`Grid minimap: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations`

![Grid minimap of adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations` (operations lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 2 lit of 95 files
- docs × markdown: 35 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][6]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 664 (text).

### docs × markdown (35 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][7]: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][8]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][9]: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38 (text), line 40 (text), line 41
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md][10]: selected by [ADR-DSGN-THINPLAT][1]: the
  file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][11]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][12]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][13]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38
  (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md][14]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36
  (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][15]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][16]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][17]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 43 (text), line 46 (text), line 53 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 114 (text), line 116 (text), line 118 (text) and
  line 122 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md][18]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 74 (text), line 76 (text), line 78 (text), line 81 (text), line 83
  (text), line 84 (text), line 87 (text), line 90 (text), line 92 (text), line 96 (text), line 103 (text), line 105 (text), line 107 (text),
  line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 150 (text), line 157 (text) and
  line 164 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][19]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][20]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][21]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38 (text), line 40 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md][22]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][23]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 8 (text), line 29 (text), line 29 (text), line 37 (text) and line 37 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][24]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][25]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 8 (text), line 45 (text), line 48 (text), line 55 (text), line 58 (text), line 60 (text), line 62 (text), line
  64 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186
  (text), line 187 (text), line 190 (text), line 191 (text), line 194 (text), line 198 (text), line 201 (text) and line 204 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md][26]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 8 (text), line 160 (text), line 162 (text), line 164 (text), line 167 (text), line 169 (text), line 170 (text),
  line 173 (text), line 178 (text), line 181 (text), line 184 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text),
  line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 247 (text), line 254 (text) and line 269 (text).
- [docs/adr/design/commit-lifecycle.md][27]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][28]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][29]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][30]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/self-service.md][31]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][32]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][1]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][33]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][34]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][35]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 89 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][36]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 13
  (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][37]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][38]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 17
  (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][39]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 16 (text),
  line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][40]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 17 (text),
  line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][41]
- [track][42]
- [file language][43]
- [cell][44]
- [lit cell][45]
- [automation][46]: a track
- [docs][46]: a track
- [markdown][47]: a file language
- [yaml][47]: a file language

[1]: ../../adr/design/thin-platforms.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[7]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[8]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[9]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[10]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
[11]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[12]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[13]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[14]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
[15]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[16]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[17]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[18]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
[19]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[20]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[21]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[22]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
[23]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[24]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[25]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[26]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
[27]: ../../adr/design/commit-lifecycle.md
[28]: ../../adr/design/dora-explains.md
[29]: ../../adr/design/module-aspects.md
[30]: ../../adr/design/run-modes.md
[31]: ../../adr/design/self-service.md
[32]: ../../adr/design/server-remote-integration.md
[33]: ../../adr/design/tracks.md
[34]: ../../adr/design/visual-design.md
[35]: ../../adr/index.md
[36]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[37]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[38]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[39]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[40]: ../../explanation/design/what-keeps-the-platform-thin.md
[41]: ../../adr/glossary.md#world-map
[42]: ../../adr/glossary.md#track
[43]: ../../adr/glossary.md#file-language
[44]: ../../adr/glossary.md#cell
[45]: ../../adr/glossary.md#lit-cell
[46]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[47]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
