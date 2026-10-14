# docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md

`Grid minimap: adr-flow-cd-globs--two-declared-layers-one-derived--architecture`

![Grid minimap of adr-flow-cd-globs--two-declared-layers-one-derived--architecture](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.png)

The grid minimap of the slide `adr-flow-cd-globs--two-declared-layers-one-derived--architecture` (architecture lens). The slide supports
[ADR-FLOW-CD-GLOBS][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 6 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .github × yaml: 1 lit of 2 files, touched
- automation × csharp: 5 lit of 219 files
- automation × powershell: 41 lit of 1400 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 71 lit of 741 files
- pipelines × pipeline-yaml: 6 lit of 9 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yaml`: pipeline-yaml
- `.ps1`: powershell
- `.yml`: yaml

## Why each cell is lit

### .github × yaml (1 lit file, touched)

Placed: the root folder `.github/` names the track .github ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.github/workflows/ci-automation.yml][5]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (body comment) (a passing
  mention only).

### automation × csharp (5 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Globs/types/Aspect.cs][6]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][7]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1 (header) and line 7
  (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][8]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header), line 8
  (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57 (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][9]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header), line 5
  (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32 (body comment), line 41 (body
  comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158 (body comment) and line 180
  (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][10]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header), line 7
  (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text) and line 172 (text).

### automation × powershell (41 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][11]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][12]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][13]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][14]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][15]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][16]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header) and
  line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][17]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][18]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header) and line 9
  (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][19]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header) and line
  10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][20]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header) and
  line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][21]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][22]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 72 (body comment),
  line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][23]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][24]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][25]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][26]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][27]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header),
  line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][28]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][29]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][30]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][31]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][32]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 11
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][33]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][34]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][35]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][36]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][37]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][38]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][39]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][40]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1
  (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][41]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][42]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2
  (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][43]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][44]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][45]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1
  (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][46]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header),
  line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][47]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3
  (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][48]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][49]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7
  (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][50]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][51]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9
  (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][52]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][53]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 122 (text).
- [automation/Catzc.Base.Globs/configs/globs.yml][54]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header), line 7
  (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).

### docs × markdown (71 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][55]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][56]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][57]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 38 (text), line 47 (text), line 48 (text), line 50 (text), line 52
  (text), line 56 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 78 (text), line 79 (text), line 81 (text),
  line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 93 (text), line 95 (text), line 97
  (text), line 98 (text), line 100 (text), line 102 (text), line 103 (text), line 104 (text), line 106 (text), line 108 (text), line 110
  (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 122 (text), line 124 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 135 (text), line 137 (text), line 139 (text), line 143 (text), line 146 (text), line 149
  (text), line 151 (text), line 160 (text), line 163 (text), line 169 (text), line 191 (text), line 196 (text), line 199 (text), line 201
  (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 212 (text), line 215 (text), line 217
  (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 247 (text), line 338
  (text), line 342 (text), line 346 (text), line 350 (text), line 352 (text), line 354 (text), line 356 (text), line 359 (text), line 361
  (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 384
  (text), line 385 (text), line 386 (text), line 387 (text), line 388 (text) and line 389 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][58]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48
  (text), line 50 (text), line 53 (text), line 55 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 66 (text),
  line 67 (text), line 70 (text), line 72 (text), line 75 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85
  (text), line 87 (text), line 89 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text),
  line 107 (text), line 108 (text), line 111 (text), line 114 (text), line 115 (text), line 117 (text), line 120 (text), line 124 (text),
  line 143 (text), line 148 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text),
  line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 177 (text), line 183 (text), line 186 (text), line 190 (text),
  line 193 (text), line 195 (text), line 197 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text),
  line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 356 (text), line 363 (text), line 365 (text), line 368 (text),
  line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384 (text), line 391 (text), line 393 (text),
  line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 409 (text), line 411 (text), line 413 (text), line 415 (text),
  line 417 (text), line 424 (text), line 464 (text), line 478 (text) and line 485 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][59]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][60]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][61]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 49 (text), line 65 (text), line 66 (text), line 68 (text), line 70
  (text), line 74 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 123 (text), line 124 (text), line 126
  (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 137 (text), line 139
  (text), line 141 (text), line 142 (text), line 144 (text), line 146 (text), line 147 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 170 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 181 (text), line 225 (text), line 226
  (text), line 230 (text), line 232 (text), line 242 (text), line 246 (text), line 251 (text), line 270 (text), line 289 (text), line 304
  (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 317 (text), line 320
  (text), line 322 (text), line 340 (text), line 342 (text), line 344 (text), line 346 (text), line 348 (text), line 350 (text), line 356
  (text), line 394 (text), line 402 (text), line 406 (text), line 413 (text), line 425 (text), line 427 (text), line 429 (text), line 432
  (text), line 434 (text), line 438 (text), line 440 (text), line 442 (text), line 446 (text), line 448 (text), line 450 (text), line 455
  (text), line 466 (text), line 467 (text), line 468 (text), line 469 (text), line 471 (text) and line 472 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][62]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 41 (text), line 60 (text), line 75 (text), line 77 (text), line 79
  (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100 (text),
  line 108 (text), line 113 (text), line 119 (text), line 132 (text), line 134 (text), line 136 (text), line 139 (text), line 141 (text),
  line 145 (text), line 147 (text), line 149 (text), line 153 (text), line 155 (text), line 157 (text), line 162 (text), line 173 (text),
  line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 190 (text),
  line 192 (text), line 193 (text), line 195 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 207 (text),
  line 208 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text),
  line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 236 (text), line 239 (text),
  line 241 (text), line 243 (text), line 245 (text), line 248 (text), line 252 (text), line 368 (text), line 438 (text), line 443 (text),
  line 447 (text), line 449 (text), line 456 (text), line 459 (text), line 461 (text), line 463 (text), line 466 (text), line 469 (text),
  line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 484 (text), line 485 (text), line 493 (text), line 495 (text),
  line 497 (text), line 499 (text), line 501 (text), line 547 (text), line 554 (text) and line 561 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][63]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][64]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][65]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md][66]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][67]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][68]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][69]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md][70]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][71]: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 8 (text), line 27 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][72]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][73]: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 57 (text), line 59 (text), line 63 (text), line
  89 (text), line 91 (text), line 93 (text), line 95 (text), line 280 (text), line 290 (text), line 292 (text), line 294 (text), line 296
  (text), line 298 (text), line 300 (text), line 302 (text), line 305 (text), line 309 (text), line 311 (text), line 312 (text), line 315
  (text), line 319 (text), line 320 (text), line 321 (text), line 323 (text), line 325 (text), line 327 (text), line 330 (text), line 333
  (text), line 335 (text), line 337 (text), line 339 (text), line 343 (text), line 345 (text), line 347 (text), line 350 (text), line 351
  (text), line 360 (text), line 366 (text), line 368 (text), line 371 (text), line 446 (text), line 481 (text), line 489 (text), line 513
  (text), line 777 (text), line 784 (text), line 793 (text), line 821 (text), line 825 (text), line 827 (text), line 829 (text), line 831
  (text), line 834 (text), line 836 (text), line 838 (text), line 840 (text), line 842 (text), line 845 (text), line 847 (text), line 926
  (text), line 928 (text), line 930 (text), line 932 (text), line 934 (text), line 936 (text), line 941 (text), line 949 (text), line 951
  (text), line 954 (text), line 956 (text), line 959 (text), line 961 (text), line 964 (text), line 967 (text), line 969 (text), line 971
  (text), line 975 (text), line 977 (text), line 979 (text), line 981 (text), line 986 (text), line 993 (text), line 1003 (text), line 1004
  (text), line 1005 (text), line 1006 (text), line 1007 (text) and line 1009 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][74]: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 8 (text), line 71 (text), line 126 (text), line 134 (text), line 158 (text), line 346 (text), line 348 (text),
  line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 364 (text), line 369 (text), line 371 (text),
  line 372 (text), line 375 (text), line 380 (text), line 381 (text), line 384 (text), line 386 (text), line 389 (text), line 391 (text),
  line 393 (text), line 395 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 411 (text), line 413 (text),
  line 415 (text), line 417 (text), line 419 (text), line 429 (text), line 435 (text), line 436 (text), line 439 (text), line 442 (text),
  line 444 (text), line 446 (text), line 449 (text), line 454 (text), line 469 (text), line 473 (text), line 475 (text), line 477 (text),
  line 479 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text), line 491 (text), line 493 (text), line 495 (text),
  line 502 (text), line 504 (text), line 509 (text), line 510 (text), line 515 (text), line 517 (text), line 520 (text), line 523 (text),
  line 525 (text), line 527 (text), line 531 (text), line 533 (text), line 536 (text), line 537 (text), line 543 (text), line 552 (text),
  line 695 (text), line 1071 (text), line 1073 (text), line 1075 (text), line 1077 (text), line 1079 (text), line 1087 (text), line 1089
  (text), line 1091 (text), line 1093 (text), line 1095 (text), line 1097 (text), line 1104 (text), line 1106 (text), line 1108 (text), line
  1110 (text), line 1112 (text), line 1115 (text), line 1178 (text), line 1296 (text) and line 1302 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][75]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][76]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][77]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md][78]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][79]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][80]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][81]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md][82]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][83]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][84]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][85]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md][86]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][87]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][88]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][89]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 45 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 64 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 281 (text), line 292 (text), line 294 (text),
  line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 307 (text), line 311 (text), line 313 (text),
  line 314 (text), line 317 (text), line 321 (text), line 322 (text), line 323 (text), line 325 (text), line 327 (text), line 329 (text),
  line 332 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 345 (text), line 347 (text), line 349 (text),
  line 352 (text), line 353 (text), line 362 (text), line 368 (text), line 370 (text), line 373 (text), line 448 (text), line 483 (text),
  line 491 (text), line 515 (text), line 779 (text), line 786 (text), line 796 (text), line 827 (text), line 831 (text), line 833 (text),
  line 835 (text), line 837 (text), line 840 (text), line 842 (text), line 844 (text), line 846 (text), line 849 (text), line 852 (text),
  line 854 (text), line 933 (text), line 935 (text), line 937 (text), line 939 (text), line 941 (text), line 943 (text), line 948 (text),
  line 973 (text), line 975 (text), line 978 (text), line 980 (text), line 983 (text), line 985 (text), line 988 (text), line 991 (text),
  line 993 (text), line 995 (text), line 999 (text), line 1002 (text), line 1004 (text), line 1006 (text), line 1011 (text), line 1018
  (text), line 1028 (text), line 1029 (text), line 1030 (text), line 1031 (text), line 1032 (text) and line 1034 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][90]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 72 (text), line 128 (text), line 136 (text), line 160 (text), line 348
  (text), line 350 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 362 (text), line 366 (text), line 371
  (text), line 373 (text), line 374 (text), line 377 (text), line 382 (text), line 383 (text), line 386 (text), line 388 (text), line 391
  (text), line 393 (text), line 395 (text), line 397 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 413
  (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 431 (text), line 437 (text), line 438 (text), line 441
  (text), line 444 (text), line 446 (text), line 448 (text), line 451 (text), line 456 (text), line 473 (text), line 477 (text), line 479
  (text), line 481 (text), line 483 (text), line 486 (text), line 488 (text), line 490 (text), line 492 (text), line 496 (text), line 498
  (text), line 500 (text), line 509 (text), line 511 (text), line 516 (text), line 517 (text), line 522 (text), line 524 (text), line 527
  (text), line 530 (text), line 532 (text), line 534 (text), line 538 (text), line 541 (text), line 544 (text), line 545 (text), line 551
  (text), line 560 (text), line 703 (text), line 1098 (text), line 1100 (text), line 1102 (text), line 1104 (text), line 1106 (text), line
  1114 (text), line 1116 (text), line 1118 (text), line 1120 (text), line 1122 (text), line 1124 (text), line 1131 (text), line 1133 (text),
  line 1135 (text), line 1137 (text), line 1139 (text), line 1142 (text), line 1205 (text), line 1333 (text) and line 1340 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][91]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][92]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][93]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83
  (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text),
  line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text),
  line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text),
  line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text),
  line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text),
  line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text),
  line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md][94]: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44
  (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text), line 58 (text), line 61 (text),
  line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text),
  line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line 120 (text), line 122 (text),
  line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text),
  line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line 151 (text), line 153 (text),
  line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text),
  line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text),
  line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line 216 (text), line 218 (text),
  line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line 237 (text), line 243 (text),
  line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][95]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][96]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][97]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md][98]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][99]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][100]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][101]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md][102]: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57 (text),
  line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text),
  line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111 (text), line
  120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line
  136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line
  189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208 (text), line
  216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235 (text), line
  237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/adr/flow/cd-discipline-and-promotion-flow.md][103]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the
  ADR domain of that code.
- [docs/adr/flow/dora-explains.md][104]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/durable-sha-globs.md][1]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-detection.md][105]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the ADR domain of
  that code.
- [docs/adr/flow/pipeline-runner-pattern.md][106]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/pipeline-types.md][107]: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][108]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 111 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][109]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 51
  (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][110]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 59
  (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][111]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 49 (text) and line 67 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][112]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 59
  (text) and line 59 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][113]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][114]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17
  (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][115]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text), line 59
  (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][116]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][117]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17
  (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][118]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 18
  (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][119]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 16
  (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][120]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 13 (text),
  line 38 (text) and line 40 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][121]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][122]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (text),
  line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][123]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 18
  (text).
- [docs/references/automation/catzc-base-globs.md][124]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 29 (text).

### pipelines × pipeline-yaml (6 lit files)

Placed: the root folder `pipelines/` names the track pipelines ([ADR-DSGN-TRACK#1][2]); the extension `.yaml` names the file language
pipeline-yaml ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [pipelines/cd-apex.yaml][125]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15 (header).
- [pipelines/cd-flux.yaml][126]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (header).
- [pipelines/cd-nova.yaml][127]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14 (header).
- [pipelines/cd-shared.yaml][128]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 29 (header).
- [pipelines/ci-automation.yaml][129]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][130]: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 17 (header).

## Keywords

- [world map][131]
- [track][132]
- [file language][133]
- [cell][134]
- [lit cell][135]
- [.github][136]: a track
- [automation][136]: a track
- [docs][136]: a track
- [pipelines][136]: a track
- [csharp][137]: a file language
- [markdown][137]: a file language
- [pipeline-yaml][137]: a file language
- [powershell][137]: a file language
- [yaml][137]: a file language

[1]: ../../adr/flow/durable-sha-globs.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.github/workflows/ci-automation.yml
[6]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[7]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[8]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[9]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[10]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[11]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[12]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[13]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[14]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[15]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[16]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[17]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[18]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[19]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[20]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[21]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[22]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[23]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[24]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[25]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[26]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[27]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[28]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[29]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[30]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[31]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[32]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[33]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[34]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[35]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[36]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[37]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[38]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[39]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[40]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[41]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[42]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[43]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[44]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[45]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[46]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[47]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[48]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[49]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[50]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[51]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[52]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[53]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[54]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[55]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[56]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[57]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[58]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[59]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[60]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[61]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[62]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[63]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[64]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[65]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[66]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
[67]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[68]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[69]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[70]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
[71]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[72]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[73]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[74]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[75]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[76]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[77]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[78]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
[79]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[80]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[81]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[82]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
[83]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[84]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[85]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[86]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md
[87]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[88]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[89]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[90]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[91]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[92]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[93]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[94]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md
[95]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[96]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[97]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[98]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
[99]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[100]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[101]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[102]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
[103]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[104]: ../../adr/flow/dora-explains.md
[105]: ../../adr/flow/pipeline-detection.md
[106]: ../../adr/flow/pipeline-runner-pattern.md
[107]: ../../adr/flow/pipeline-types.md
[108]: ../../adr/index.md
[109]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[110]: ../../explanation/design/one-folder-two-independent-readers.md
[111]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[112]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[113]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[114]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[115]: ../../explanation/flow/gates-check-source-and-trigger.md
[116]: ../../explanation/flow/globs-module-owns-config-and-types.md
[117]: ../../explanation/flow/independence-check-groups-by-layer.md
[118]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[119]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[120]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[121]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[122]: ../../explanation/flow/two-declared-layers-one-derived.md
[123]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[124]: ../../references/automation/catzc-base-globs.md
[125]: ../../../pipelines/cd-apex.yaml
[126]: ../../../pipelines/cd-flux.yaml
[127]: ../../../pipelines/cd-nova.yaml
[128]: ../../../pipelines/cd-shared.yaml
[129]: ../../../pipelines/ci-automation.yaml
[130]: ../../../pipelines/ci-infrastructure.yaml
[131]: ../../adr/glossary.md#world-map
[132]: ../../adr/glossary.md#track
[133]: ../../adr/glossary.md#file-language
[134]: ../../adr/glossary.md#cell
[135]: ../../adr/glossary.md#lit-cell
[136]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[137]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
