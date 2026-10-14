# docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md

`Grid minimap: adr-dsgn-life--sync-from-the-last-certified-commit--meta`

![Grid minimap of adr-dsgn-life--sync-from-the-last-certified-commit--meta](adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.png)

The grid minimap of the slide `adr-dsgn-life--sync-from-the-last-certified-commit--meta` (meta lens). The slide supports [ADR-DSGN-LIFE][1];
the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 3 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 41 lit of 469 files

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/agents/write-drawio-files.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (41 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][8]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][9]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][10]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][11]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][12]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][13]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][14]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][15]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][17]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][18]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][19]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][20]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][21]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][22]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 73 (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][23]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][24]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][25]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][26]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][27]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][28]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][29]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][30]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][31]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][32]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][33]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][34]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][35]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][36]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][37]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][38]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][39]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][40]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][41]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][42]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][43]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][44]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][45]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][46]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][47]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][48]
- [track][49]
- [file language][50]
- [cell][51]
- [lit cell][52]
- [.claude][53]: a track
- [automation][53]: a track
- [docs][53]: a track
- [markdown][54]: a file language
- [yaml][54]: a file language

Terms the cited ADRs define:

- [occupant][55], defined by [ADR-DSGN-LIFE#5][56]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/agents/write-drawio-files.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[8]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[9]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[10]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[11]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[12]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[13]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[14]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[15]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[16]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[17]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[18]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[19]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[20]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[21]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[22]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[23]: ../../adr/design/dora-explains.md
[24]: ../../adr/design/module-aspects.md
[25]: ../../adr/design/run-modes.md
[26]: ../../adr/design/self-service.md
[27]: ../../adr/design/server-remote-integration.md
[28]: ../../adr/design/thin-platforms.md
[29]: ../../adr/design/tracks.md
[30]: ../../adr/design/visual-design.md
[31]: ../../adr/glossary.md
[32]: ../../adr/index.md
[33]: ../../explanation/design/clients-bridge-to-one-server.md
[34]: ../../explanation/design/code-wires-only-the-first-rungs.md
[35]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[36]: ../../explanation/design/deploying-is-not-integrating.md
[37]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[38]: ../../explanation/design/every-deploy-stage-is-main-only.md
[39]: ../../explanation/design/four-domains-promote-one-artifact.md
[40]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[41]: ../../explanation/design/integrators-depend-on-an-occupant.md
[42]: ../../explanation/design/merging-to-main-is-what-deploys.md
[43]: ../../explanation/design/one-way-climb-three-endings.md
[44]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[45]: ../../explanation/design/sync-from-the-last-certified-commit.md
[46]: ../../explanation/design/sync-point-rules-are-adr-only.md
[47]: ../../explanation/design/which-rung-gates-exist-in-code.md
[48]: ../../adr/glossary.md#world-map
[49]: ../../adr/glossary.md#track
[50]: ../../adr/glossary.md#file-language
[51]: ../../adr/glossary.md#cell
[52]: ../../adr/glossary.md#lit-cell
[53]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[54]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[55]: ../../adr/glossary.md#occupant
[56]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
