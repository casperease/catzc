# docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md

`Grid minimap: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation`

![Grid minimap of adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation](adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.png)

The grid minimap of the slide `adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation` (implementation lens). The slide
supports [ADR-AUTO-DEPM][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- .claude × markdown: 1 lit of 9 files
- automation × csharp: 3 lit of 219 files
- automation × yaml: 1 lit of 95 files
- docs × markdown: 65 lit of 741 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.cs`: csharp
- `.md`: markdown
- `.yml`: yaml

## Why each cell is lit

### .claude × markdown (1 lit file)

Placed: the root folder `.claude/` names the track .claude ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [.claude/drawio/STYLE.md][5]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 324 (text).

### automation × csharp (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.cs` names the file language csharp
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][6]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs][7]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs][8]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 3 (header).

### automation × yaml (1 lit file)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][2]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][9]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 157 (text).

### docs × markdown (65 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][2]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][3]). Lit ([ADR-DSGN-TRACK#12][4]) by:

- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md][10]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.md][11]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md][12]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 7 (text), line 27 (text), line 34 (text), line 35 (text), line 36 (text), line 43 (text), line 50 (text), line 52 (text),
  line 54 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text) and line 147 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md][13]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 7 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 112 (text), line 114
  (text), line 116 (text), line 118 (text), line 120 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 136 (text), line 138 (text), line 140 (text), line 147 (text), line 153 (text) and line 160 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.chain.md][14]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.drawio.md][15]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 67 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.grid.md][16]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 27 (text), line 34 (text), line 35 (text), line 36 (text), line 43 (text), line 50 (text), line 52
  (text), line 54 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text) and line 147 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.tree.md][17]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 112 (text), line
  114 (text), line 116 (text), line 118 (text), line 120 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 136 (text), line 138 (text), line 140 (text), line 147 (text), line 153 (text) and line 160 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][18]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 26 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md][19]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][20]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 8 (text), line 37 (text), line 50 (text), line 52 (text), line 53 (text), line 679 (text), line 708 (text), line 710
  (text), line 712 (text), line 715 (text), line 716 (text), line 726 (text), line 728 (text), line 730 (text), line 732 (text), line 734
  (text), line 736 (text), line 738 (text), line 740 (text), line 742 (text), line 744 (text), line 746 (text), line 748 (text), line 750
  (text), line 752 (text), line 754 (text), line 756 (text), line 758 (text), line 760 (text), line 762 (text), line 764 (text), line 766
  (text), line 768 (text), line 770 (text), line 772 (text), line 774 (text), line 776 (text), line 778 (text), line 780 (text), line 782
  (text), line 784 (text), line 786 (text), line 788 (text), line 790 (text), line 792 (text), line 794 (text), line 796 (text), line 798
  (text), line 800 (text), line 802 (text), line 807 (text), line 809 (text), line 811 (text), line 813 (text), line 816 (text) and line 818
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md][21]: selected by [ADR-AUTO-DEPM][1]: the file
  cites it at line 8 (text), line 326 (text), line 329 (text), line 332 (text), line 335 (text), line 338 (text), line 341 (text), line 344
  (text), line 347 (text), line 350 (text), line 353 (text), line 356 (text), line 359 (text), line 362 (text), line 365 (text), line 368
  (text), line 371 (text), line 374 (text), line 377 (text), line 380 (text), line 383 (text), line 386 (text), line 389 (text), line 392
  (text), line 395 (text), line 398 (text), line 401 (text), line 404 (text), line 407 (text), line 410 (text), line 413 (text), line 416
  (text), line 419 (text), line 422 (text), line 425 (text), line 428 (text), line 431 (text), line 434 (text), line 437 (text), line 440
  (text), line 456 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538 (text), line 547 (text), line 549
  (text), line 551 (text), line 555 (text), line 556 (text), line 702 (text), line 704 (text), line 706 (text), line 973 (text) and line
  1109 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md][22]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.md][23]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md][24]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 35 (text), line 36 (text), line 43 (text),
  line 50 (text), line 52 (text), line 54 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116
  (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132
  (text), line 134 (text), line 136 (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text) and line 147
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md][25]: selected by
  [ADR-AUTO-DEPM][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text),
  line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54
  (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text),
  line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 136 (text), line 138 (text), line 140 (text), line 147 (text), line 153 (text) and line 160 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md][26]: selected by [ADR-AUTO-DEPM][1]:
  the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.md][27]: selected by [ADR-AUTO-DEPM][1]:
  the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md][28]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 27 (text), line 34 (text), line 35 (text), line 36 (text), line 43 (text), line 50 (text), line 52
  (text), line 54 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text) and line 147 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md][29]: selected by [ADR-AUTO-DEPM][1]: the
  file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 112 (text), line
  114 (text), line 116 (text), line 118 (text), line 120 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 136 (text), line 138 (text), line 140 (text), line 147 (text), line 153 (text) and line 160 (text).
- [docs/adr/automation/BCL/index.md][30]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/BCL/native-csharp-types.md][31]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][32]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][33]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/caching.md][34]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][35]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][1]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][36]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][37]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/devbox-pipeline-parity.md][38]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][39]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/dry-run.md][40]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][41]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/environment-variables.md][42]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][43]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][44]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][45]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/go/test-artifacts.md][46]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/idempotent-state-functions.md][47]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][48]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][49]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/managed-guids.md][50]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/never-depend-on-pwd.md][51]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][52]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/path-representation.md][53]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][54]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/protected-globs.md][55]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/python/index.md][56]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][57]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][58]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][59]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/single-responsibility-functions.md][60]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][61]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/test-automation.md][62]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][63]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][64]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][65]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][66]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][67]: selected by [ADR-AUTO-DEPM][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/index.md][68]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 145 (text).
- [docs/explanation/automation/a-declared-allow-list-of-layers.md][69]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 14 (text),
  line 38 (text), line 40 (text), line 41 (text) and line 42 (text).
- [docs/explanation/automation/three-layers-edges-point-down.md][70]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15 (text),
  line 44 (text), line 46 (text) and line 48 (text).
- [docs/explanation/automation/two-gates-check-the-layer-pins.md][71]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15 (text),
  line 47 (text), line 48 (text), line 49 (text), line 50 (text), line 51 (text) and line 55 (text).
- [docs/explanation/automation/two-sections-unioned-into-one-allow-set.md][72]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 18
  (text), line 56 (text), line 57 (text) and line 58 (text).
- [docs/explanation/automation/undeclared-edge-fails-with-one-line.md][73]: selected by [ADR-AUTO-DEPM][1]: the file cites it at line 15
  (text), line 49 (text), line 50 (text) and line 51 (text).

## Keywords

- [world map][74]
- [track][75]
- [file language][76]
- [cell][77]
- [lit cell][78]
- [.claude][79]: a track
- [automation][79]: a track
- [docs][79]: a track
- [csharp][80]: a file language
- [markdown][80]: a file language
- [yaml][80]: a file language

[1]: ../../adr/automation/controlling-module-dependencies.md
[2]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[3]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[5]: ../../../.claude/drawio/STYLE.md
[6]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[7]: ../../../automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
[8]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleGroup.cs
[9]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[10]: adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md
[11]: adr-auto-depm--a-declared-allow-list-of-layers--meta.drawio.md
[12]: adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
[13]: adr-auto-depm--a-declared-allow-list-of-layers--meta.tree.md
[14]: adr-auto-depm--three-layers-edges-point-down--architecture.chain.md
[15]: adr-auto-depm--three-layers-edges-point-down--architecture.drawio.md
[16]: adr-auto-depm--three-layers-edges-point-down--architecture.grid.md
[17]: adr-auto-depm--three-layers-edges-point-down--architecture.tree.md
[18]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[19]: adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md
[20]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[21]: adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md
[22]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md
[23]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.drawio.md
[24]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md
[25]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.tree.md
[26]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
[27]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.drawio.md
[28]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
[29]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.tree.md
[30]: ../../adr/automation/BCL/index.md
[31]: ../../adr/automation/BCL/native-csharp-types.md
[32]: ../../adr/automation/avoid-deep-nesting.md
[33]: ../../adr/automation/bash/bash-test-artifacts.md
[34]: ../../adr/automation/caching.md
[35]: ../../adr/automation/console-output-matters.md
[36]: ../../adr/automation/controlling-systemwide-deps.md
[37]: ../../adr/automation/cross-platform.md
[38]: ../../adr/automation/devbox-pipeline-parity.md
[39]: ../../adr/automation/dora-explains.md
[40]: ../../adr/automation/dry-run.md
[41]: ../../adr/automation/effective-in-enterprises.md
[42]: ../../adr/automation/environment-variables.md
[43]: ../../adr/automation/execution-engines.md
[44]: ../../adr/automation/fail-fast-with-asserts.md
[45]: ../../adr/automation/go/index.md
[46]: ../../adr/automation/go/test-artifacts.md
[47]: ../../adr/automation/idempotent-state-functions.md
[48]: ../../adr/automation/internal-asset-dependencies.md
[49]: ../../adr/automation/log-before-invoke.md
[50]: ../../adr/automation/managed-guids.md
[51]: ../../adr/automation/never-depend-on-pwd.md
[52]: ../../adr/automation/open-closed-architecture.md
[53]: ../../adr/automation/path-representation.md
[54]: ../../adr/automation/platform-bundle.md
[55]: ../../adr/automation/protected-globs.md
[56]: ../../adr/automation/python/index.md
[57]: ../../adr/automation/python/python-test-artifacts.md
[58]: ../../adr/automation/retry-as-last-resort.md
[59]: ../../adr/automation/sensible-defaults.md
[60]: ../../adr/automation/single-responsibility-functions.md
[61]: ../../adr/automation/spell-out-names.md
[62]: ../../adr/automation/test-automation.md
[63]: ../../adr/automation/tool-removal-lifecycle.md
[64]: ../../adr/automation/tracked-files-from-the-index.md
[65]: ../../adr/automation/use-proper-package-managers.md
[66]: ../../adr/automation/uv-python-handler.md
[67]: ../../adr/automation/zero-ceremony-poka-yoke.md
[68]: ../../adr/index.md
[69]: ../../explanation/automation/a-declared-allow-list-of-layers.md
[70]: ../../explanation/automation/three-layers-edges-point-down.md
[71]: ../../explanation/automation/two-gates-check-the-layer-pins.md
[72]: ../../explanation/automation/two-sections-unioned-into-one-allow-set.md
[73]: ../../explanation/automation/undeclared-edge-fails-with-one-line.md
[74]: ../../adr/glossary.md#world-map
[75]: ../../adr/glossary.md#track
[76]: ../../adr/glossary.md#file-language
[77]: ../../adr/glossary.md#cell
[78]: ../../adr/glossary.md#lit-cell
[79]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[80]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
