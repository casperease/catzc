# docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md

`Grid minimap: adr-dsgn-remote--one-door-in-one-stable-point-out--meta`

![Grid minimap of adr-dsgn-remote--one-door-in-one-stable-point-out--meta](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.png)

The grid minimap of the slide `adr-dsgn-remote--one-door-in-one-stable-point-out--meta` (meta lens). The slide supports
[ADR-DSGN-REMOTE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 2 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × yaml: 1 lit of 95 files
- docs × markdown: 35 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][5]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 100 (text).

### docs × markdown (35 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][6]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][7]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][8]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 35 (text), line 70 (text), line 71 (text), line 74 (text), line 76 (text), line 77 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text),
  line 98 (text), line 101 (text), line 115 (text), line 118 (text), line 122 (text) and line 126 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md][9]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text), line 66 (text), line 68 (text), line 82
  (text), line 85 (text), line 89 (text), line 93 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 124
  (text), line 127 (text), line 130 (text), line 133 (text), line 135 (text), line 144 (text) and line 158 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md][10]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md][11]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md][12]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 39 (text), line 40 (text), line 42
  (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 56 (text),
  line 58 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md][13]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][14]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 8 (text), line 29 (text), line 29 (text), line 40 (text) and line 40 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][15]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][16]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 8 (text), line 52 (text), line 88 (text), line 89 (text), line 92 (text), line 95 (text), line 96 (text), line
  99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115
  (text), line 117 (text), line 150 (text), line 164 (text), line 167 (text), line 172 (text) and line 176 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md][17]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 8 (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 68 (text), line 70 (text), line
  84 (text), line 88 (text), line 93 (text), line 98 (text), line 153 (text), line 156 (text), line 159 (text), line 162 (text), line 164
  (text), line 167 (text), line 170 (text), line 173 (text), line 175 (text), line 202 (text) and line 216 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md][18]: selected by
  [ADR-DSGN-REMOTE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md][19]: selected by
  [ADR-DSGN-REMOTE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md][20]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 39 (text), line 40 (text), line
  42 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 56 (text),
  line 58 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md][21]: selected by [ADR-DSGN-REMOTE][1]:
  the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line
  38 (text), line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md][22]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md][23]: selected by [ADR-DSGN-REMOTE][1]: the
  file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md][24]: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 39 (text), line 40 (text), line 42 (text),
  line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 56 (text), line 58
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md][25]: selected by [ADR-DSGN-REMOTE][1]: the file
  cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/adr/design/commit-lifecycle.md][26]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][27]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][28]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][29]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][30]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][1]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][31]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][32]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][33]: selected by [ADR-DSGN-REMOTE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][34]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 93 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][35]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 15 (text), line
  45 (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][36]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 16 (text),
  line 48 (text) and line 51 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][37]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 16 (text),
  line 19 (text), line 22 (text), line 49 (text), line 50 (text), line 50 (text) and line 52 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][38]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 19 (text),
  line 55 (text) and line 58 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][39]: selected by [ADR-DSGN-REMOTE][1]: the file cites it at line 14 (text),
  line 43 (text), line 44 (text), line 45 (text) and line 47 (text).

## Keywords

- [world map][40]
- [track][41]
- [file language][42]
- [cell][43]
- [lit cell][44]
- [automation][45]: a track
- [docs][45]: a track
- [markdown][46]: a file language
- [yaml][46]: a file language

[1]: ../../adr/design/server-remote-integration.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[6]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[7]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[8]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[9]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md
[10]: adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
[11]: adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
[12]: adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
[13]: adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md
[14]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[15]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[16]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[17]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
[18]: adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md
[19]: adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md
[20]: adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md
[21]: adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md
[22]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
[23]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
[24]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
[25]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md
[26]: ../../adr/design/commit-lifecycle.md
[27]: ../../adr/design/dora-explains.md
[28]: ../../adr/design/module-aspects.md
[29]: ../../adr/design/run-modes.md
[30]: ../../adr/design/self-service.md
[31]: ../../adr/design/thin-platforms.md
[32]: ../../adr/design/tracks.md
[33]: ../../adr/design/visual-design.md
[34]: ../../adr/index.md
[35]: ../../explanation/design/clients-bridge-to-one-server.md
[36]: ../../explanation/design/guard-and-policies-by-command.md
[37]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[38]: ../../explanation/design/local-guard-and-server-policies.md
[39]: ../../explanation/design/one-door-in-one-stable-point-out.md
[40]: ../../adr/glossary.md#world-map
[41]: ../../adr/glossary.md#track
[42]: ../../adr/glossary.md#file-language
[43]: ../../adr/glossary.md#cell
[44]: ../../adr/glossary.md#lit-cell
[45]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[46]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
