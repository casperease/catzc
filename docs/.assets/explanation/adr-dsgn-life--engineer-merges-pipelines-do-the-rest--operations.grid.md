# docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md

`Grid minimap: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations`

![Grid minimap of adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.png)

The grid minimap of the slide `adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations` (operations lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 3 lit of 9 files
- automation × csharp: 2 lit of 219 files
- automation × powershell: 3 lit of 1400 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 120 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (3 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][7]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43 (text).
- [.claude/drawio/STYLE.md][8]: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### automation × csharp (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][9]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][10]: selected by [ADR-FLOW-CD][2]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][11]: selected by [ADR-FLOW-CD][2]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][12]: selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][13]: selected by [ADR-FLOW-CD][2]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][14]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 99 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][15]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 52 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][16]: selected by [ADR-FLOW-CD][2]: the file cites it at line 62 (text).

### docs × markdown (120 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][17]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text), line 42 (text) and
  line 56 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][18]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][19]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text), line 45 (text), line 47
  (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text),
  line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md][20]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95 (text), line 97 (text),
  line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text),
  line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][21]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][22]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][23]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md][24]: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][25]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][26]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][27]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text), line
  55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107
  (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 125
  (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md][28]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text), line 41 (text), line 43 (text), line
  45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 85
  (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107 (text), line 110 (text), line 113 (text),
  line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129 (text), line 139 (text), line 148 (text),
  line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][29]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39
  (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][30]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 72 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][31]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line
  75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50 (text),
  line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text), line 99
  (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text), line 168
  (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and line 203
  (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][32]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line
  45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text),
  line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110
  (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155
  (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186
  (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235
  (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][33]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and
  line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][34]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][35]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text),
  line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text),
  line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text),
  line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md][36]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text),
  line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83
  (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text),
  line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text),
  line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][37]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39
  (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][38]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 71 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][39]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75
  (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50 (text),
  line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text), line 99
  (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text), line 168
  (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and line 203
  (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][40]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text),
  line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110
  (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155
  (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186
  (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235
  (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][41]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and
  line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39
  (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][42]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][43]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75
  (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line
  118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line
  160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50 (text),
  line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text), line 99
  (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text), line 168
  (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and line 203
  (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][44]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text),
  line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167
  (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text),
  line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110
  (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155
  (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186
  (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235
  (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][45]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and line 66
  (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][46]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][47]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text),
  line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text),
  line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text),
  line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md][48]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text),
  line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83
  (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text),
  line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text),
  line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][49]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][50]: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][51]: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107
  (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 125
  (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md][52]: selected by [ADR-DSGN-LIFE][1]: the file cites it
  at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 85
  (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107 (text), line 110 (text), line 113 (text),
  line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129 (text), line 139 (text), line 148 (text),
  line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][53]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text), line 49 (text) and line 66
  (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][54]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][55]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line
  126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md][56]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text), line 42 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60 (text), line 62 (text), line 65
  (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108 (text), line 111 (text), line
  114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 140 (text), line
  149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][57]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text), line 42 (text) and line 56
  (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][58]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][59]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 7 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text), line 45 (text), line 47 (text),
  line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65
  (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 78 (text), line 80 (text),
  line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91 (text), line 93 (text), line 95
  (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md][60]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 7 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 58
  (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95 (text), line 97 (text), line 99
  (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text), line 119
  (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][61]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text), line 58 (text) and line 76
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text),
  line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][62]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 65 (text) and line 74 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][63]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text), line 73 (text), line 75 (text),
  line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line 118
  (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142
  (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50 (text),
  line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text), line 99
  (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text), line 168
  (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and line 203
  (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][64]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61 (text), line 63 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 89 (text), line 91 (text),
  line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line 126 (text), line 128 (text), line
  130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 167 (text), line
  175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line
  8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text), line 69 (text),
  line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110 (text), line
  112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line
  157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186 (text), line
  188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][65]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 51 (text), line 65 (text), line 65 (text) and line 97
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 29 (text), line 43 (text), line 43 (text),
  line 57 (text), line 57 (text), line 71 (text), line 71 (text), line 96 (text) and line 100 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][66]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 67 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][67]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 39 (text), line 687 (text), line 699 (text), line 723 (text), line 726 (text), line 727 (text), line 730
  (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739 (text), line 741 (text), line 744 (text), line 746
  (text), line 749 (text), line 752 (text), line 754 (text), line 849 (text), line 851 (text), line 853 (text), line 855 (text), line 857
  (text), line 859 (text), line 861 (text), line 863 (text), line 865 (text), line 879 (text), line 881 (text), line 890 (text), line 892
  (text), line 894 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text), line 907 (text), line 909 (text), line 912
  (text), line 914 (text), line 918 (text), line 921 (text), line 923 (text), line 928 (text) and line 1013 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 42 (text), line 49 (text), line 52 (text), line 309 (text),
  line 310 (text), line 316 (text), line 688 (text), line 700 (text), line 705 (text), line 730 (text), line 734 (text), line 736 (text),
  line 747 (text), line 750 (text), line 756 (text), line 759 (text), line 760 (text), line 762 (text), line 764 (text), line 867 (text),
  line 869 (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 879 (text), line 882 (text), line 901 (text),
  line 905 (text), line 911 (text), line 925 (text), line 930 (text), line 931 (text), line 933 (text), line 935 (text), line 939 (text),
  line 943 (text), line 1012 (text) and line 1016 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][68]: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 8 (text), line 336 (text), line 338 (text), line 341 (text), line 343 (text), line 345 (text), line 348 (text), line 350
  (text), line 352 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 365 (text), line 369 (text), line 371
  (text), line 394 (text), line 396 (text), line 398 (text), line 401 (text), line 404 (text), line 406 (text), line 408 (text), line 411
  (text), line 413 (text), line 416 (text), line 418 (text), line 422 (text), line 425 (text), line 427 (text), line 433 (text), line 567
  (text), line 729 (text), line 925 (text), line 928 (text), line 931 (text), line 934 (text), line 936 (text), line 939 (text), line 942
  (text), line 945 (text), line 947 (text), line 1024 (text), line 1210 (text), line 1213 (text) and line 1297 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 114 (text), line 343 (text), line 348 (text), line 350 (text), line 362 (text),
  line 366 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 405 (text), line 409 (text),
  line 415 (text), line 429 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 446 (text), line 450 (text),
  line 568 (text), line 632 (text), line 635 (text), line 730 (text), line 846 (text), line 847 (text), line 858 (text), line 1016 (text),
  line 1027 (text), line 1033 (text), line 1035 (text), line 1037 (text), line 1039 (text), line 1041 (text), line 1043 (text), line 1211
  (text), line 1214 (text), line 1296 (text) and line 1300 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][69]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 55 (text), line 55 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][70]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][71]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 27 (text), line 34 (text), line 36 (text), line 43 (text), line 46 (text), line 47 (text), line 49
  (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text),
  line 67 (text), line 69 (text), line 73 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 103 (text), line 105 (text),
  line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 117 (text), line 120 (text), line 124 (text), line 128 (text),
  line 130 (text), line 132 (text), line 134 (text), line 137 (text) and line 155 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md][72]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42
  (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 61 (text),
  line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 84 (text), line 87
  (text), line 91 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 104 (text), line 112 (text), line 115
  (text), line 118 (text), line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line 134 (text), line 142
  (text), line 143 (text), line 150 (text), line 157 (text), line 164 (text) and line 182 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][73]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text), line 56 (text), line 56 (text) and line 78
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][74]: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][75]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 29 (text), line 51 (text), line 53 (text), line 61 (text), line 64 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 85 (text), line 87 (text), line 91 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line
  108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 117 (text), line 149 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 166 (text), line 170 (text), line 174 (text), line
  178 (text), line 180 (text), line 182 (text), line 184 (text), line 187 (text) and line 207 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md][76]: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44
  (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 63 (text),
  line 69 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 87 (text), line 91
  (text), line 96 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 109 (text), line 152 (text), line 155
  (text), line 158 (text), line 161 (text), line 163 (text), line 166 (text), line 169 (text), line 172 (text), line 174 (text), line 184
  (text), line 200 (text), line 201 (text), line 208 (text), line 215 (text) and line 236 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][77]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 8 (text), line 41 (text), line 41 (text), line 49 (text), line 49 (text), line 57 (text), line 57 (text), line
  65 (text), line 65 (text), line 91 (text) and line 93 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][78]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 61 (text), line 63 (text), line 189 (text), line 195 (text), line 209
  (text), line 245 (text), line 259 (text), line 260 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 280
  (text), line 293 (text), line 296 (text), line 297 (text), line 299 (text), line 301 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 353 (text), line 355 (text), line 392 (text), line 396 (text), line 400
  (text), line 409 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 436 (text), line 444 (text), line 498
  (text) and line 500 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][79]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 98 (text), line 102 (text), line 106 (text), line 115 (text), line 123
  (text), line 125 (text), line 127 (text), line 129 (text), line 143 (text), line 151 (text), line 263 (text), line 270 (text), line 288
  (text), line 367 (text), line 383 (text), line 385 (text), line 440 (text), line 455 (text), line 458 (text), line 460 (text), line 462
  (text), line 465 (text), line 468 (text), line 520 (text), line 522 (text), line 535 (text), line 544 (text), line 547 (text), line 588
  (text) and line 590 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][80]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51
  (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][81]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][82]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48 (text), line 56
  (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text),
  line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md][83]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][84]: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][85]: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][86]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line
  48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90
  (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md][87]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line
  43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text),
  line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][88]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61
  (text), line 61 (text), line 78 (text) and line 79 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][89]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][90]: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 30 (text), line 31 (text), line 42 (text), line 44 (text), line 61 (text), line 62 (text), line 63 (text),
  line 73 (text), line 75 (text), line 76 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 96 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line 118 (text), line 119 (text), line 121 (text), line 123
  (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 134 (text), line 136 (text), line 166 (text) and line 167
  (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md][91]: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text),
  line 50 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 74 (text), line 76 (text), line 100 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 118 (text), line 120 (text), line 122 (text), line 129 (text), line 131 (text), line 133
  (text), line 140 (text), line 141 (text), line 147 (text), line 149 (text), line 179 (text), line 186 (text), line 208 (text) and line 209
  (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][92]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51
  (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][93]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][94]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48 (text), line 56
  (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text),
  line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md][95]: selected by [ADR-FLOW-CD][2]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][96]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51
  (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][97]: selected by [ADR-FLOW-CD][2]:
  the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][98]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48
  (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90
  (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md][99]: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43
  (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text),
  line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/adr/design/commit-lifecycle.md][1]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][100]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][101]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][102]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][103]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][104]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][105]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][106]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][107]: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][108]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][109]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-detection.md][110]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][111]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-types.md][112]: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][113]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][114]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 107 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][115]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text), line
  49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][116]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text) and
  line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][117]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15
  (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][118]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 14 (text), line
  43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][119]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17
  (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][120]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 11 (text),
  line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][121]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][122]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 16 (text),
  line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][123]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text), line
  50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][124]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 15 (text),
  line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][125]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 13 (text), line
  41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][126]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 6 (text), line
  15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][127]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 12
  (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][128]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text), line
  31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45 (text), line 49 (text), line 50 (text),
  line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text), line
  34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][129]: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][130]: selected by [ADR-FLOW-CD][2]: the file cites it at line 16 (text), line 48
  (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][131]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][132]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text),
  line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][133]: selected by [ADR-FLOW-CD][2]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][134]: selected by [ADR-FLOW-CD][2]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

## Keywords

- [world map][135]
- [track][136]
- [file language][137]
- [cell][138]
- [lit cell][139]
- [.claude][140]: a track
- [automation][140]: a track
- [docs][140]: a track
- [csharp][141]: a file language
- [markdown][141]: a file language
- [powershell][141]: a file language
- [yaml][141]: a file language

Terms the cited ADRs define:

- [gate][142], defined by [ADR-FLOW-CD#13][143]
- [occupant][144], defined by [ADR-DSGN-LIFE#5][145]
- [release candidate][146], defined by [ADR-FLOW-CD#14][147]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../.claude/agents/write-drawio-files.md
[8]: ../../../.claude/drawio/STYLE.md
[9]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[10]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[11]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[12]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[13]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[14]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[15]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[16]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[17]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[18]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[19]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[20]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md
[21]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[22]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[23]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[24]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
[25]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[26]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[27]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[28]: adr-dsgn-life--deploying-is-not-integrating--meta.tree.md
[29]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[30]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[31]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[32]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[33]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[34]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[35]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[36]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md
[37]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[38]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[39]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[40]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[41]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[42]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[43]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[44]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[45]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[46]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[47]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[48]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md
[49]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[50]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[51]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[52]: adr-dsgn-life--one-way-climb-three-endings--meta.tree.md
[53]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[54]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[55]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[56]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md
[57]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[58]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[59]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[60]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md
[61]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[62]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[63]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[64]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[65]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[66]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[67]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[68]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[69]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[70]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[71]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[72]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md
[73]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[74]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[75]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[76]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
[77]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[78]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[79]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[80]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[81]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[82]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[83]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
[84]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[85]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[86]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[87]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
[88]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[89]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[90]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[91]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md
[92]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[93]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[94]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[95]: adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md
[96]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[97]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[98]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[99]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
[100]: ../../adr/design/dora-explains.md
[101]: ../../adr/design/module-aspects.md
[102]: ../../adr/design/run-modes.md
[103]: ../../adr/design/self-service.md
[104]: ../../adr/design/server-remote-integration.md
[105]: ../../adr/design/thin-platforms.md
[106]: ../../adr/design/tracks.md
[107]: ../../adr/design/visual-design.md
[108]: ../../adr/flow/dora-explains.md
[109]: ../../adr/flow/durable-sha-globs.md
[110]: ../../adr/flow/pipeline-detection.md
[111]: ../../adr/flow/pipeline-runner-pattern.md
[112]: ../../adr/flow/pipeline-types.md
[113]: ../../adr/glossary.md
[114]: ../../adr/index.md
[115]: ../../explanation/design/clients-bridge-to-one-server.md
[116]: ../../explanation/design/code-wires-only-the-first-rungs.md
[117]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[118]: ../../explanation/design/deploying-is-not-integrating.md
[119]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[120]: ../../explanation/design/every-deploy-stage-is-main-only.md
[121]: ../../explanation/design/four-domains-promote-one-artifact.md
[122]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[123]: ../../explanation/design/integrators-depend-on-an-occupant.md
[124]: ../../explanation/design/merging-to-main-is-what-deploys.md
[125]: ../../explanation/design/one-way-climb-three-endings.md
[126]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[127]: ../../explanation/design/sync-from-the-last-certified-commit.md
[128]: ../../explanation/design/sync-point-rules-are-adr-only.md
[129]: ../../explanation/design/which-rung-gates-exist-in-code.md
[130]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[131]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[132]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[133]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[134]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[135]: ../../adr/glossary.md#world-map
[136]: ../../adr/glossary.md#track
[137]: ../../adr/glossary.md#file-language
[138]: ../../adr/glossary.md#cell
[139]: ../../adr/glossary.md#lit-cell
[140]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[141]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[142]: ../../adr/glossary.md#gate
[143]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[144]: ../../adr/glossary.md#occupant
[145]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[146]: ../../adr/glossary.md#release-candidate
[147]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
