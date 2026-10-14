# docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md

`Grid minimap: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture`

![Grid minimap of adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.png)

The grid minimap of the slide `adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture` (architecture lens). The slide supports
[ADR-DSGN-RUNMODE][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 5 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 28 lit of 1400 files
- automation × yaml: 2 lit of 95 files
- docs × markdown: 56 lit of 741 files
- Root files × powershell: 1 lit of 1 file
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### automation × powershell (28 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/.internal/assets/Import-Catzc.ps1][5]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][6]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 1 (text).
- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][7]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][8]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][9]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 29 (header).
- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][10]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][11]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 12
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][12]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][13]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 10
  (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][14]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 28
  (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][15]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][16]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][17]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 21
  (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][18]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][19]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][20]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at
  line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][21]: selected by [ADR-DSGN-RUNMODE][1]: the file cites
  it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][22]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][23]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][24]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][25]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][26]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 15
  (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][27]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 30
  (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][28]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 8
  (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][29]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 24
  (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][30]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 22
  (header).
- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][31]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][32]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 18 (header).

### automation × yaml (2 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][33]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 101 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][34]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 590 (text).

### docs × markdown (56 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][35]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][36]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][37]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 48 (text), line 49 (text), line 50 (text), line 54 (text), line 64 (text), line 65 (text), line 66
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 74 (text), line 75 (text), line 77 (text), line 78 (text),
  line 79 (text), line 81 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 106 (text), line 108 (text), line 122 (text), line 128
  (text), line 130 (text), line 135 (text), line 137 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 225
  (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239
  (text), line 241 (text), line 250 (text), line 253 (text), line 257 (text), line 260 (text), line 266 (text), line 267 (text), line 269
  (text), line 271 (text), line 273 (text), line 275 (text), line 284 (text), line 293 (text) and line 297 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md][38]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 131 (text), line 137 (text), line 139 (text), line 144 (text), line 147 (text), line 149 (text), line
  151 (text), line 153 (text), line 155 (text), line 164 (text), line 166 (text), line 171 (text), line 175 (text), line 180 (text), line
  182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 221 (text), line 223 (text), line 225 (text), line
  227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 244 (text), line 247 (text), line
  248 (text), line 251 (text), line 253 (text), line 254 (text), line 256 (text), line 259 (text), line 265 (text), line 267 (text), line
  269 (text), line 272 (text), line 274 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line
  295 (text), line 299 (text), line 305 (text), line 313 (text), line 315 (text), line 317 (text), line 325 (text), line 327 (text), line
  334 (text), line 335 (text), line 342 (text), line 344 (text), line 359 (text), line 372 (text), line 379 (text) and line 387 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][39]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][40]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][41]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 47 (text), line 48 (text), line 49 (text), line 53 (text), line 63 (text), line 64 (text), line 65
  (text), line 67 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 88 (text), line 90
  (text), line 92 (text), line 94 (text), line 96 (text), line 97 (text), line 105 (text), line 107 (text), line 121 (text), line 127
  (text), line 129 (text), line 134 (text), line 136 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 224
  (text), line 226 (text), line 228 (text), line 230 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 238
  (text), line 240 (text), line 249 (text), line 252 (text), line 256 (text), line 259 (text), line 265 (text), line 266 (text), line 268
  (text), line 270 (text), line 272 (text), line 274 (text), line 283 (text), line 292 (text) and line 296 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md][42]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 130 (text), line 136 (text), line 138 (text), line 143 (text), line 146 (text), line 148 (text), line
  150 (text), line 152 (text), line 154 (text), line 163 (text), line 165 (text), line 170 (text), line 174 (text), line 179 (text), line
  181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 220 (text), line 222 (text), line 224 (text), line
  226 (text), line 228 (text), line 230 (text), line 232 (text), line 234 (text), line 236 (text), line 243 (text), line 246 (text), line
  247 (text), line 250 (text), line 252 (text), line 253 (text), line 255 (text), line 258 (text), line 264 (text), line 266 (text), line
  268 (text), line 271 (text), line 273 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line
  294 (text), line 298 (text), line 304 (text), line 312 (text), line 314 (text), line 316 (text), line 324 (text), line 326 (text), line
  333 (text), line 334 (text), line 341 (text), line 343 (text), line 358 (text), line 371 (text), line 378 (text) and line 386 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][43]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 38 (text), line 38 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][44]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][45]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 179 (text), line 182 (text), line 190 (text), line 201 (text), line 217 (text), line 220 (text), line
  221 (text), line 224 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 242 (text), line
  244 (text), line 253 (text), line 255 (text), line 261 (text), line 262 (text), line 263 (text), line 267 (text), line 280 (text), line
  283 (text), line 284 (text), line 286 (text), line 289 (text), line 301 (text), line 302 (text), line 310 (text), line 317 (text), line
  340 (text), line 346 (text), line 349 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line
  366 (text), line 449 (text), line 451 (text), line 453 (text), line 455 (text), line 456 (text), line 458 (text), line 460 (text), line
  462 (text), line 463 (text), line 466 (text), line 567 (text), line 570 (text), line 574 (text), line 578 (text), line 586 (text), line
  587 (text), line 589 (text), line 591 (text), line 593 (text), line 595 (text), line 623 (text), line 634 (text) and line 640 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md][46]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 191 (text), line 197 (text), line 200 (text), line 206 (text), line 209 (text), line 211 (text), line
  213 (text), line 215 (text), line 217 (text), line 228 (text), line 230 (text), line 235 (text), line 239 (text), line 247 (text), line
  249 (text), line 251 (text), line 253 (text), line 255 (text), line 257 (text), line 345 (text), line 348 (text), line 391 (text), line
  393 (text), line 397 (text), line 409 (text), line 411 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line
  481 (text), line 482 (text), line 485 (text), line 488 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line
  662 (text), line 674 (text), line 676 (text), line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line
  688 (text), line 690 (text), line 697 (text), line 769 (text), line 771 (text), line 773 (text), line 785 (text), line 789 (text), line
  812 (text), line 818 (text), line 829 (text), line 859 (text), line 861 (text), line 955 (text), line 968 (text) and line 976 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][47]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 30 (text), line 30 (text), line 38 (text) and line 38 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][48]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][49]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 72 (text), line 77 (text), line 176 (text), line 200 (text), line 295 (text), line 351 (text), line
  352 (text), line 354 (text), line 356 (text), line 358 (text), line 359 (text), line 360 (text), line 367 (text), line 407 (text), line
  409 (text), line 592 (text), line 594 (text), line 650 (text), line 652 (text), line 653 (text), line 658 (text), line 672 (text), line
  674 (text), line 676 (text), line 678 (text), line 680 (text), line 691 (text), line 692 (text), line 764 (text), line 781 (text), line
  800 (text), line 806 (text), line 808 (text), line 814 (text), line 821 (text), line 824 (text), line 826 (text), line 828 (text), line
  830 (text), line 952 (text), line 954 (text), line 956 (text), line 958 (text), line 959 (text), line 961 (text), line 963 (text), line
  965 (text), line 966 (text), line 972 (text), line 982 (text), line 985 (text), line 989 (text), line 992 (text), line 1001 (text), line
  1005 (text), line 1008 (text), line 1010 (text), line 1012 (text), line 1015 (text), line 1055 (text), line 1069 (text) and line 1077
  (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][50]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 74 (text), line 76 (text), line 120 (text), line 286 (text), line 288 (text), line 358 (text), line
  364 (text), line 366 (text), line 372 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 388 (text), line
  402 (text), line 404 (text), line 409 (text), line 413 (text), line 421 (text), line 425 (text), line 429 (text), line 431 (text), line
  433 (text), line 436 (text), line 481 (text), line 484 (text), line 752 (text), line 755 (text), line 756 (text), line 759 (text), line
  762 (text), line 764 (text), line 766 (text), line 773 (text), line 814 (text), line 986 (text), line 988 (text), line 990 (text), line
  992 (text), line 994 (text), line 1033 (text), line 1056 (text), line 1058 (text), line 1060 (text), line 1062 (text), line 1064 (text),
  line 1066 (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1121 (text), line 1127 (text), line 1169 (text), line 1172
  (text), line 1173 (text), line 1228 (text), line 1236 (text), line 1245 (text), line 1265 (text), line 1304 (text), line 1306 (text) and
  line 1318 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][51]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][52]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][53]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line 35
  (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md][54]: selected by [ADR-DSGN-RUNMODE][1]: the
  file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49
  (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][55]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][56]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][57]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md][58]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][59]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][60]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][61]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md][62]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][63]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][64]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][65]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md][66]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][67]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][68]: selected by
  [ADR-DSGN-RUNMODE][1]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][69]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line 34 (text), line
  35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46 (text), line 47 (text),
  line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text), line 102
  (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 114 (text), line 116
  (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131
  (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md][70]: selected by [ADR-DSGN-RUNMODE][1]:
  the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line
  49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107 (text), line 110
  (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154 (text), line 158
  (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190 (text), line 192
  (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/adr/design/commit-lifecycle.md][71]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][72]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][73]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][1]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][74]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][75]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][76]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][77]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][78]: selected by [ADR-DSGN-RUNMODE][1]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/index.md][79]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 94 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][80]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text),
  line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][81]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 47
  (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][82]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 15
  (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][83]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 41 (text),
  line 51 (text), line 66 (text), line 69 (text) and line 73 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][84]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 16 (text),
  line 42 (text), line 57 (text), line 63 (text) and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][85]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text), line
  60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][86]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 19 (text),
  line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][87]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17
  (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][88]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 14
  (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][89]: selected by [ADR-DSGN-RUNMODE][1]: the file cites it at line 17 (text),
  line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line 61 (text).

### Root files × powershell (1 lit file)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][90]); the extension `.ps1` names the file
language powershell ([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [importer.ps1][91]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][90]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][92]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.gitattributes][93]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][94]: selected by [ADR-DSGN-RUNMODE][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1`
  line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).

## Keywords

- [world map][95]
- [track][96]
- [file language][97]
- [cell][98]
- [lit cell][99]
- [root file][100]
- [unlisted file][101]
- [automation][102]: a track
- [docs][102]: a track
- [markdown][103]: a file language
- [powershell][103]: a file language
- [yaml][103]: a file language

[1]: ../../adr/design/run-modes.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../automation/.internal/assets/Import-Catzc.ps1
[6]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[7]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[8]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[9]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[10]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[11]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[12]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[13]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[14]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[15]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[16]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[17]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[18]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[19]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[20]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[21]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[22]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[23]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[24]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[25]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[26]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[27]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[28]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[29]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[30]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[31]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[32]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[33]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[34]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[35]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[36]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[37]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[38]: adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
[39]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[40]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[41]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[42]: adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md
[43]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[44]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[45]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[46]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
[47]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[48]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[49]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[50]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[51]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[52]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[53]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[54]: adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
[55]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[56]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[57]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[58]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
[59]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[60]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[61]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[62]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
[63]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[64]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[65]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[66]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
[67]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[68]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[69]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[70]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md
[71]: ../../adr/design/commit-lifecycle.md
[72]: ../../adr/design/dora-explains.md
[73]: ../../adr/design/module-aspects.md
[74]: ../../adr/design/self-service.md
[75]: ../../adr/design/server-remote-integration.md
[76]: ../../adr/design/thin-platforms.md
[77]: ../../adr/design/tracks.md
[78]: ../../adr/design/visual-design.md
[79]: ../../adr/index.md
[80]: ../../explanation/automation/every-code-root-is-a-copy.md
[81]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[82]: ../../explanation/automation/one-commit-one-immutable-package.md
[83]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[84]: ../../explanation/automation/what-gates-each-bundle-stage.md
[85]: ../../explanation/design/one-entry-script-per-mode.md
[86]: ../../explanation/design/shims-set-roots-mode-read-back.md
[87]: ../../explanation/design/two-roots-one-importer-same-modules.md
[88]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[89]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[90]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[91]: ../../../importer.ps1
[92]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[93]: ../../../.gitattributes
[94]: ../../../.gitignore
[95]: ../../adr/glossary.md#world-map
[96]: ../../adr/glossary.md#track
[97]: ../../adr/glossary.md#file-language
[98]: ../../adr/glossary.md#cell
[99]: ../../adr/glossary.md#lit-cell
[100]: ../../adr/glossary.md#root-file
[101]: ../../adr/glossary.md#unlisted-file
[102]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[103]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
