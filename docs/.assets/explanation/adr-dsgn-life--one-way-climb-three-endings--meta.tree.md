# docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md

`Tree minimap: adr-dsgn-life--one-way-climb-three-endings--meta`

![Tree minimap of adr-dsgn-life--one-way-climb-three-endings--meta](adr-dsgn-life--one-way-climb-three-endings--meta.tree.png)

The tree minimap of the slide `adr-dsgn-life--one-way-climb-three-endings--meta` (meta lens). The slide supports [ADR-DSGN-LIFE][1] and
[ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 32 files in 6 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (15 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/clients-bridge-to-one-server.md][3], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites
  it at line 15 (text), line 50 (text), line 51 (text) and line 57 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 14
  (text), line 46 (text) and line 47 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][11], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 46 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][13], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text); selected by [ADR-DSGN-VISUAL][2]:
  the file cites it at line 46 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][14], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 15 (text), line 20 (text), line 47 (text), line 49 (text), line 50 (text) and line 58
  (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][16], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][18], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][19], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][20], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][21], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][22], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/drawio-diagram-waves.md][25], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  48 (text).
- [.claude/agents/write-drawio-files.md][26], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 43 (text) and line 129 (text).
- [.claude/drawio/STYLE.md][27], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 41 (text), line
  52 (text) and line 64 (text).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][28], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 98 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][29], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at
  line 32 (text), line 32 (body comment) and line 37 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][30], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][31], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 91 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][32], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

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
[2]: ../../adr/design/visual-design.md
[3]: ../../explanation/design/clients-bridge-to-one-server.md
[4]: ../../explanation/design/code-wires-only-the-first-rungs.md
[5]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[6]: ../../explanation/design/deploying-is-not-integrating.md
[7]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[8]: ../../explanation/design/every-deploy-stage-is-main-only.md
[9]: ../../explanation/design/four-domains-promote-one-artifact.md
[10]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[11]: ../../explanation/design/integrators-depend-on-an-occupant.md
[12]: ../../explanation/design/merging-to-main-is-what-deploys.md
[13]: ../../explanation/design/one-way-climb-three-endings.md
[14]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[15]: ../../explanation/design/sync-from-the-last-certified-commit.md
[16]: ../../explanation/design/sync-point-rules-are-adr-only.md
[17]: ../../explanation/design/which-rung-gates-exist-in-code.md
[18]: ../../adr/design/dora-explains.md
[19]: ../../adr/design/module-aspects.md
[20]: ../../adr/design/run-modes.md
[21]: ../../adr/design/self-service.md
[22]: ../../adr/design/server-remote-integration.md
[23]: ../../adr/design/thin-platforms.md
[24]: ../../adr/design/tracks.md
[25]: ../../../.claude/agents/drawio-diagram-waves.md
[26]: ../../../.claude/agents/write-drawio-files.md
[27]: ../../../.claude/drawio/STYLE.md
[28]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[29]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[30]: ../../adr/glossary.md
[31]: ../../adr/index.md
[32]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[33]: ../../adr/glossary.md#world-map
[34]: ../../adr/glossary.md#track
[35]: ../../adr/glossary.md#file-language
[36]: ../../adr/glossary.md#cell
[37]: ../../adr/glossary.md#lit-cell
[38]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[39]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[40]: ../../adr/glossary.md#occupant
[41]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
