# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md

`Tree minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Tree minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

The tree minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 68 files in 8 groups. A lit ADR file is framed; a file lit only by passing mentions is drawn pale.

- docs (docs/ outside docs/adr/): 36 lit files
- adr/repo (docs/adr/repository): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- Variants (automation/Catzc.Base.Variants): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (36 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][5], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][10], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][11], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][13], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][14], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][15], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][16], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 70
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md][18], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 73 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 73
  (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 67 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][22], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 15 (text), line 45
  (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][23], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][24], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][25], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][26], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][27], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][28], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][29], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 16 (text), line 48 (text) and line 51 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 16 (text) and
  line 50 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][30], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 16 (text), line
  19 (text), line 22 (text), line 49 (text), line 50 (text), line 50 (text) and line 52 (text); selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 16 (text), line 22 (text) and line 54 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][31], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][32], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 19 (text), line 55 (text) and line 58 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 19 (text) and
  line 57 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][33], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][34], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 14 (text), line 43 (text), line 44 (text), line 45 (text) and line 47 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][35], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][36], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][37], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][38], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][39], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][40], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][41], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][42], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][43], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][44], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][45], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][46], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][47], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][48], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][49], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][50], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][51], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][52], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][53], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][54], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][55], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][56], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][57], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][58], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][59], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][60], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][61], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 29 (header) and line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][62], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

### Variants (2 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][63], in the cell automation × yaml: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][64], in the cell automation × csharp: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][65], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][66], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 93 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 275 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][67], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][68], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text); selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 294 (text).

## Keywords

- [world map][69]
- [track][70]
- [file language][71]
- [cell][72]
- [lit cell][73]
- [.claude][63]: a track
- [automation][63]: a track
- [docs][63]: a track
- [csharp][74]: a file language
- [markdown][74]: a file language
- [powershell][74]: a file language
- [yaml][74]: a file language

Terms the cited ADRs define:

- [occupant][75], defined by [ADR-DSGN-LIFE#5][76]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[5]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[6]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[7]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[8]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[9]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[10]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[11]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[12]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[13]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[14]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[15]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[16]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[17]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[18]: adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
[19]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[20]: adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md
[21]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
[22]: ../../explanation/design/clients-bridge-to-one-server.md
[23]: ../../explanation/design/code-wires-only-the-first-rungs.md
[24]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[25]: ../../explanation/design/deploying-is-not-integrating.md
[26]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[27]: ../../explanation/design/every-deploy-stage-is-main-only.md
[28]: ../../explanation/design/four-domains-promote-one-artifact.md
[29]: ../../explanation/design/guard-and-policies-by-command.md
[30]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[31]: ../../explanation/design/integrators-depend-on-an-occupant.md
[32]: ../../explanation/design/local-guard-and-server-policies.md
[33]: ../../explanation/design/merging-to-main-is-what-deploys.md
[34]: ../../explanation/design/one-door-in-one-stable-point-out.md
[35]: ../../explanation/design/one-way-climb-three-endings.md
[36]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[37]: ../../explanation/design/sync-from-the-last-certified-commit.md
[38]: ../../explanation/design/sync-point-rules-are-adr-only.md
[39]: ../../explanation/design/which-rung-gates-exist-in-code.md
[40]: ../../adr/repository/agent-definitions.md
[41]: ../../adr/repository/api-contracts.md
[42]: ../../adr/repository/controlled-vocabulary.md
[43]: ../../adr/repository/conventional-folders.md
[44]: ../../adr/repository/dedicated-output-directory.md
[45]: ../../adr/repository/documentation-examples.md
[46]: ../../adr/repository/domain-language-separation.md
[47]: ../../adr/repository/dora-explains.md
[48]: ../../adr/repository/generated-readmes.md
[49]: ../../adr/repository/generated-root-configs.md
[50]: ../../adr/repository/inspiration.md
[51]: ../../adr/repository/markdown-links.md
[52]: ../../adr/repository/output-formats.md
[53]: ../../adr/repository/uniform-formatting.md
[54]: ../../adr/design/dora-explains.md
[55]: ../../adr/design/module-aspects.md
[56]: ../../adr/design/run-modes.md
[57]: ../../adr/design/self-service.md
[58]: ../../adr/design/thin-platforms.md
[59]: ../../adr/design/tracks.md
[60]: ../../adr/design/visual-design.md
[61]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[62]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[63]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[64]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[65]: ../../adr/glossary.md
[66]: ../../adr/index.md
[67]: ../../../.claude/agents/write-drawio-files.md
[68]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[69]: ../../adr/glossary.md#world-map
[70]: ../../adr/glossary.md#track
[71]: ../../adr/glossary.md#file-language
[72]: ../../adr/glossary.md#cell
[73]: ../../adr/glossary.md#lit-cell
[74]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[75]: ../../adr/glossary.md#occupant
[76]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
