# docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md

`Grid minimap: adr-dsgn-remote--clients-bridge-to-one-server--architecture`

![Grid minimap of adr-dsgn-remote--clients-bridge-to-one-server--architecture](adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-remote--clients-bridge-to-one-server--architecture` (architecture lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-DSGN-REMOTE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks with the 18 file languages of the world map and lights 3 cells. A cell lit only by passing mentions
(citations in body comments, not in a file's header or text) is touched: drawn pale.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 47 lit of 469 files

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/agents/write-drawio-files.md][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][8]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (47 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][9]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][10]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][11]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][12]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][13]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][14]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][15]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][16]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][18]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][19]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][20]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][21]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][22]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 70 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md][23]: selected by [ADR-DSGN-REMOTE][2]: the
  file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][24]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 73 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md][25]: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md][26]: selected by [ADR-DSGN-REMOTE][2]: the
  file cites it at line 67 (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][27]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][28]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][29]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][30]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][2]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][31]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][32]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code;
  selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][33]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][34]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][35]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 93 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][36]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 15 (text), line 45 (text), line 46 (text) and
  line 48 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][37]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][38]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][39]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][40]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][41]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][42]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][43]: selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 16 (text),
  line 48 (text) and line 51 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][44]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 16 (text), line 19 (text), line 22 (text),
  line 49 (text), line 50 (text), line 50 (text) and line 52 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][45]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][46]: selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 19 (text),
  line 55 (text) and line 58 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][47]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][48]: selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 14 (text),
  line 43 (text), line 44 (text), line 45 (text) and line 47 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][49]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][50]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][51]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][52]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][53]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][54]
- [track][55]
- [file language][56]
- [cell][57]
- [lit cell][58]
- [.claude][59]: a track
- [automation][59]: a track
- [docs][59]: a track
- [markdown][60]: a file language
- [yaml][60]: a file language

Terms the cited ADRs define:

- [occupant][61], defined by [ADR-DSGN-LIFE#5][62]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/agents/write-drawio-files.md
[7]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[8]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[9]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[10]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[11]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[12]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[13]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[14]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[15]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[16]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[17]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[18]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[19]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[20]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[21]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[22]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[23]: adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
[24]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[25]: adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md
[26]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
[27]: ../../adr/design/dora-explains.md
[28]: ../../adr/design/module-aspects.md
[29]: ../../adr/design/run-modes.md
[30]: ../../adr/design/self-service.md
[31]: ../../adr/design/thin-platforms.md
[32]: ../../adr/design/tracks.md
[33]: ../../adr/design/visual-design.md
[34]: ../../adr/glossary.md
[35]: ../../adr/index.md
[36]: ../../explanation/design/clients-bridge-to-one-server.md
[37]: ../../explanation/design/code-wires-only-the-first-rungs.md
[38]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[39]: ../../explanation/design/deploying-is-not-integrating.md
[40]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[41]: ../../explanation/design/every-deploy-stage-is-main-only.md
[42]: ../../explanation/design/four-domains-promote-one-artifact.md
[43]: ../../explanation/design/guard-and-policies-by-command.md
[44]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[45]: ../../explanation/design/integrators-depend-on-an-occupant.md
[46]: ../../explanation/design/local-guard-and-server-policies.md
[47]: ../../explanation/design/merging-to-main-is-what-deploys.md
[48]: ../../explanation/design/one-door-in-one-stable-point-out.md
[49]: ../../explanation/design/one-way-climb-three-endings.md
[50]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[51]: ../../explanation/design/sync-from-the-last-certified-commit.md
[52]: ../../explanation/design/sync-point-rules-are-adr-only.md
[53]: ../../explanation/design/which-rung-gates-exist-in-code.md
[54]: ../../adr/glossary.md#world-map
[55]: ../../adr/glossary.md#track
[56]: ../../adr/glossary.md#file-language
[57]: ../../adr/glossary.md#cell
[58]: ../../adr/glossary.md#lit-cell
[59]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[60]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[61]: ../../adr/glossary.md#occupant
[62]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
