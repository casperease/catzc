# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md

`Tree minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Tree minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

The tree minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 50 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 18 lit files
- adr/repo (docs/adr/repository): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- Variants (automation/Catzc.Base.Variants): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (18 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/explanation/design/clients-bridge-to-one-server.md][4], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 15 (text), line 45
  (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][5], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][6], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][7], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][8], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][9], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][10], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][11], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 16 (text), line 48 (text) and line 51 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 16 (text) and
  line 50 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][12], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 16 (text), line
  19 (text), line 22 (text), line 49 (text), line 50 (text), line 50 (text) and line 52 (text); selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 16 (text), line 22 (text) and line 54 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][13], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][14], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 19 (text), line 55 (text) and line 58 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 19 (text) and
  line 57 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][15], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][16], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 14 (text), line 43 (text), line 44 (text), line 45 (text) and line 47 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][17], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][18], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][19], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][20], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][21], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][22], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][23], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][24], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][25], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][26], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][27], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][28], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][29], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][30], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][31], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][32], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][33], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][34], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][35], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][36], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][37], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][38], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][39], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][40], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][41], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][42], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][43], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 29 (header) and line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][44], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

### Variants (2 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][45], in the cell automation × yaml: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][46], in the cell automation × csharp: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][47], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][48], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 93 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 295 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][49], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][50], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text); selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 316 (text).

## Keywords

- [world map][51]
- [track][52]
- [file language][53]
- [cell][54]
- [lit cell][55]
- [.claude][45]: a track
- [automation][45]: a track
- [docs][45]: a track
- [csharp][56]: a file language
- [markdown][56]: a file language
- [powershell][56]: a file language
- [yaml][56]: a file language

Terms the cited ADRs define:

- [occupant][57], defined by [ADR-DSGN-LIFE#5][58]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: ../../explanation/design/clients-bridge-to-one-server.md
[5]: ../../explanation/design/code-wires-only-the-first-rungs.md
[6]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[7]: ../../explanation/design/deploying-is-not-integrating.md
[8]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[9]: ../../explanation/design/every-deploy-stage-is-main-only.md
[10]: ../../explanation/design/four-domains-promote-one-artifact.md
[11]: ../../explanation/design/guard-and-policies-by-command.md
[12]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[13]: ../../explanation/design/integrators-depend-on-an-occupant.md
[14]: ../../explanation/design/local-guard-and-server-policies.md
[15]: ../../explanation/design/merging-to-main-is-what-deploys.md
[16]: ../../explanation/design/one-door-in-one-stable-point-out.md
[17]: ../../explanation/design/one-way-climb-three-endings.md
[18]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[19]: ../../explanation/design/sync-from-the-last-certified-commit.md
[20]: ../../explanation/design/sync-point-rules-are-adr-only.md
[21]: ../../explanation/design/which-rung-gates-exist-in-code.md
[22]: ../../adr/repository/agent-definitions.md
[23]: ../../adr/repository/api-contracts.md
[24]: ../../adr/repository/controlled-vocabulary.md
[25]: ../../adr/repository/conventional-folders.md
[26]: ../../adr/repository/dedicated-output-directory.md
[27]: ../../adr/repository/documentation-examples.md
[28]: ../../adr/repository/domain-language-separation.md
[29]: ../../adr/repository/dora-explains.md
[30]: ../../adr/repository/generated-readmes.md
[31]: ../../adr/repository/generated-root-configs.md
[32]: ../../adr/repository/inspiration.md
[33]: ../../adr/repository/markdown-links.md
[34]: ../../adr/repository/output-formats.md
[35]: ../../adr/repository/uniform-formatting.md
[36]: ../../adr/design/dora-explains.md
[37]: ../../adr/design/module-aspects.md
[38]: ../../adr/design/run-modes.md
[39]: ../../adr/design/self-service.md
[40]: ../../adr/design/thin-platforms.md
[41]: ../../adr/design/tracks.md
[42]: ../../adr/design/visual-design.md
[43]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[44]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[45]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[46]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[47]: ../../adr/glossary.md
[48]: ../../adr/index.md
[49]: ../../../.claude/agents/write-drawio-files.md
[50]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[51]: ../../adr/glossary.md#world-map
[52]: ../../adr/glossary.md#track
[53]: ../../adr/glossary.md#file-language
[54]: ../../adr/glossary.md#cell
[55]: ../../adr/glossary.md#lit-cell
[56]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[57]: ../../adr/glossary.md#occupant
[58]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
