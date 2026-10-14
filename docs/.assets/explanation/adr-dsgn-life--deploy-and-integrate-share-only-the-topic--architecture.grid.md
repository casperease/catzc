# docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md

`Grid minimap: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture`

![Grid minimap of adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture](adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture` (architecture lens). The slide
supports [ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the
code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 9 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 26 lit of 742 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/agents/drawio-diagram-waves.md][6]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 48 (text).
- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 43 (text) and line 129 (text).
- [.claude/drawio/STYLE.md][8]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 41 (text), line 52 (text) and line 64 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 98 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][10]: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 32 (text), line 32 (body
  comment) and line 37 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][11]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (26 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][12]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][13]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][14]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][15]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][16]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][17]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][18]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][2]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][19]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][20]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 91 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][21]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][22]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][23]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 15 (text), line 50
  (text), line 51 (text) and line 57 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][24]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 14 (text), line 46 (text) and
  line 47 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][25]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][26]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][27]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][28]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][29]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 46 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][30]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][31]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 46
  (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][32]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 15 (text), line 20 (text), line 47 (text), line 49 (text), line 50 (text) and line 58 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][33]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][34]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][35]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).

## Keywords

- [world map][36]
- [track][37]
- [file language][38]
- [cell][39]
- [lit cell][40]
- [.claude][41]: a track
- [automation][41]: a track
- [docs][41]: a track
- [markdown][42]: a file language
- [yaml][42]: a file language

Terms the cited ADRs define:

- [occupant][43], defined by [ADR-DSGN-LIFE#5][44]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/visual-design.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/agents/drawio-diagram-waves.md
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../.claude/drawio/STYLE.md
[9]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[11]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[12]: ../../adr/design/dora-explains.md
[13]: ../../adr/design/module-aspects.md
[14]: ../../adr/design/run-modes.md
[15]: ../../adr/design/self-service.md
[16]: ../../adr/design/server-remote-integration.md
[17]: ../../adr/design/thin-platforms.md
[18]: ../../adr/design/tracks.md
[19]: ../../adr/glossary.md
[20]: ../../adr/index.md
[21]: ../../explanation/design/clients-bridge-to-one-server.md
[22]: ../../explanation/design/code-wires-only-the-first-rungs.md
[23]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[24]: ../../explanation/design/deploying-is-not-integrating.md
[25]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[26]: ../../explanation/design/every-deploy-stage-is-main-only.md
[27]: ../../explanation/design/four-domains-promote-one-artifact.md
[28]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[29]: ../../explanation/design/integrators-depend-on-an-occupant.md
[30]: ../../explanation/design/merging-to-main-is-what-deploys.md
[31]: ../../explanation/design/one-way-climb-three-endings.md
[32]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[33]: ../../explanation/design/sync-from-the-last-certified-commit.md
[34]: ../../explanation/design/sync-point-rules-are-adr-only.md
[35]: ../../explanation/design/which-rung-gates-exist-in-code.md
[36]: ../../adr/glossary.md#world-map
[37]: ../../adr/glossary.md#track
[38]: ../../adr/glossary.md#file-language
[39]: ../../adr/glossary.md#cell
[40]: ../../adr/glossary.md#lit-cell
[41]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[42]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[43]: ../../adr/glossary.md#occupant
[44]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
