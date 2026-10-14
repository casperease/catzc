# docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md

`Tree minimap: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations`

![Tree minimap of adr-dsgn-track--a-push-fires-only-touched-pipelines--operations](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.png)

The tree minimap of the slide `adr-dsgn-track--a-push-fires-only-touched-pipelines--operations` (operations lens). The slide supports
[ADR-DSGN-TRACK][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 254 files in 12 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 193 lit files
- Maps (automation/Catzc.Base.Maps): 28 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Languages (automation/Catzc.Base.Languages): 6 lit files
- Docs (automation/Catzc.Base.Docs): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- .claude: 2 lit files
- Globs (automation/Catzc.Base.Globs): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file
- pipelines: 1 lit file

## Why each group is lit

### docs (193 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][2], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][6], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][7], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68
  (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][8], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 29 (text), line 29 (text), line 36 (text), line 37 (text), line 37 (text),
  line 44 (text), line 45 (text), line 45 (text), line 102 (text), line 103 (text), line 103 (text), line 112 (text), line 113 (text), line
  113 (text), line 280 (text), line 281 (text), line 281 (text), line 290 (text), line 291 (text) and line 291 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][10], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68
  (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][12], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][13], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36 (text),
  line 43 (text), line 44 (text), line 44 (text), line 101 (text), line 102 (text), line 102 (text), line 111 (text), line 112 (text), line
  112 (text), line 279 (text), line 280 (text), line 280 (text), line 289 (text), line 290 (text) and line 290 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][16], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 44 (text), line 47 (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text),
  line 61 (text), line 62 (text), line 66 (text), line 69 (text), line 70 (text), line 72 (text), line 73 (text), line 77 (text), line 80
  (text) and line 81 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][17], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 38 (text), line 39 (text), line 39 (text),
  line 46 (text), line 47 (text), line 47 (text), line 175 (text), line 176 (text), line 176 (text), line 306 (text), line 307 (text), line
  307 (text), line 330 (text), line 331 (text), line 331 (text), line 613 (text), line 614 (text), line 614 (text), line 629 (text), line
  630 (text) and line 630 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][18], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][19], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35
  (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][20], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 44 (text), line 47 (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text),
  line 63 (text), line 66 (text), line 67 (text), line 71 (text), line 74 (text) and line 75 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][21], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line 42 (text),
  line 49 (text), line 50 (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 755 (text), line 756 (text), line 756
  (text), line 790 (text), line 791 (text), line 791 (text), line 1039 (text), line 1040 (text), line 1040 (text), line 1047 (text), line
  1048 (text), line 1048 (text), line 1061 (text), line 1062 (text) and line 1062 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md][22], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md][23], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.chain.md][24], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.grid.md][25], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32
  (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][26], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text) and line 36
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][27], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 41 (text), line 42 (text), line 42 (text),
  line 62 (text), line 63 (text), line 63 (text), line 672 (text), line 673 (text), line 673 (text), line 703 (text), line 704 (text), line
  704 (text), line 844 (text), line 845 (text), line 845 (text), line 852 (text), line 853 (text), line 853 (text), line 863 (text), line
  864 (text) and line 864 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md][28], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md][29], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32
  (text), line 32 (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md][30], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md][31], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.chain.md][32], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.grid.md][33], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md][34], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md][35], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.chain.md][36], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md][37], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md][38], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md][39], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md][40], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md][41], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35
  (text), line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][42], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][43], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][44], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][45], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][46], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35
  (text), line 38 (text) and line 39 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][47], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 40 (text), line 41 (text), line 41
  (text), line 62 (text), line 63 (text), line 63 (text), line 693 (text), line 694 (text), line 694 (text), line 724 (text), line 725
  (text), line 725 (text), line 879 (text), line 880 (text), line 880 (text), line 887 (text), line 888 (text), line 888 (text), line 898
  (text), line 899 (text) and line 899 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][48], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][49], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text),
  line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][50], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][51], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md][52], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md][53], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md][54], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md][55], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md][56], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35
  (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md][58], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md][59], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][60], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 36 (text), line 39 (text), line 40 (text), line 44 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text),
  line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][61], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 29 (text), line 29 (text), line 35 (text), line 36
  (text), line 36 (text), line 43 (text), line 44 (text), line 44 (text), line 66 (text), line 67 (text), line 67 (text), line 157 (text),
  line 158 (text), line 158 (text), line 177 (text), line 178 (text), line 178 (text), line 381 (text), line 382 (text) and line 382 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][62], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line
  36 (text), line 40 (text), line 43 (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][63], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line
  31 (text), line 38 (text), line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][64], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 36 (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text),
  line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][65], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35
  (text), line 35 (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][66], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text),
  line 38 (text), line 39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53
  (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][67], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text),
  line 44 (text), line 45 (text) and line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][68], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][69], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][70], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line
  36 (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text)
  and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][71], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][72], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][73], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][74], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][75], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][76], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36
  (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and
  line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][77], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35
  (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][78], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text),
  line 38 (text), line 39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53
  (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][79], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text),
  line 44 (text), line 45 (text) and line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][80], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36
  (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and
  line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][81], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][82], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line 36 (text),
  line 40 (text), line 43 (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][83], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line 31 (text),
  line 38 (text), line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][84], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59
  (text), line 60 (text), line 62 (text) and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][85], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text),
  line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67
  (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][86], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39
  (text), line 41 (text), line 42 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text), line 53 (text), line 55 (text),
  line 56 (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 69 (text), line 70 (text), line 72
  (text), line 73 (text), line 77 (text), line 80 (text) and line 81 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][87], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 46 (text), line 47 (text), line 47 (text),
  line 65 (text), line 66 (text), line 66 (text), line 679 (text), line 680 (text), line 680 (text), line 714 (text), line 715 (text), line
  715 (text), line 959 (text), line 960 (text), line 960 (text), line 967 (text), line 968 (text), line 968 (text), line 978 (text), line
  979 (text) and line 979 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][88], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38
  (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 53 (text), line 56 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][89], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32
  (text), line 40 (text), line 41 (text) and line 41 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md][90], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md][91], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][92], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 54 (text), line 57 (text), line 58 (text),
  line 62 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][93], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line
  34 (text), line 40 (text), line 41 (text), line 41 (text), line 48 (text), line 49 (text), line 49 (text), line 58 (text), line 59 (text)
  and line 59 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md][94], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md][95], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md][96], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md][97], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][98], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][99], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text),
  line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and
  line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][100], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][101], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][102], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][103], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][104], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][105], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][106], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][107], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][108], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][109], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and line 31
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][110], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][111], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and
  line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][112], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37
  (text), line 38 (text), line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][113], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 39 (text), line 40 (text), line
  40 (text), line 50 (text), line 51 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][114], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][115], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and
  line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][116], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 43 (text), line 46 (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text)
  and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][117], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 41 (text), line 42 (text), line 42
  (text), line 52 (text), line 53 (text), line 53 (text), line 209 (text), line 210 (text) and line 210 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md][118], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line
  26 (text), line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][119], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md][120], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line
  35 (text), line 36 (text), line 36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text),
  line 49 (text), line 51 (text), line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text),
  line 82 (text), line 82 (text), line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94
  (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 113 (text), line 116 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132
  (text), line 133 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143
  (text), line 146 (text), line 151 (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161
  (text), line 163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175
  (text), line 177 (text), line 178 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 194 (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226
  (text), line 227 (text), line 228 (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234
  (text), line 235 (text), line 236 (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md][121], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line
  42 (text), line 44 (text), line 47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text),
  line 63 (text), line 68 (text), line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 124 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text),
  line 143 (text), line 145 (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text),
  line 164 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text),
  line 226 (text), line 235 (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text),
  line 268 (text), line 269 (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md][122], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 23 (text), line 25 (text), line 25 (text), line 26
  (text), line 27 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][123], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md][124], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30
  (text), line 35 (text), line 36 (text), line 36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text),
  line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text),
  line 81 (text), line 82 (text), line 82 (text), line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 116 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127
  (text), line 132 (text), line 133 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141
  (text), line 143 (text), line 146 (text), line 151 (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158
  (text), line 161 (text), line 163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173
  (text), line 175 (text), line 177 (text), line 178 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188
  (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205
  (text), line 226 (text), line 227 (text), line 228 (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233
  (text), line 234 (text), line 235 (text), line 236 (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md][125], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40
  (text), line 42 (text), line 44 (text), line 47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text),
  line 60 (text), line 63 (text), line 68 (text), line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 124 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text),
  line 141 (text), line 143 (text), line 145 (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text),
  line 162 (text), line 164 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text),
  line 188 (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text),
  line 220 (text), line 226 (text), line 235 (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text),
  line 267 (text), line 268 (text), line 269 (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and
  line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.chain.md][126], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line 26 (text),
  line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46
  (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][127], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.grid.md][128], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line 35 (text),
  line 36 (text), line 36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text), line 49
  (text), line 51 (text), line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text),
  line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text), line 82
  (text), line 82 (text), line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text),
  line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line
  113 (text), line 116 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132 (text), line
  133 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143 (text), line
  146 (text), line 151 (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161 (text), line
  163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175 (text), line
  177 (text), line 178 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line
  192 (text), line 194 (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226 (text), line
  227 (text), line 228 (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234 (text), line
  235 (text), line 236 (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md][129], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text),
  line 44 (text), line 47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 63
  (text), line 68 (text), line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text), line 106
  (text), line 108 (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 124 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143
  (text), line 145 (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text), line 164
  (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text), line 226
  (text), line 235 (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text), line 268
  (text), line 269 (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][130], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 30 (text), line 31 (text), line
  32 (text), line 34 (text), line 35 (text), line 39 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text),
  line 55 (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 71 (text), line 74 (text), line 75
  (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text),
  line 98 (text), line 99 (text), line 100 (text), line 101 (text) and line 102 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][131], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][132], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 29 (text), line 30 (text), line 30 (text), line 33 (text), line
  38 (text), line 39 (text), line 39 (text), line 41 (text), line 46 (text), line 47 (text), line 47 (text), line 54 (text), line 55 (text),
  line 55 (text), line 57 (text), line 59 (text), line 60 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 100 (text),
  line 102 (text), line 104 (text), line 109 (text), line 110 (text), line 110 (text), line 121 (text), line 180 (text), line 183 (text),
  line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text),
  line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 211 (text), line 214 (text), line 217 (text), line 219 (text),
  line 221 (text), line 228 (text), line 234 (text), line 239 (text), line 240 (text), line 240 (text), line 244 (text), line 250 (text),
  line 253 (text), line 254 (text), line 255 (text), line 257 (text), line 261 (text), line 266 (text), line 267 (text), line 267 (text),
  line 283 (text), line 285 (text), line 286 (text), line 289 (text), line 292 (text), line 323 (text), line 325 (text), line 327 (text),
  line 329 (text), line 330 (text), line 332 (text), line 334 (text), line 336 (text), line 337 (text), line 351 (text), line 355 (text),
  line 388 (text), line 398 (text), line 404 (text), line 411 (text), line 415 (text), line 452 (text), line 458 (text), line 463 (text),
  line 464 (text), line 464 (text), line 470 (text), line 494 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text),
  line 502 (text), line 503 (text), line 504 (text), line 505 (text), line 506 (text), line 507 (text), line 508 (text) and line 509 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][133], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line
  63 (text), line 94 (text), line 104 (text), line 110 (text), line 117 (text), line 121 (text), line 159 (text), line 166 (text), line 199
  (text), line 238 (text), line 260 (text), line 262 (text), line 265 (text), line 267 (text), line 269 (text), line 271 (text), line 274
  (text), line 277 (text), line 279 (text), line 282 (text), line 283 (text), line 285 (text), line 290 (text), line 293 (text), line 298
  (text), line 301 (text), line 303 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314
  (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 366 (text), line 376 (text), line 378
  (text), line 380 (text), line 382 (text), line 392 (text), line 394 (text), line 396 (text), line 399 (text), line 402 (text), line 406
  (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text), line 427 (text), line 429
  (text), line 431 (text), line 445 (text), line 483 (text), line 507 (text), line 509 (text), line 511 (text), line 513 (text), line 521
  (text), line 524 (text), line 533 (text), line 542 (text), line 546 (text), line 584 (text), line 585 (text), line 587 (text), line 589
  (text), line 591 (text), line 592 (text), line 593 (text), line 594 (text), line 595 (text), line 596 (text), line 597 (text), line 598
  (text) and line 599 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md][134], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line
  26 (text), line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][135], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md][136], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 28 (text), line 30 (text), line
  35 (text), line 36 (text), line 36 (text), line 38 (text), line 43 (text), line 44 (text), line 44 (text), line 46 (text), line 48 (text),
  line 49 (text), line 51 (text), line 52 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 72 (text), line 74 (text), line 76 (text), line 81 (text),
  line 82 (text), line 82 (text), line 84 (text), line 86 (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94
  (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 113 (text), line 116 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 132
  (text), line 133 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 140 (text), line 141 (text), line 143
  (text), line 146 (text), line 151 (text), line 152 (text), line 152 (text), line 154 (text), line 157 (text), line 158 (text), line 161
  (text), line 163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 171 (text), line 173 (text), line 175
  (text), line 177 (text), line 178 (text), line 180 (text), line 183 (text), line 184 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 194 (text), line 197 (text), line 202 (text), line 203 (text), line 203 (text), line 205 (text), line 226
  (text), line 227 (text), line 228 (text), line 229 (text), line 230 (text), line 231 (text), line 232 (text), line 233 (text), line 234
  (text), line 235 (text), line 236 (text), line 237 (text) and line 238 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md][137], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line
  42 (text), line 44 (text), line 47 (text), line 50 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text),
  line 63 (text), line 68 (text), line 71 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 102 (text), line 104 (text),
  line 106 (text), line 108 (text), line 110 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 124 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text),
  line 143 (text), line 145 (text), line 147 (text), line 154 (text), line 156 (text), line 158 (text), line 161 (text), line 162 (text),
  line 164 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 208 (text), line 210 (text), line 217 (text), line 220 (text),
  line 226 (text), line 235 (text), line 241 (text), line 263 (text), line 264 (text), line 265 (text), line 266 (text), line 267 (text),
  line 268 (text), line 269 (text), line 270 (text), line 271 (text), line 272 (text), line 273 (text), line 274 (text) and line 275 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][138], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text),
  line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][139], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text),
  line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64
  (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][140], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36
  (text), line 37 (text), line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][141], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line
  34 (text), line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text)
  and line 64 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][142], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line
  37 (text), line 40 (text), line 41 (text), line 43 (text), line 44 (text), line 48 (text), line 51 (text), line 52 (text), line 54 (text),
  line 55 (text), line 59 (text), line 62 (text), line 63 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][143], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36
  (text), line 49 (text), line 50 (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 80 (text), line 81 (text),
  line 81 (text), line 141 (text), line 142 (text) and line 142 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][144], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text),
  line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][145], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text),
  line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64
  (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][146], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line
  37 (text), line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][147], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line
  34 (text), line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text)
  and line 64 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][148], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][149], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][150], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][151], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][152], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line
  37 (text), line 41 (text), line 44 (text) and line 45 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][153], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line
  42 (text), line 49 (text), line 50 (text), line 50 (text), line 78 (text), line 79 (text), line 79 (text), line 774 (text), line 775
  (text), line 775 (text), line 811 (text), line 812 (text), line 812 (text), line 1000 (text), line 1001 (text), line 1001 (text), line
  1013 (text), line 1014 (text), line 1014 (text), line 1024 (text), line 1025 (text) and line 1025 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][154], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][155], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][156], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][157], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][158], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][159], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][160], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][161], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 42 (text), line 43 (text), line
  43 (text), line 50 (text), line 51 (text), line 51 (text), line 79 (text), line 80 (text), line 80 (text), line 776 (text), line 777
  (text), line 777 (text), line 815 (text), line 816 (text), line 816 (text), line 1025 (text), line 1026 (text), line 1026 (text), line
  1038 (text), line 1039 (text), line 1039 (text), line 1049 (text), line 1050 (text) and line 1050 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][162], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][163], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][164], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][165], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][166], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][167], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][168], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][169], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][170], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 43 (text), line 46 (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text)
  and line 63 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][171], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line
  34 (text), line 49 (text), line 50 (text), line 50 (text), line 61 (text), line 62 (text), line 62 (text), line 114 (text), line 115
  (text) and line 115 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][172], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][173], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][174], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][175], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][176], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][177], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 32 (text), line 33 (text), line
  33 (text), line 39 (text), line 40 (text), line 40 (text), line 78 (text), line 79 (text) and line 79 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md][178], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md][179], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md][180], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md][181], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md][182], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md][183], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md][184], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md][185], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md][186], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md][187], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][188], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][189], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][190], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 14 (text), line 38 (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][191], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][192], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][193], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line
  30 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-maps.md][194], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Maps (28 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][195], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][196], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][197], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][198], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 6 (header), line 7 (header) and line 15 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][199], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][200], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (header), line 16 (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line
  68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][201], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 11 (header), line 14 (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102
  (text), line 106 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/configs/maps.yml][202], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 26 (header), line 32 (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][203], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 9 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][204], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][205], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][206], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 72 (body comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][207], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line
  61 (text), line 62 (text), line 63 (text), line 64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line
  90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][208], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header), line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81
  (text), line 90 (text), line 91 (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line
  121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][209], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text)
  and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][210], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][211], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 104 (text) and line 119 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][212], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 2 (header), line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][213], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 5 (header), line 6 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][214], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header), line 3 (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][215], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][216], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][217], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][218], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][219], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (header), line 8 (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][220], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][221], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][222], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 4 (header), line 5 (header) and line 6 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][223], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][224], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][225], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][226], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][227], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][228], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][229], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][230], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Languages (6 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][231], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][232], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][233], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][234], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][235], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][236], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header).

### Docs (5 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][237], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][238], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][239], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][240], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][241], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][242], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][243], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][244], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][245], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/drawio/STYLE.md][246], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 181 (text),
  line 182 (text), line 188 (text), line 196 (text), line 198 (text), line 199 (text) and line 210 (text).
- [.claude/drawio/minimaps/highlights.ps1][247], in the cell .claude × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 52 (body comment) (a passing mention only).

### Globs (2 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/configs/globs.yml][248], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][249], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][250], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text).
- [docs/adr/index.md][251], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][252], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][253], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).

### pipelines (1 lit file)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/ci-automation.yaml][254], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header).

## Keywords

- [world map][255]
- [track][256]
- [file language][257]
- [cell][258]
- [lit cell][259]
- [.claude][243]: a track
- [automation][243]: a track
- [docs][243]: a track
- [pipelines][243]: a track
- [csharp][233]: a file language
- [markdown][233]: a file language
- [pipeline-yaml][233]: a file language
- [powershell][233]: a file language
- [yaml][233]: a file language

Terms the cited ADRs define:

- [cell][258], defined by [ADR-DSGN-TRACK#10][260]
- [deployable-unit][261], defined by [ADR-DSGN-TRACK#5][262]
- [file language][257], defined by [ADR-DSGN-TRACK#6][263]
- [lit cell][259], defined by [ADR-DSGN-TRACK#12][264]
- [root file][265], defined by [ADR-DSGN-TRACK#7][266]
- [stack violation][267], defined by [ADR-DSGN-TRACK#11][268]
- [track][256], defined by [ADR-DSGN-TRACK#1][269]
- [unlisted file][270], defined by [ADR-DSGN-TRACK#8][271]
- [value-chain concern][272], defined by [ADR-DSGN-TRACK#15][273]
- [value-chain map][274], defined by [ADR-DSGN-TRACK#16][275]
- [value-chain stack][276], defined by [ADR-DSGN-TRACK#14][277]
- [verification track][278], defined by [ADR-DSGN-TRACK#2][279]
- [world map][255], defined by [ADR-DSGN-TRACK#9][280]

[1]: ../../adr/design/tracks.md
[2]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[3]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[4]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[5]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[6]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[7]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[8]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[9]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[10]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[11]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[12]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[13]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[14]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[15]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[16]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[17]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[18]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[19]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[20]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[21]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[22]: adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md
[23]: adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
[24]: adr-auto-depm--three-layers-edges-point-down--architecture.chain.md
[25]: adr-auto-depm--three-layers-edges-point-down--architecture.grid.md
[26]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[27]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[28]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md
[29]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md
[30]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
[31]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
[32]: adr-az-naming--how-each-naming-rule-is-held--governance.chain.md
[33]: adr-az-naming--how-each-naming-rule-is-held--governance.grid.md
[34]: adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md
[35]: adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md
[36]: adr-az-naming--names-are-derived-never-typed--operations.chain.md
[37]: adr-az-naming--names-are-derived-never-typed--operations.grid.md
[38]: adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
[39]: adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
[40]: adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
[41]: adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
[42]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[43]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[44]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[45]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[46]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[47]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[48]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[49]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[50]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[51]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[52]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
[53]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
[54]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
[55]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
[56]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
[57]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
[58]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
[59]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
[60]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[61]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[62]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[63]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[64]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[65]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[66]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[67]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[68]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[69]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[70]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[71]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[72]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[73]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[74]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[75]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[76]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[77]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[78]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[79]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[80]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[81]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[82]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[83]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[84]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[85]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[86]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[87]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[88]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[89]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[90]: adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
[91]: adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
[92]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[93]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[94]: adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md
[95]: adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md
[96]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
[97]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
[98]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[99]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[100]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[101]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[102]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[103]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[104]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[105]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[106]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[107]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[108]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[109]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[110]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[111]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[112]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[113]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[114]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[115]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[116]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[117]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[118]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md
[119]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[120]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md
[121]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md
[122]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md
[123]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[124]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md
[125]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md
[126]: adr-dsgn-track--one-unit-one-pipeline--meta.chain.md
[127]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[128]: adr-dsgn-track--one-unit-one-pipeline--meta.grid.md
[129]: adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
[130]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[131]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[132]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[133]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[134]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md
[135]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[136]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md
[137]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md
[138]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[139]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[140]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[141]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[142]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[143]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[144]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[145]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[146]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[147]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[148]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[149]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[150]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[151]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[152]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[153]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[154]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[155]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[156]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[157]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[158]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[159]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[160]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[161]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[162]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[163]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[164]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[165]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[166]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[167]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[168]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[169]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[170]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[171]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[172]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[173]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[174]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[175]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[176]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[177]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[178]: adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
[179]: adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
[180]: adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
[181]: adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
[182]: adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
[183]: adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
[184]: adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
[185]: adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
[186]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
[187]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
[188]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[189]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[190]: ../../explanation/design/one-unit-one-pipeline.md
[191]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[192]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[193]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[194]: ../../references/automation/catzc-base-maps.md
[195]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[196]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[197]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[198]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[199]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[200]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[201]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[202]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[203]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[204]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[205]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[206]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[207]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[208]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[209]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[210]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[211]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[212]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[213]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[214]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[215]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[216]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[217]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[218]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[219]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[220]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[221]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[222]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[223]: ../../adr/design/commit-lifecycle.md
[224]: ../../adr/design/dora-explains.md
[225]: ../../adr/design/module-aspects.md
[226]: ../../adr/design/run-modes.md
[227]: ../../adr/design/self-service.md
[228]: ../../adr/design/server-remote-integration.md
[229]: ../../adr/design/thin-platforms.md
[230]: ../../adr/design/visual-design.md
[231]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[232]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[233]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[234]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[235]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[236]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[237]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[238]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[239]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[240]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[241]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[242]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[243]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[244]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[245]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[246]: ../../../.claude/drawio/STYLE.md
[247]: ../../../.claude/drawio/minimaps/highlights.ps1
[248]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[249]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[250]: ../../adr/glossary.md
[251]: ../../adr/index.md
[252]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[253]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[254]: ../../../pipelines/ci-automation.yaml
[255]: ../../adr/glossary.md#world-map
[256]: ../../adr/glossary.md#track
[257]: ../../adr/glossary.md#file-language
[258]: ../../adr/glossary.md#cell
[259]: ../../adr/glossary.md#lit-cell
[260]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[261]: ../../adr/glossary.md#deployable-unit
[262]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[263]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[264]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[265]: ../../adr/glossary.md#root-file
[266]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[267]: ../../adr/glossary.md#stack-violation
[268]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[269]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[270]: ../../adr/glossary.md#unlisted-file
[271]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[272]: ../../adr/glossary.md#value-chain-concern
[273]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[274]: ../../adr/glossary.md#value-chain-map
[275]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[276]: ../../adr/glossary.md#value-chain-stack
[277]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[278]: ../../adr/glossary.md#verification-track
[279]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[280]: ../../adr/design/tracks.md#rule-adr-dsgn-track9
