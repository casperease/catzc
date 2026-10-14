# docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md

`Grid minimap: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta`

![Grid minimap of adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta](adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta` (meta lens). The slide supports
[ADR-DSGN-THINPLAT][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 2 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- automation × yaml: 2 lit of 95 files
- docs × markdown: 20 lit of 469 files

## Why each cell is lit

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][6]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 628 (text).

### docs × markdown (20 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][7]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][8]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][9]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][10]: selected by
  [ADR-DSGN-THINPLAT][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][11]: selected by [ADR-DSGN-THINPLAT][1]:
  the file cites it at line 74 (text).
- [docs/adr/design/commit-lifecycle.md][12]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][13]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][14]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][15]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/self-service.md][16]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][17]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][1]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][18]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][19]: selected by [ADR-DSGN-THINPLAT][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][20]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 89 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][21]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 13
  (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][22]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][23]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 17
  (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][24]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 16 (text),
  line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][25]: selected by [ADR-DSGN-THINPLAT][1]: the file cites it at line 17 (text),
  line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][26]
- [track][27]
- [file language][28]
- [cell][29]
- [lit cell][30]
- [automation][31]: a track
- [docs][31]: a track
- [markdown][32]: a file language
- [yaml][32]: a file language

[1]: ../../adr/design/thin-platforms.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[7]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[8]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[9]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[10]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[11]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[12]: ../../adr/design/commit-lifecycle.md
[13]: ../../adr/design/dora-explains.md
[14]: ../../adr/design/module-aspects.md
[15]: ../../adr/design/run-modes.md
[16]: ../../adr/design/self-service.md
[17]: ../../adr/design/server-remote-integration.md
[18]: ../../adr/design/tracks.md
[19]: ../../adr/design/visual-design.md
[20]: ../../adr/index.md
[21]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[22]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[23]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[24]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[25]: ../../explanation/design/what-keeps-the-platform-thin.md
[26]: ../../adr/glossary.md#world-map
[27]: ../../adr/glossary.md#track
[28]: ../../adr/glossary.md#file-language
[29]: ../../adr/glossary.md#cell
[30]: ../../adr/glossary.md#lit-cell
[31]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[32]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
