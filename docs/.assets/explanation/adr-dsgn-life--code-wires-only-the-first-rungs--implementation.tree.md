# docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md

`Tree minimap: adr-dsgn-life--code-wires-only-the-first-rungs--implementation`

![Tree minimap of adr-dsgn-life--code-wires-only-the-first-rungs--implementation](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-life--code-wires-only-the-first-rungs--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 29 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/clients-bridge-to-one-server.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][3], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][11], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][13], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][14], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][16], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][18], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][19], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][20], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][21], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][22], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][26], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][27], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][28], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][29], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

## Keywords

- [world map][30]
- [track][31]
- [file language][32]
- [cell][33]
- [lit cell][34]
- [.claude][35]: a track
- [automation][35]: a track
- [docs][35]: a track
- [markdown][36]: a file language
- [yaml][36]: a file language

Terms the cited ADRs define:

- [occupant][37], defined by [ADR-DSGN-LIFE#5][38]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../explanation/design/clients-bridge-to-one-server.md
[3]: ../../explanation/design/code-wires-only-the-first-rungs.md
[4]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[5]: ../../explanation/design/deploying-is-not-integrating.md
[6]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[7]: ../../explanation/design/every-deploy-stage-is-main-only.md
[8]: ../../explanation/design/four-domains-promote-one-artifact.md
[9]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[10]: ../../explanation/design/integrators-depend-on-an-occupant.md
[11]: ../../explanation/design/merging-to-main-is-what-deploys.md
[12]: ../../explanation/design/one-way-climb-three-endings.md
[13]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[14]: ../../explanation/design/sync-from-the-last-certified-commit.md
[15]: ../../explanation/design/sync-point-rules-are-adr-only.md
[16]: ../../explanation/design/which-rung-gates-exist-in-code.md
[17]: ../../adr/design/dora-explains.md
[18]: ../../adr/design/module-aspects.md
[19]: ../../adr/design/run-modes.md
[20]: ../../adr/design/self-service.md
[21]: ../../adr/design/server-remote-integration.md
[22]: ../../adr/design/thin-platforms.md
[23]: ../../adr/design/tracks.md
[24]: ../../adr/design/visual-design.md
[25]: ../../adr/glossary.md
[26]: ../../adr/index.md
[27]: ../../../.claude/agents/write-drawio-files.md
[28]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[30]: ../../adr/glossary.md#world-map
[31]: ../../adr/glossary.md#track
[32]: ../../adr/glossary.md#file-language
[33]: ../../adr/glossary.md#cell
[34]: ../../adr/glossary.md#lit-cell
[35]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[36]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[37]: ../../adr/glossary.md#occupant
[38]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
