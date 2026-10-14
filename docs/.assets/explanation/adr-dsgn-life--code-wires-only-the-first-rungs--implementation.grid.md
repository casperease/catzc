# docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md

`Grid minimap: adr-dsgn-life--code-wires-only-the-first-rungs--implementation`

![Grid minimap of adr-dsgn-life--code-wires-only-the-first-rungs--implementation](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.png)

The grid minimap of the slide `adr-dsgn-life--code-wires-only-the-first-rungs--implementation` (implementation lens). The slide supports
[ADR-DSGN-LIFE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 3 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 86 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/agents/write-drawio-files.md][5]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][6]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text).

### docs × markdown (86 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][8]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text), line 42 (text) and line 56
  (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][9]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][10]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text), line 45 (text), line 47
  (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text),
  line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md][11]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95 (text), line 97 (text),
  line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text),
  line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][12]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][13]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][14]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md][15]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][16]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][17]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][18]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text), line
  55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107
  (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 125
  (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md][19]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text), line 41 (text), line 43 (text), line
  45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 85
  (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107 (text), line 110 (text), line 113 (text),
  line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129 (text), line 139 (text), line 148 (text),
  line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][20]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][21]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][22]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line
  75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][23]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line
  45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][24]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and
  line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][25]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][26]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text),
  line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text),
  line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text),
  line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md][27]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text),
  line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83
  (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text),
  line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text),
  line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][28]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][29]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][30]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75
  (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][31]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][32]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][33]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][34]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75
  (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][35]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][36]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and line 66
  (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][37]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][38]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text),
  line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text),
  line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text),
  line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md][39]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text),
  line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83
  (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text),
  line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text),
  line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][40]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][41]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][42]: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107
  (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 125
  (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md][43]: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 85
  (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107 (text), line 110 (text), line 113 (text),
  line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129 (text), line 139 (text), line 148 (text),
  line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][44]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and line 66
  (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][45]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][46]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line
  126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md][47]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text), line 65
  (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text), line
  114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text), line
  149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][48]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text), line 42 (text) and line 56
  (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][49]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][50]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 7 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text), line 45 (text), line 47 (text),
  line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65
  (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 78 (text), line 80 (text),
  line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91 (text), line 93 (text), line 95
  (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md][51]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 7 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 58
  (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95 (text), line 97 (text), line 99
  (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text), line 119
  (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][52]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and line 76
  (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][53]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][54]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75 (text),
  line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line 118
  (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142
  (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][55]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text),
  line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128 (text), line
  130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167 (text), line
  175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][56]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 51 (text), line 65 (text), line 65 (text) and line 97
  (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][57]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][58]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 39 (text), line 687 (text), line 699 (text), line 723 (text), line 726 (text), line 727 (text), line 730
  (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739 (text), line 741 (text), line 744 (text), line 746
  (text), line 749 (text), line 752 (text), line 754 (text), line 849 (text), line 851 (text), line 853 (text), line 855 (text), line 857
  (text), line 859 (text), line 861 (text), line 863 (text), line 865 (text), line 879 (text), line 881 (text), line 890 (text), line 892
  (text), line 894 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text), line 907 (text), line 909 (text), line 912
  (text), line 914 (text), line 918 (text), line 921 (text), line 923 (text), line 928 (text) and line 1013 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][59]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 336 (text), line 338 (text), line 341 (text), line 343 (text), line 345 (text), line 348 (text), line 350
  (text), line 352 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 365 (text), line 369 (text), line 371
  (text), line 394 (text), line 396 (text), line 398 (text), line 401 (text), line 404 (text), line 406 (text), line 408 (text), line 411
  (text), line 413 (text), line 416 (text), line 418 (text), line 422 (text), line 425 (text), line 427 (text), line 433 (text), line 567
  (text), line 729 (text), line 925 (text), line 928 (text), line 931 (text), line 934 (text), line 936 (text), line 939 (text), line 942
  (text), line 945 (text), line 947 (text), line 1024 (text), line 1210 (text), line 1213 (text) and line 1297 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][60]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 55 (text), line 55 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][61]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][62]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 34 (text), line 36 (text), line 43 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text),
  line 67 (text), line 69 (text), line 73 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 103 (text), line 105 (text),
  line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 117 (text), line 120 (text), line 124 (text), line 128 (text),
  line 130 (text), line 132 (text), line 134 (text), line 137 (text) and line 155 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md][63]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42
  (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 61 (text),
  line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 84 (text), line 87
  (text), line 91 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 104 (text), line 112 (text), line 115
  (text), line 118 (text), line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line 134 (text), line 142
  (text), line 143 (text), line 150 (text), line 157 (text), line 164 (text) and line 182 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][64]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text), line 56 (text), line 56 (text) and line 78
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][65]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][66]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 29 (text), line 51 (text), line 53 (text), line 61 (text), line 64 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 85 (text), line 87 (text), line 91 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line
  108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 117 (text), line 149 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 166 (text), line 170 (text), line 174 (text), line
  178 (text), line 180 (text), line 182 (text), line 184 (text), line 187 (text) and line 207 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md][67]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 63 (text),
  line 69 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 87 (text), line 91
  (text), line 96 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 152 (text), line 155
  (text), line 158 (text), line 161 (text), line 163 (text), line 166 (text), line 169 (text), line 172 (text), line 174 (text), line 184
  (text), line 200 (text), line 201 (text), line 208 (text), line 215 (text) and line 236 (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][68]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][69]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][70]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][71]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][72]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][73]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][74]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][75]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/glossary.md][76]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][77]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][78]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][79]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][80]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][81]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][82]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][83]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][84]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][85]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][86]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][87]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][88]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line 41
  (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][89]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][90]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12 (text),
  line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][91]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][92]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text).

## Keywords

- [world map][93]
- [track][94]
- [file language][95]
- [cell][96]
- [lit cell][97]
- [.claude][98]: a track
- [automation][98]: a track
- [docs][98]: a track
- [markdown][99]: a file language
- [yaml][99]: a file language

Terms the cited ADRs define:

- [occupant][100], defined by [ADR-DSGN-LIFE#5][101]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/agents/write-drawio-files.md
[6]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[7]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[8]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[9]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[10]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[11]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md
[12]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[13]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[14]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[15]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
[16]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[17]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[18]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[19]: adr-dsgn-life--deploying-is-not-integrating--meta.tree.md
[20]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[21]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[22]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[23]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[24]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[25]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[26]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[27]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md
[28]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[29]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[30]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[31]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[32]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[33]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[34]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[35]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[36]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[37]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[38]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[39]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md
[40]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[41]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[42]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[43]: adr-dsgn-life--one-way-climb-three-endings--meta.tree.md
[44]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[45]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[46]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[47]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md
[48]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[49]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[50]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[51]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md
[52]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[53]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[54]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[55]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[56]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[57]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[58]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[59]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[60]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[61]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[62]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[63]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md
[64]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[65]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[66]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[67]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
[68]: ../../adr/design/dora-explains.md
[69]: ../../adr/design/module-aspects.md
[70]: ../../adr/design/run-modes.md
[71]: ../../adr/design/self-service.md
[72]: ../../adr/design/server-remote-integration.md
[73]: ../../adr/design/thin-platforms.md
[74]: ../../adr/design/tracks.md
[75]: ../../adr/design/visual-design.md
[76]: ../../adr/glossary.md
[77]: ../../adr/index.md
[78]: ../../explanation/design/clients-bridge-to-one-server.md
[79]: ../../explanation/design/code-wires-only-the-first-rungs.md
[80]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[81]: ../../explanation/design/deploying-is-not-integrating.md
[82]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[83]: ../../explanation/design/every-deploy-stage-is-main-only.md
[84]: ../../explanation/design/four-domains-promote-one-artifact.md
[85]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[86]: ../../explanation/design/integrators-depend-on-an-occupant.md
[87]: ../../explanation/design/merging-to-main-is-what-deploys.md
[88]: ../../explanation/design/one-way-climb-three-endings.md
[89]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[90]: ../../explanation/design/sync-from-the-last-certified-commit.md
[91]: ../../explanation/design/sync-point-rules-are-adr-only.md
[92]: ../../explanation/design/which-rung-gates-exist-in-code.md
[93]: ../../adr/glossary.md#world-map
[94]: ../../adr/glossary.md#track
[95]: ../../adr/glossary.md#file-language
[96]: ../../adr/glossary.md#cell
[97]: ../../adr/glossary.md#lit-cell
[98]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[99]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[100]: ../../adr/glossary.md#occupant
[101]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
