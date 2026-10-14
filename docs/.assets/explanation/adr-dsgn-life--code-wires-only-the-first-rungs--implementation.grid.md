# docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md

`Grid minimap: adr-dsgn-life--code-wires-only-the-first-rungs--implementation`

![Grid minimap of adr-dsgn-life--code-wires-only-the-first-rungs--implementation](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-life--code-wires-only-the-first-rungs--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 26 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

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

### docs × markdown (26 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][8]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][9]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][10]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][11]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][12]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][13]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][14]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][15]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][18]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][19]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][20]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][21]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][22]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][23]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][24]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][25]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][26]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][27]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][28]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][29]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][30]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][31]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][32]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][33]
- [track][34]
- [file language][35]
- [cell][36]
- [lit cell][37]
- [.claude][38]: a track
- [automation][38]: a track
- [docs][38]: a track
- [markdown][39]: a file language
- [yaml][39]: a file language

Terms the cited ADRs define:

- [occupant][40], defined by [ADR-DSGN-LIFE#5][41]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/agents/write-drawio-files.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[8]: ../../adr/design/dora-explains.md
[9]: ../../adr/design/module-aspects.md
[10]: ../../adr/design/run-modes.md
[11]: ../../adr/design/self-service.md
[12]: ../../adr/design/server-remote-integration.md
[13]: ../../adr/design/thin-platforms.md
[14]: ../../adr/design/tracks.md
[15]: ../../adr/design/visual-design.md
[16]: ../../adr/glossary.md
[17]: ../../adr/index.md
[18]: ../../explanation/design/clients-bridge-to-one-server.md
[19]: ../../explanation/design/code-wires-only-the-first-rungs.md
[20]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[21]: ../../explanation/design/deploying-is-not-integrating.md
[22]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[23]: ../../explanation/design/every-deploy-stage-is-main-only.md
[24]: ../../explanation/design/four-domains-promote-one-artifact.md
[25]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[26]: ../../explanation/design/integrators-depend-on-an-occupant.md
[27]: ../../explanation/design/merging-to-main-is-what-deploys.md
[28]: ../../explanation/design/one-way-climb-three-endings.md
[29]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[30]: ../../explanation/design/sync-from-the-last-certified-commit.md
[31]: ../../explanation/design/sync-point-rules-are-adr-only.md
[32]: ../../explanation/design/which-rung-gates-exist-in-code.md
[33]: ../../adr/glossary.md#world-map
[34]: ../../adr/glossary.md#track
[35]: ../../adr/glossary.md#file-language
[36]: ../../adr/glossary.md#cell
[37]: ../../adr/glossary.md#lit-cell
[38]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[40]: ../../adr/glossary.md#occupant
[41]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
