# docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md

`Grid minimap: adr-flow-cd-runner--a-step-only-names-a-command--meta`

![Grid minimap of adr-flow-cd-runner--a-step-only-names-a-command--meta](adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.png)

The grid minimap of the slide `adr-flow-cd-runner--a-step-only-names-a-command--meta` (meta lens). The slide supports
[ADR-FLOW-CD-RUNNER][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 1 lit of 95 files
- docs × markdown: 32 lit of 741 files
- pipelines × pipeline-yaml: 1 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/CLAUDE.md][5]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 52 (text).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 119 (text).

### docs × markdown (32 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 65 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: the file
  cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md][10]: selected by [ADR-FLOW-CD-RUNNER][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][11]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text) and line 29 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md][12]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 62 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][13]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 52 (text), line 64 (text), line 67 (text), line 70
  (text), line 72 (text), line 74 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 99 (text), line 101 (text), line 104 (text), line 106 (text), line 108 (text) and line 118 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md][14]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 39 (text), line 41 (text), line 43
  (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 53 (text), line 62 (text), line 64 (text), line 66 (text),
  line 68 (text), line 70 (text), line 72 (text), line 121 (text), line 128 (text), line 134 (text) and line 148 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][15]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md][16]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][17]: selected by [ADR-FLOW-CD-RUNNER][1]:
  the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text), line 46 (text), line 48 (text), line
  50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md][18]: selected by [ADR-FLOW-CD-RUNNER][1]:
  the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 38 (text), line
  40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][19]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md][20]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][21]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 41 (text), line 44 (text), line 46
  (text), line 48 (text), line 50 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text) and line 80 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md][22]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37
  (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text), line 61 (text), line 63 (text), line 70 (text), line 76 (text), line 83 (text) and line 89 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][23]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md][24]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][25]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 28 (text), line 35 (text), line 42 (text), line 45 (text), line 47
  (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text),
  line 64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text) and line 81 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md][26]: selected by
  [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 71 (text), line 77 (text), line 84 (text) and line 90 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][27]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/dora-explains.md][28]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/durable-sha-globs.md][29]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-detection.md][30]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/pipeline-types.md][31]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][32]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text).
- [docs/explanation/flow/a-step-only-names-a-command.md][33]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 14 (text), line
  41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][34]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][35]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 15 (text), line
  47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][36]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][37]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 17 (text),
  line 57 (text), line 58 (text) and line 59 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/steps/invoke-automation.yaml][38]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 18 (header).

## Keywords

- [world map][39]
- [track][40]
- [file language][41]
- [cell][42]
- [lit cell][43]
- [.claude][44]: a track
- [automation][44]: a track
- [docs][44]: a track
- [pipelines][44]: a track
- [markdown][45]: a file language
- [pipeline-yaml][45]: a file language
- [yaml][45]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/CLAUDE.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[8]: adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md
[9]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[10]: adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md
[11]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[12]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md
[13]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[14]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
[15]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[16]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
[17]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[18]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md
[19]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[20]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md
[21]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[22]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md
[23]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[24]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md
[25]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[26]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md
[27]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[28]: ../../adr/flow/dora-explains.md
[29]: ../../adr/flow/durable-sha-globs.md
[30]: ../../adr/flow/pipeline-detection.md
[31]: ../../adr/flow/pipeline-types.md
[32]: ../../adr/index.md
[33]: ../../explanation/flow/a-step-only-names-a-command.md
[34]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[35]: ../../explanation/flow/the-runner-is-the-only-seam.md
[36]: ../../explanation/flow/the-step-is-named-after-its-command.md
[37]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[38]: ../../../pipelines/steps/invoke-automation.yaml
[39]: ../../adr/glossary.md#world-map
[40]: ../../adr/glossary.md#track
[41]: ../../adr/glossary.md#file-language
[42]: ../../adr/glossary.md#cell
[43]: ../../adr/glossary.md#lit-cell
[44]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[45]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
