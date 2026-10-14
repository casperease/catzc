# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md

`Grid minimap: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance`

![Grid minimap of adr-flow-cd--ci-budget-is-the-only-quality-gate--governance](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.png)

The grid minimap of the slide `adr-flow-cd--ci-budget-is-the-only-quality-gate--governance` (governance lens). The slide supports
[ADR-FLOW-CD][1] and [ADR-FLOW-CD-TYPE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 2 lit of 9 files
- automation × csharp: 4 lit of 219 files
- automation × powershell: 8 lit of 1400 files
- automation × yaml: 4 lit of 95 files
- docs × markdown: 61 lit of 741 files
- pipelines × pipeline-yaml: 2 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (2 lit files)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [.claude/CLAUDE.md][6]: selected by [ADR-FLOW-CD][1]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][7]: selected by [ADR-FLOW-CD][1]: the file cites it at line 28 (text).

### automation × csharp (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][8]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 3 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][9]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][10]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (header), line 18
  (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][11]: selected by [ADR-FLOW-CD][1]: the file cites it at line 41 (body comment) (a
  passing mention only).

### automation × powershell (8 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][12]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][13]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it
  at line 9 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][14]: selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 12 (header).
- [automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1][15]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1][16]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 5
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][17]: selected by [ADR-FLOW-CD][1]: the file cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][18]: selected by [ADR-FLOW-CD][1]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][19]: selected by [ADR-FLOW-CD][1]: the file cites it at line 70 (text)
  and line 71 (text).

### automation × yaml (4 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][3]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][20]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at
  line 2 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][21]: selected by [ADR-FLOW-CD][1]: the file cites it at line 105 (body comment) and line 118
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 121 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][22]: selected by [ADR-FLOW-CD][1]: the file cites it at line 21 (text).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][23]: selected by [ADR-FLOW-CD][1]: the file cites it at line 62 (text).

### docs × markdown (61 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][3]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][24]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line
  61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][25]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][26]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50
  (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text),
  line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text),
  line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text),
  line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and
  line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][27]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text),
  line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text),
  line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and
  line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][28]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61
  (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][29]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][30]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50
  (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text),
  line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text),
  line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text),
  line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and
  line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][31]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text),
  line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text),
  line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and
  line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][32]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61
  (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][33]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][34]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50
  (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text),
  line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text),
  line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text),
  line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and
  line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][35]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text),
  line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text),
  line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and
  line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][36]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text),
  line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][37]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][38]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text), line 49 (text), line 50 (text),
  line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92 (text), line 94 (text), line 99
  (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127 (text), line 128 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151 (text), line 156 (text), line 168
  (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 201 (text) and line 203
  (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][39]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line 65 (text), line 67 (text),
  line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104 (text), line 109 (text), line 110
  (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151 (text), line 153 (text), line 155
  (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177 (text), line 179 (text), line 186
  (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213 (text), line 233 (text) and line 235
  (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][40]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 29 (text), line 29 (text), line 43 (text), line 43 (text), line 57 (text), line 57 (text), line 71 (text),
  line 71 (text), line 96 (text) and line 100 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][41]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][42]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 32 (text), line 42 (text), line 49 (text), line 52 (text), line 309 (text), line 310 (text), line 316
  (text), line 688 (text), line 700 (text), line 705 (text), line 730 (text), line 734 (text), line 736 (text), line 747 (text), line 750
  (text), line 756 (text), line 759 (text), line 760 (text), line 762 (text), line 764 (text), line 867 (text), line 869 (text), line 870
  (text), line 872 (text), line 874 (text), line 876 (text), line 879 (text), line 882 (text), line 901 (text), line 905 (text), line 911
  (text), line 925 (text), line 930 (text), line 931 (text), line 933 (text), line 935 (text), line 939 (text), line 943 (text), line 1012
  (text) and line 1016 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][43]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 114 (text), line 343 (text), line 348 (text), line 350 (text), line 362 (text), line 366 (text), line 373
  (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 405 (text), line 409 (text), line 415 (text), line 429
  (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 446 (text), line 450 (text), line 568 (text), line 632
  (text), line 635 (text), line 730 (text), line 846 (text), line 847 (text), line 858 (text), line 1016 (text), line 1027 (text), line 1033
  (text), line 1035 (text), line 1037 (text), line 1039 (text), line 1041 (text), line 1043 (text), line 1211 (text), line 1214 (text), line
  1296 (text) and line 1300 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][44]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 8 (text), line 41 (text), line 41 (text), line 49 (text), line 49 (text), line 57 (text), line 57 (text), line
  65 (text), line 65 (text), line 91 (text) and line 93 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][45]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 61 (text), line 63 (text), line 189 (text), line 195 (text), line 209
  (text), line 245 (text), line 259 (text), line 260 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line 280
  (text), line 293 (text), line 296 (text), line 297 (text), line 299 (text), line 301 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 353 (text), line 355 (text), line 392 (text), line 396 (text), line 400
  (text), line 409 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 436 (text), line 444 (text), line 498
  (text) and line 500 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][46]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 98 (text), line 102 (text), line 106 (text), line 115 (text), line 123
  (text), line 125 (text), line 127 (text), line 129 (text), line 143 (text), line 151 (text), line 263 (text), line 270 (text), line 288
  (text), line 367 (text), line 383 (text), line 385 (text), line 440 (text), line 455 (text), line 458 (text), line 460 (text), line 462
  (text), line 465 (text), line 468 (text), line 520 (text), line 522 (text), line 535 (text), line 544 (text), line 547 (text), line 588
  (text) and line 590 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][47]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51
  (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][48]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][49]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48 (text), line 56
  (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text),
  line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md][50]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][51]: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][52]: selected by
  [ADR-FLOW-CD][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][53]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line
  48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90
  (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md][54]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line
  43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text),
  line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][55]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61
  (text), line 61 (text), line 78 (text) and line 79 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 8 (text), line 31
  (text), line 31 (text), line 42 (text), line 42 (text), line 53 (text), line 53 (text), line 64 (text) and line 64 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][56]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 60 (text) and line 71 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][57]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 30 (text), line 31 (text), line 42 (text), line 44 (text), line 61 (text), line 62 (text), line 63 (text),
  line 73 (text), line 75 (text), line 76 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 96 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line 118 (text), line 119 (text), line 121 (text), line 123
  (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 134 (text), line 136 (text), line 166 (text) and line 167
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 8 (text), line 38 (text), line 40 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 59 (text), line 71 (text), line 74 (text), line 98 (text), line 104 (text), line 106 (text),
  line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 133 (text), line 144 (text) and line 145 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md][58]: selected by [ADR-FLOW-CD][1]: the file
  cites it at line 8 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text),
  line 50 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 74 (text), line 76 (text), line 100 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 118 (text), line 120 (text), line 122 (text), line 129 (text), line 131 (text), line 133
  (text), line 140 (text), line 141 (text), line 147 (text), line 149 (text), line 179 (text), line 186 (text), line 208 (text) and line 209
  (text); selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 8 (text), line 50 (text), line 72 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 101 (text), line 104 (text), line 106 (text), line 108
  (text), line 110 (text), line 112 (text), line 119 (text), line 150 (text), line 156 (text), line 158 (text), line 165 (text) and line 173
  (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][59]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 7 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text), line 51
  (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][60]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][61]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48 (text), line 56
  (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text),
  line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md][62]: selected by [ADR-FLOW-CD][1]: the file cites it
  at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text), line 115
  (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][63]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51
  (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][64]: selected by [ADR-FLOW-CD][1]:
  the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][65]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line 47 (text), line 48
  (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89 (text), line 90
  (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md][66]: selected by [ADR-FLOW-CD][1]: the
  file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43
  (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text), line 108 (text),
  line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and line 158 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][1]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][67]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][68]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][69]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][70]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code; selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][2]: selected by [ADR-FLOW-CD][1]: an ADR file of the `flow` ADR domain, the ADR domain of that code;
  selected by [ADR-FLOW-CD-TYPE][2]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/glossary.md][71]: selected by [ADR-FLOW-CD][1]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][72]: selected by [ADR-FLOW-CD][1]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-TYPE][2]: the file
  cites it at line 110 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][73]: selected by [ADR-FLOW-CD][1]: the file cites it at line 55 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][74]: selected by [ADR-FLOW-CD][1]: the file cites it at line 54 (text) and
  line 55 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][75]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 50 (text) and line 51 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][76]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line 34
  (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][77]: selected by [ADR-FLOW-CD][1]: the file cites it at line 60 (text), line
  60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][78]: selected by [ADR-FLOW-CD][1]: the file cites it at line 16 (text), line 48 (text),
  line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][79]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text),
  line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][80]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text), line
  47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text) and line 58 (text); selected by
  [ADR-FLOW-CD-TYPE][2]: the file cites it at line 17 (text), line 51 (text), line 56 (text) and line 56 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][81]: selected by [ADR-FLOW-CD][1]: the file cites it at line 15 (text), line 43
  (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][82]: selected by [ADR-FLOW-CD][1]: the file cites it at line 17 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### pipelines × pipeline-yaml (2 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][3]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][4]). Lit ([ADR-DSGN-TRACK#12][5]) by:

- [pipelines/cd-shared.yaml][83]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 3 (header).
- [pipelines/ci-infrastructure.yaml][84]: selected by [ADR-FLOW-CD-TYPE][2]: the file cites it at line 4 (header).

## Keywords

- [world map][85]
- [track][86]
- [file language][87]
- [cell][88]
- [lit cell][89]
- [.claude][90]: a track
- [automation][90]: a track
- [docs][90]: a track
- [pipelines][90]: a track
- [csharp][91]: a file language
- [markdown][91]: a file language
- [pipeline-yaml][91]: a file language
- [powershell][91]: a file language
- [yaml][91]: a file language

Terms the cited ADRs define:

- [gate][92], defined by [ADR-FLOW-CD#13][93]
- [release candidate][94], defined by [ADR-FLOW-CD#14][95]

[1]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[2]: ../../adr/flow/pipeline-types.md
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[6]: ../../../.claude/CLAUDE.md
[7]: ../../../.claude/drawio/STYLE.md
[8]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[9]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[10]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[11]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[12]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[14]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[15]: ../../../automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
[16]: ../../../automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1
[17]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[18]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[19]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[20]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[21]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[22]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[23]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[24]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[25]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[26]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[27]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[28]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[29]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[30]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[31]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[32]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[33]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[34]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[35]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[36]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[37]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[38]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[39]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[40]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[41]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[42]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[43]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[44]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[45]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[46]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[47]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[48]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[49]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[50]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
[51]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[52]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[53]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[54]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
[55]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[56]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[57]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[58]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md
[59]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[60]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[61]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[62]: adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md
[63]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[64]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[65]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[66]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
[67]: ../../adr/flow/dora-explains.md
[68]: ../../adr/flow/durable-sha-globs.md
[69]: ../../adr/flow/pipeline-detection.md
[70]: ../../adr/flow/pipeline-runner-pattern.md
[71]: ../../adr/glossary.md
[72]: ../../adr/index.md
[73]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[74]: ../../explanation/design/four-domains-promote-one-artifact.md
[75]: ../../explanation/design/integrators-depend-on-an-occupant.md
[76]: ../../explanation/design/sync-point-rules-are-adr-only.md
[77]: ../../explanation/design/which-rung-gates-exist-in-code.md
[78]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[79]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[80]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[81]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[82]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[83]: ../../../pipelines/cd-shared.yaml
[84]: ../../../pipelines/ci-infrastructure.yaml
[85]: ../../adr/glossary.md#world-map
[86]: ../../adr/glossary.md#track
[87]: ../../adr/glossary.md#file-language
[88]: ../../adr/glossary.md#cell
[89]: ../../adr/glossary.md#lit-cell
[90]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[91]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[92]: ../../adr/glossary.md#gate
[93]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[94]: ../../adr/glossary.md#release-candidate
[95]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
