# docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md

`Tree minimap: adr-dsgn-life--every-deploy-stage-is-main-only--implementation`

![Tree minimap of adr-dsgn-life--every-deploy-stage-is-main-only--implementation](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.png)

The tree minimap of the slide `adr-dsgn-life--every-deploy-stage-is-main-only--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-DSGN-VISUAL][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 48 files in 6 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 31 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (31 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][4], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][5], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 75 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 75
  (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][10], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][12], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 64 (text) and line 74 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][13], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][14], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][15], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text) and line 76 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  76 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/glyphs.drawio.md][18], in the cell docs × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  30 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][19], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][20], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][21], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites
  it at line 15 (text), line 50 (text), line 51 (text) and line 57 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][22], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 14
  (text), line 46 (text) and line 47 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][26], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][27], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-DSGN-VISUAL][2]: the file
  cites it at line 46 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][28], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][29], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text); selected by [ADR-DSGN-VISUAL][2]:
  the file cites it at line 46 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][30], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 15 (text), line 20 (text), line 47 (text), line 49 (text), line 50 (text) and line 58
  (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][31], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][32], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][33], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 63 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][34], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][35], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][36], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][37], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][38], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][39], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][40], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-VISUAL][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/drawio-diagram-waves.md][41], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line
  48 (text).
- [.claude/agents/write-drawio-files.md][42], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 43 (text) and line 129 (text).
- [.claude/drawio/STYLE.md][43], in the cell .claude × markdown: selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 41 (text), line
  52 (text) and line 64 (text).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][44], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-VISUAL][2]: the file cites it at line 98 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][45], in the cell automation × yaml: selected by [ADR-DSGN-VISUAL][2]: the file cites it at
  line 32 (text), line 32 (body comment) and line 37 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][46], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][47], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-VISUAL][2]: the file cites it at line 91 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][48], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

## Keywords

- [world map][49]
- [track][50]
- [file language][51]
- [cell][52]
- [lit cell][53]
- [.claude][54]: a track
- [automation][54]: a track
- [docs][54]: a track
- [markdown][55]: a file language
- [yaml][55]: a file language

Terms the cited ADRs define:

- [occupant][56], defined by [ADR-DSGN-LIFE#5][57]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/visual-design.md
[3]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[4]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[5]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[6]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[7]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[8]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[9]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[10]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[11]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[12]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[13]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[14]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[15]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[16]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[17]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[18]: glyphs.drawio.md
[19]: ../../explanation/design/clients-bridge-to-one-server.md
[20]: ../../explanation/design/code-wires-only-the-first-rungs.md
[21]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[22]: ../../explanation/design/deploying-is-not-integrating.md
[23]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[24]: ../../explanation/design/every-deploy-stage-is-main-only.md
[25]: ../../explanation/design/four-domains-promote-one-artifact.md
[26]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[27]: ../../explanation/design/integrators-depend-on-an-occupant.md
[28]: ../../explanation/design/merging-to-main-is-what-deploys.md
[29]: ../../explanation/design/one-way-climb-three-endings.md
[30]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[31]: ../../explanation/design/sync-from-the-last-certified-commit.md
[32]: ../../explanation/design/sync-point-rules-are-adr-only.md
[33]: ../../explanation/design/which-rung-gates-exist-in-code.md
[34]: ../../adr/design/dora-explains.md
[35]: ../../adr/design/module-aspects.md
[36]: ../../adr/design/run-modes.md
[37]: ../../adr/design/self-service.md
[38]: ../../adr/design/server-remote-integration.md
[39]: ../../adr/design/thin-platforms.md
[40]: ../../adr/design/tracks.md
[41]: ../../../.claude/agents/drawio-diagram-waves.md
[42]: ../../../.claude/agents/write-drawio-files.md
[43]: ../../../.claude/drawio/STYLE.md
[44]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[45]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[46]: ../../adr/glossary.md
[47]: ../../adr/index.md
[48]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[49]: ../../adr/glossary.md#world-map
[50]: ../../adr/glossary.md#track
[51]: ../../adr/glossary.md#file-language
[52]: ../../adr/glossary.md#cell
[53]: ../../adr/glossary.md#lit-cell
[54]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[55]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[56]: ../../adr/glossary.md#occupant
[57]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
