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
- docs × markdown: 12 lit of 742 files
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

### docs × markdown (12 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][7]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR
  domain of that code.
- [docs/adr/flow/dora-explains.md][8]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/durable-sha-globs.md][9]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-detection.md][10]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-runner-pattern.md][1]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/pipeline-types.md][11]: selected by [ADR-FLOW-CD-RUNNER][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][12]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 108 (text).
- [docs/explanation/flow/a-step-only-names-a-command.md][13]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 14 (text), line
  41 (text) and line 42 (text).
- [docs/explanation/flow/no-gate-checks-rules-one-and-four.md][14]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 51 (text), line 52 (text), line 53 (text) and line 54 (text).
- [docs/explanation/flow/the-runner-is-the-only-seam.md][15]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 15 (text), line
  47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/flow/the-step-is-named-after-its-command.md][16]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 16
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/three-tasks-one-guard-one-runner.md][17]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 17 (text),
  line 57 (text), line 58 (text) and line 59 (text).

### pipelines × pipeline-yaml (1 lit file)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/steps/invoke-automation.yaml][18]: selected by [ADR-FLOW-CD-RUNNER][1]: the file cites it at line 18 (header).

## Keywords

- [world map][19]
- [track][20]
- [file language][21]
- [cell][22]
- [lit cell][23]
- [.claude][24]: a track
- [automation][24]: a track
- [docs][24]: a track
- [pipelines][24]: a track
- [markdown][25]: a file language
- [pipeline-yaml][25]: a file language
- [yaml][25]: a file language

[1]: ../../adr/flow/pipeline-runner-pattern.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/CLAUDE.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[8]: ../../adr/flow/dora-explains.md
[9]: ../../adr/flow/durable-sha-globs.md
[10]: ../../adr/flow/pipeline-detection.md
[11]: ../../adr/flow/pipeline-types.md
[12]: ../../adr/index.md
[13]: ../../explanation/flow/a-step-only-names-a-command.md
[14]: ../../explanation/flow/no-gate-checks-rules-one-and-four.md
[15]: ../../explanation/flow/the-runner-is-the-only-seam.md
[16]: ../../explanation/flow/the-step-is-named-after-its-command.md
[17]: ../../explanation/flow/three-tasks-one-guard-one-runner.md
[18]: ../../../pipelines/steps/invoke-automation.yaml
[19]: ../../adr/glossary.md#world-map
[20]: ../../adr/glossary.md#track
[21]: ../../adr/glossary.md#file-language
[22]: ../../adr/glossary.md#cell
[23]: ../../adr/glossary.md#lit-cell
[24]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[25]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
