# docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md

`Tree minimap: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance`

![Tree minimap of adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.png)

The tree minimap of the slide `adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance` (governance lens). The slide supports
[ADR-DSGN-TRACK][1], [ADR-FLOW-CD][2], [ADR-FLOW-CD-GLOBS][3] and [ADR-REPO-FOLDERS][4]; the highlight of those ADR codes selects what is
lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 407 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 262 lit files
- Globs (automation/Catzc.Base.Globs): 38 lit files
- Maps (automation/Catzc.Base.Maps): 29 lit files
- adr/repo (docs/adr/repository): 15 lit files
- Docs (automation/Catzc.Base.Docs): 9 lit files
- Languages (automation/Catzc.Base.Languages): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- .claude: 3 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .github: 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file

## Why each group is lit

### docs (262 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][9], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][10], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68
  (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 29 (text), line 29 (text), line 36 (text), line 37 (text), line 37 (text),
  line 44 (text), line 45 (text), line 45 (text), line 102 (text), line 103 (text), line 103 (text), line 112 (text), line 113 (text), line
  113 (text), line 280 (text), line 281 (text), line 281 (text), line 290 (text), line 291 (text) and line 291 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][13], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text), line 68
  (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][15], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][17], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][18], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36 (text),
  line 43 (text), line 44 (text), line 44 (text), line 101 (text), line 102 (text), line 102 (text), line 111 (text), line 112 (text), line
  112 (text), line 279 (text), line 280 (text), line 280 (text), line 289 (text), line 290 (text) and line 290 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][19], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 44 (text), line 47 (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text),
  line 61 (text), line 62 (text), line 66 (text), line 69 (text), line 70 (text), line 72 (text), line 73 (text), line 77 (text), line 80
  (text) and line 81 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][20], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 38 (text), line 39 (text), line 39 (text),
  line 46 (text), line 47 (text), line 47 (text), line 175 (text), line 176 (text), line 176 (text), line 306 (text), line 307 (text), line
  307 (text), line 330 (text), line 331 (text), line 331 (text), line 613 (text), line 614 (text), line 614 (text), line 629 (text), line
  630 (text) and line 630 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][21], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][22], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35
  (text), line 42 (text), line 43 (text), line 43 (text), line 59 (text), line 60 (text), line 60 (text), line 67 (text), line 68 (text),
  line 68 (text), line 192 (text), line 193 (text) and line 193 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][23], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 31 (text), line 32 (text), line 36 (text), line 39 (text), line 40
  (text), line 44 (text), line 47 (text), line 48 (text), line 52 (text), line 55 (text), line 56 (text), line 58 (text), line 59 (text),
  line 63 (text), line 66 (text), line 67 (text), line 71 (text), line 74 (text) and line 75 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][24], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line 42 (text),
  line 49 (text), line 50 (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 755 (text), line 756 (text), line 756
  (text), line 790 (text), line 791 (text), line 791 (text), line 1039 (text), line 1040 (text), line 1040 (text), line 1047 (text), line
  1048 (text), line 1048 (text), line 1061 (text), line 1062 (text) and line 1062 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md][25], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md][26], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.chain.md][27], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--three-layers-edges-point-down--architecture.grid.md][28], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32
  (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md][29], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text) and line 36
  (text).
- [docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md][30], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 41 (text), line 42 (text), line 42 (text),
  line 62 (text), line 63 (text), line 63 (text), line 672 (text), line 673 (text), line 673 (text), line 703 (text), line 704 (text), line
  704 (text), line 844 (text), line 845 (text), line 845 (text), line 852 (text), line 853 (text), line 853 (text), line 863 (text), line
  864 (text) and line 864 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md][31], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md][32], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32
  (text), line 32 (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md][33], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md][34], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 40 (text), line 41 (text), line 41 (text), line 47 (text), line 48 (text) and line 48 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.chain.md][35], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.grid.md][36], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md][37], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md][38], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.chain.md][39], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md][40], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md][41], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md][42], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md][43], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md][44], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35
  (text), line 54 (text), line 55 (text), line 55 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md][45], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md][46], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md][47], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md][48], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md][49], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35
  (text), line 38 (text) and line 39 (text).
- [docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md][50], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 40 (text), line 41 (text), line 41
  (text), line 62 (text), line 63 (text), line 63 (text), line 693 (text), line 694 (text), line 694 (text), line 724 (text), line 725
  (text), line 725 (text), line 879 (text), line 880 (text), line 880 (text), line 887 (text), line 888 (text), line 888 (text), line 898
  (text), line 899 (text) and line 899 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md][51], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md][52], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line 36 (text),
  line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.chain.md][53], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-conf-loading--three-caches-back-one-reader--implementation.grid.md][54], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 35 (text), line 36 (text), line
  36 (text), line 58 (text), line 59 (text), line 59 (text), line 65 (text), line 66 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md][55], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md][57], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md][58], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md][59], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35
  (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md][60], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md][61], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md][62], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 47 (text), line 48 (text), line 48 (text), line 56 (text), line 57 (text) and line 57 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][63], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 36 (text), line 39 (text), line 40 (text), line 44 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text),
  line 53 (text) and line 54 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 30 (text) and line 30
  (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 52 (text), line 52 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][64], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text) and line 76 (text); selected by [ADR-REPO-FOLDERS][4]:
  the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][65], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 28 (text), line 29 (text), line 29 (text), line 35 (text), line 36
  (text), line 36 (text), line 43 (text), line 44 (text), line 44 (text), line 66 (text), line 67 (text), line 67 (text), line 157 (text),
  line 158 (text), line 158 (text), line 177 (text), line 178 (text), line 178 (text), line 381 (text), line 382 (text) and line 382 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 38 (text), line 47 (text), line 48 (text), line 50 (text),
  line 52 (text), line 56 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 78 (text), line 79 (text), line 81
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 93 (text), line 95 (text),
  line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 103 (text), line 104 (text), line 106 (text), line 108 (text), line
  110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 122 (text), line 124 (text), line 126 (text), line
  128 (text), line 130 (text), line 132 (text), line 135 (text), line 137 (text), line 139 (text), line 143 (text), line 146 (text), line
  149 (text), line 151 (text), line 160 (text), line 163 (text), line 169 (text), line 191 (text), line 196 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 212 (text), line 215 (text), line
  217 (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 247 (text), line
  338 (text), line 342 (text), line 346 (text), line 350 (text), line 352 (text), line 354 (text), line 356 (text), line 359 (text), line
  361 (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line
  384 (text), line 385 (text), line 386 (text), line 387 (text), line 388 (text) and line 389 (text); selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 8 (text), line 58 (text), line 59 (text), line 60 (text), line 77 (text), line 141 (text), line 164 (text), line 166
  (text), line 168 (text), line 193 (text), line 196 (text), line 246 (text), line 249 (text), line 302 (text), line 304 (text), line 306
  (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322
  (text), line 324 (text), line 326 (text), line 328 (text), line 330 (text), line 335 (text), line 348 (text), line 351 (text), line 376
  (text) and line 411 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][66], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 40 (text), line 42 (text), line 44 (text), line 46
  (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text),
  line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 75 (text), line 76 (text), line 79 (text), line 81 (text), line 83
  (text), line 85 (text), line 87 (text), line 89 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 107 (text), line 108 (text), line 111 (text), line 114 (text), line 115 (text), line 117 (text), line 120 (text),
  line 124 (text), line 143 (text), line 148 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text),
  line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 177 (text), line 183 (text), line 186 (text),
  line 190 (text), line 193 (text), line 195 (text), line 197 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text),
  line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 356 (text), line 363 (text), line 365 (text),
  line 368 (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384 (text), line 391 (text),
  line 393 (text), line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 409 (text), line 411 (text), line 413 (text),
  line 415 (text), line 417 (text), line 424 (text), line 464 (text), line 478 (text) and line 485 (text); selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 145 (text), line 148 (text), line 173 (text), line 189 (text), line 191
  (text), line 218 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line 310
  (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 326
  (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text), line 451 (text), line 453 (text), line 455 (text), line 462
  (text), line 465 (text), line 493 (text) and line 515 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][67], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line
  36 (text), line 40 (text), line 43 (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][68], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line
  31 (text), line 38 (text), line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][69], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 36 (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text),
  line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][70], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35
  (text), line 35 (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][71], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text),
  line 38 (text), line 39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53
  (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][72], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text),
  line 44 (text), line 45 (text) and line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][73], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line
  28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text)
  and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][74], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][75], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line
  40 (text), line 48 (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text),
  line 82 (text), line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line
  125 (text), line 127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line
  147 (text), line 151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line
  179 (text), line 181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][76], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text),
  line 104 (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text),
  line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text),
  line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text),
  line 213 (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][77], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line
  36 (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text)
  and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][78], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line
  35 (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][79], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line
  28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text)
  and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][80], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][81], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line
  40 (text), line 48 (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text),
  line 82 (text), line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line
  125 (text), line 127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line
  147 (text), line 151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line
  179 (text), line 181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][82], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text),
  line 104 (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text),
  line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text),
  line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text),
  line 213 (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][83], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text),
  line 59 (text), line 60 (text), line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line
  28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text)
  and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][84], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][85], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line
  36 (text), line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text)
  and line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line
  40 (text), line 48 (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text),
  line 82 (text), line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line
  125 (text), line 127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line
  147 (text), line 151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line
  179 (text), line 181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][86], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text),
  line 104 (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text),
  line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text),
  line 177 (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text),
  line 213 (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][87], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36
  (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and
  line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][88], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35
  (text), line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][89], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 30 (text), line 31 (text), line 35 (text),
  line 38 (text), line 39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 52 (text) and line 53
  (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][90], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 33 (text), line 34 (text), line 34 (text),
  line 44 (text), line 45 (text) and line 45 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][91], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 36
  (text), line 39 (text), line 40 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text), line 53 (text) and
  line 54 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][92], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 34 (text), line 35 (text), line 35 (text),
  line 45 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][93], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 27 (text), line 28 (text), line 32 (text), line 35 (text), line 36 (text),
  line 40 (text), line 43 (text) and line 44 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][94], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 24 (text), line 24 (text), line 30 (text), line 31 (text), line 31 (text),
  line 38 (text), line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][95], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line 38 (text),
  line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 51 (text), line 52 (text), line 56 (text), line 59
  (text), line 60 (text), line 62 (text) and line 63 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28
  (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and
  line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][96], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][97], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 35 (text), line 36 (text), line 36 (text),
  line 45 (text), line 46 (text), line 46 (text), line 55 (text), line 56 (text), line 56 (text), line 66 (text), line 67 (text) and line 67
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text),
  line 48 (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82
  (text), line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125
  (text), line 127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147
  (text), line 151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179
  (text), line 181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][98], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line
  65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104
  (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151
  (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177
  (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213
  (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][99], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line 39
  (text), line 41 (text), line 42 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text), line 53 (text), line 55 (text),
  line 56 (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 69 (text), line 70 (text), line 72
  (text), line 73 (text), line 77 (text), line 80 (text) and line 81 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8
  (text), line 29 (text), line 29 (text), line 43 (text), line 43 (text), line 57 (text), line 57 (text), line 71 (text), line 71 (text),
  line 96 (text) and line 100 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][100], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][101], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 29 (text), line 30 (text), line 30 (text), line 46 (text), line 47 (text), line 47
  (text), line 65 (text), line 66 (text), line 66 (text), line 679 (text), line 680 (text), line 680 (text), line 714 (text), line 715
  (text), line 715 (text), line 959 (text), line 960 (text), line 960 (text), line 967 (text), line 968 (text), line 968 (text), line 978
  (text), line 979 (text) and line 979 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 42
  (text), line 49 (text), line 52 (text), line 309 (text), line 310 (text), line 316 (text), line 688 (text), line 700 (text), line 705
  (text), line 730 (text), line 734 (text), line 736 (text), line 747 (text), line 750 (text), line 756 (text), line 759 (text), line 760
  (text), line 762 (text), line 764 (text), line 867 (text), line 869 (text), line 870 (text), line 872 (text), line 874 (text), line 876
  (text), line 879 (text), line 882 (text), line 901 (text), line 905 (text), line 911 (text), line 925 (text), line 930 (text), line 931
  (text), line 933 (text), line 935 (text), line 939 (text), line 943 (text), line 1012 (text) and line 1016 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][102], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 114 (text), line 343 (text), line 348 (text), line 350 (text), line 362
  (text), line 366 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 405 (text), line 409
  (text), line 415 (text), line 429 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 446 (text), line 450
  (text), line 568 (text), line 632 (text), line 635 (text), line 730 (text), line 846 (text), line 847 (text), line 858 (text), line 1016
  (text), line 1027 (text), line 1033 (text), line 1035 (text), line 1037 (text), line 1039 (text), line 1041 (text), line 1043 (text), line
  1211 (text), line 1214 (text), line 1296 (text) and line 1300 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][103], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 40 (text), line 41 (text), line 45 (text), line 48 (text), line 49 (text), line 53 (text), line 56 (text) and line 57
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][104], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32
  (text), line 40 (text), line 41 (text) and line 41 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md][105], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md][106], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][107], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 41 (text), line 42 (text), line 46 (text), line 49 (text), line 50 (text), line 54 (text), line 57 (text), line 58 (text),
  line 62 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][108], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line
  34 (text), line 40 (text), line 41 (text), line 41 (text), line 48 (text), line 49 (text), line 49 (text), line 58 (text), line 59 (text)
  and line 59 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md][109], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md][110], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md][111], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md][112], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][113], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][114], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line 72 (text),
  line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150 (text) and
  line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][115], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][116], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][117], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][118], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][119], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][120], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][121], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][122], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 71 (text), line 72 (text), line
  72 (text), line 79 (text), line 80 (text), line 80 (text), line 140 (text), line 141 (text), line 141 (text), line 149 (text), line 150
  (text) and line 150 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][123], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and line 35
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][124], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and line 31
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][125], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][126], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and
  line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][127], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37
  (text), line 38 (text), line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][128], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 39 (text), line 40 (text), line
  40 (text), line 50 (text), line 51 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][129], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text), line 27 (text), line 31 (text), line 34 (text) and
  line 35 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][130], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 30 (text), line 31 (text) and
  line 31 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][131], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 43 (text), line 46 (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text)
  and line 63 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][132], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 41 (text), line 42 (text), line 42
  (text), line 52 (text), line 53 (text), line 53 (text), line 209 (text), line 210 (text) and line 210 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md][133], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line
  26 (text), line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md][134], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md][135], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md][136], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md][137], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 23 (text), line 25 (text), line 25 (text), line 26
  (text), line 27 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md][138], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md][139], in the cell docs ×
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
- [docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md][140], in the cell docs ×
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
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.chain.md][141], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line 26 (text),
  line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text), line 46
  (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md][142], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 64 (text).
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.grid.md][143], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md][144], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][145], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 30 (text), line 31 (text), line
  32 (text), line 34 (text), line 35 (text), line 39 (text), line 42 (text), line 43 (text), line 47 (text), line 50 (text), line 51 (text),
  line 55 (text), line 58 (text), line 59 (text), line 63 (text), line 66 (text), line 67 (text), line 71 (text), line 74 (text), line 75
  (text), line 87 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text),
  line 98 (text), line 99 (text), line 100 (text), line 101 (text) and line 102 (text); selected by [ADR-FLOW-CD][2]: the file cites it at
  line 8 (text), line 41 (text), line 41 (text), line 49 (text), line 49 (text), line 57 (text), line 57 (text), line 65 (text), line 65
  (text), line 91 (text) and line 93 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 33 (text) and line
  33 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 73 (text), line 73 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][146], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 60 (text) and line 68 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 60 (text) and line 68 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][147], in the cell docs × markdown:
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
  line 502 (text), line 503 (text), line 504 (text), line 505 (text), line 506 (text), line 507 (text), line 508 (text) and line 509 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 61 (text), line 63 (text), line 189
  (text), line 195 (text), line 209 (text), line 245 (text), line 259 (text), line 260 (text), line 272 (text), line 274 (text), line 276
  (text), line 278 (text), line 280 (text), line 293 (text), line 296 (text), line 297 (text), line 299 (text), line 301 (text), line 339
  (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 353 (text), line 355 (text), line 392
  (text), line 396 (text), line 400 (text), line 409 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 436
  (text), line 444 (text), line 498 (text) and line 500 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line
  49 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 74 (text), line 112 (text), line 114 (text), line 116
  (text), line 118 (text), line 123 (text), line 124 (text), line 126 (text), line 127 (text), line 129 (text), line 131 (text), line 133
  (text), line 134 (text), line 136 (text), line 137 (text), line 139 (text), line 141 (text), line 142 (text), line 144 (text), line 146
  (text), line 147 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160
  (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 176
  (text), line 178 (text), line 181 (text), line 225 (text), line 226 (text), line 230 (text), line 232 (text), line 242 (text), line 246
  (text), line 251 (text), line 270 (text), line 289 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312
  (text), line 314 (text), line 316 (text), line 317 (text), line 320 (text), line 322 (text), line 340 (text), line 342 (text), line 344
  (text), line 346 (text), line 348 (text), line 350 (text), line 356 (text), line 394 (text), line 402 (text), line 406 (text), line 413
  (text), line 425 (text), line 427 (text), line 429 (text), line 432 (text), line 434 (text), line 438 (text), line 440 (text), line 442
  (text), line 446 (text), line 448 (text), line 450 (text), line 455 (text), line 466 (text), line 467 (text), line 468 (text), line 469
  (text), line 471 (text) and line 472 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line 76 (text), line
  78 (text), line 80 (text), line 120 (text), line 223 (text), line 246 (text), line 247 (text), line 249 (text), line 270 (text), line 290
  (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 368
  (text), line 370 (text), line 372 (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384
  (text), line 386 (text), line 390 (text), line 407 (text), line 413 (text), line 456 (text) and line 496 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][148], in the cell docs × markdown:
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
  (text) and line 599 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 44 (text), line 46 (text), line 48
  (text), line 50 (text), line 52 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 98 (text),
  line 102 (text), line 106 (text), line 115 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 143 (text),
  line 151 (text), line 263 (text), line 270 (text), line 288 (text), line 367 (text), line 383 (text), line 385 (text), line 440 (text),
  line 455 (text), line 458 (text), line 460 (text), line 462 (text), line 465 (text), line 468 (text), line 520 (text), line 522 (text),
  line 535 (text), line 544 (text), line 547 (text), line 588 (text) and line 590 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 8 (text), line 41 (text), line 60 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line
  85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100 (text), line 108 (text), line 113 (text), line 119
  (text), line 132 (text), line 134 (text), line 136 (text), line 139 (text), line 141 (text), line 145 (text), line 147 (text), line 149
  (text), line 153 (text), line 155 (text), line 157 (text), line 162 (text), line 173 (text), line 175 (text), line 177 (text), line 179
  (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 190 (text), line 192 (text), line 193 (text), line 195
  (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 207 (text), line 208 (text), line 211 (text), line 213
  (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229
  (text), line 231 (text), line 233 (text), line 235 (text), line 236 (text), line 239 (text), line 241 (text), line 243 (text), line 245
  (text), line 248 (text), line 252 (text), line 368 (text), line 438 (text), line 443 (text), line 447 (text), line 449 (text), line 456
  (text), line 459 (text), line 461 (text), line 463 (text), line 466 (text), line 469 (text), line 475 (text), line 477 (text), line 479
  (text), line 481 (text), line 484 (text), line 485 (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line 501
  (text), line 547 (text), line 554 (text) and line 561 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (text), line
  41 (text), line 61 (text), line 96 (text), line 113 (text), line 119 (text), line 164 (text), line 331 (text), line 333 (text), line 335
  (text), line 337 (text), line 339 (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 351
  (text), line 353 (text), line 355 (text), line 357 (text), line 359 (text), line 368 (text), line 370 (text), line 372 (text), line 374
  (text), line 400 (text), line 404 (text), line 408 (text), line 532 (text), line 545 (text), line 548 (text) and line 586 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md][149], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 8 (text), line 22 (text), line 24 (text), line 24 (text), line 25 (text), line
  26 (text), line 38 (text), line 39 (text), line 40 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text), line 45 (text),
  line 46 (text), line 47 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md][150], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md][151], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md][152], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][153], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text),
  line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text),
  line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][154], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][155], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text),
  line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text),
  line 46 (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98
  (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114
  (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md][156], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text),
  line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and
  line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][157], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36
  (text), line 37 (text), line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][158], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][159], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line
  34 (text), line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text)
  and line 64 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line
  38 (text), line 46 (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text),
  line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text),
  line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md][160], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78
  (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text),
  line 106 (text), line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text),
  line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][161], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line
  37 (text), line 40 (text), line 41 (text), line 43 (text), line 44 (text), line 48 (text), line 51 (text), line 52 (text), line 54 (text),
  line 55 (text), line 59 (text), line 62 (text), line 63 (text), line 65 (text) and line 66 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text),
  line 61 (text), line 78 (text) and line 79 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][162], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][163], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 28 (text), line 28 (text), line 35 (text), line 36 (text), line 36
  (text), line 49 (text), line 50 (text), line 50 (text), line 68 (text), line 69 (text), line 69 (text), line 80 (text), line 81 (text),
  line 81 (text), line 141 (text), line 142 (text) and line 142 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text),
  line 30 (text), line 31 (text), line 42 (text), line 44 (text), line 61 (text), line 62 (text), line 63 (text), line 73 (text), line 75
  (text), line 76 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 96 (text),
  line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line
  113 (text), line 115 (text), line 116 (text), line 118 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line
  127 (text), line 129 (text), line 131 (text), line 134 (text), line 136 (text), line 166 (text) and line 167 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md][164], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 74 (text), line 76 (text), line 100 (text), line 103 (text),
  line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text), line 120 (text), line 122 (text), line 129 (text),
  line 131 (text), line 133 (text), line 140 (text), line 141 (text), line 147 (text), line 149 (text), line 179 (text), line 186 (text),
  line 208 (text) and line 209 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][165], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line 37 (text),
  line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 7 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line 43 (text), line 51 (text),
  line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][166], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][167], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line 34 (text),
  line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text) and line 64
  (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text),
  line 46 (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98
  (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114
  (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md][168], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text),
  line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and
  line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][169], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line
  37 (text), line 41 (text), line 44 (text), line 45 (text), line 49 (text), line 52 (text) and line 53 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][170], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][171], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 33 (text), line 34 (text), line
  34 (text), line 43 (text), line 44 (text), line 44 (text), line 53 (text), line 54 (text), line 54 (text), line 63 (text), line 64 (text)
  and line 64 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line
  38 (text), line 46 (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text),
  line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text),
  line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text),
  line 114 (text), line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md][172], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78
  (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text),
  line 106 (text), line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text),
  line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][173], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][174], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][175], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the
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
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md][176], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text),
  line 57 (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line
  111 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line
  134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line
  149 (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line
  187 (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line
  208 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line
  235 (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][177], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][178], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][179], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85
  (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text),
  line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text),
  line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text),
  line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text),
  line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text),
  line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md][180], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57
  (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111
  (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134
  (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149
  (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235
  (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][181], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 28 (text), line 29 (text), line 33 (text), line 36 (text), line
  37 (text), line 41 (text), line 44 (text) and line 45 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line
  27 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][182], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][183], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 41 (text), line 42 (text), line
  42 (text), line 49 (text), line 50 (text), line 50 (text), line 78 (text), line 79 (text), line 79 (text), line 774 (text), line 775
  (text), line 775 (text), line 811 (text), line 812 (text), line 812 (text), line 1000 (text), line 1001 (text), line 1001 (text), line
  1013 (text), line 1014 (text), line 1014 (text), line 1024 (text), line 1025 (text) and line 1025 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 57 (text), line 59
  (text), line 63 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 280 (text), line 290 (text), line 292 (text),
  line 294 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 305 (text), line 309 (text), line 311 (text),
  line 312 (text), line 315 (text), line 319 (text), line 320 (text), line 321 (text), line 323 (text), line 325 (text), line 327 (text),
  line 330 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 343 (text), line 345 (text), line 347 (text),
  line 350 (text), line 351 (text), line 360 (text), line 366 (text), line 368 (text), line 371 (text), line 446 (text), line 481 (text),
  line 489 (text), line 513 (text), line 777 (text), line 784 (text), line 793 (text), line 821 (text), line 825 (text), line 827 (text),
  line 829 (text), line 831 (text), line 834 (text), line 836 (text), line 838 (text), line 840 (text), line 842 (text), line 845 (text),
  line 847 (text), line 926 (text), line 928 (text), line 930 (text), line 932 (text), line 934 (text), line 936 (text), line 941 (text),
  line 949 (text), line 951 (text), line 954 (text), line 956 (text), line 959 (text), line 961 (text), line 964 (text), line 967 (text),
  line 969 (text), line 971 (text), line 975 (text), line 977 (text), line 979 (text), line 981 (text), line 986 (text), line 993 (text),
  line 1003 (text), line 1004 (text), line 1005 (text), line 1006 (text), line 1007 (text) and line 1009 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][184], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 71 (text), line 126 (text), line 134 (text), line 158 (text),
  line 346 (text), line 348 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 364 (text),
  line 369 (text), line 371 (text), line 372 (text), line 375 (text), line 380 (text), line 381 (text), line 384 (text), line 386 (text),
  line 389 (text), line 391 (text), line 393 (text), line 395 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text),
  line 411 (text), line 413 (text), line 415 (text), line 417 (text), line 419 (text), line 429 (text), line 435 (text), line 436 (text),
  line 439 (text), line 442 (text), line 444 (text), line 446 (text), line 449 (text), line 454 (text), line 469 (text), line 473 (text),
  line 475 (text), line 477 (text), line 479 (text), line 482 (text), line 484 (text), line 486 (text), line 488 (text), line 491 (text),
  line 493 (text), line 495 (text), line 502 (text), line 504 (text), line 509 (text), line 510 (text), line 515 (text), line 517 (text),
  line 520 (text), line 523 (text), line 525 (text), line 527 (text), line 531 (text), line 533 (text), line 536 (text), line 537 (text),
  line 543 (text), line 552 (text), line 695 (text), line 1071 (text), line 1073 (text), line 1075 (text), line 1077 (text), line 1079
  (text), line 1087 (text), line 1089 (text), line 1091 (text), line 1093 (text), line 1095 (text), line 1097 (text), line 1104 (text), line
  1106 (text), line 1108 (text), line 1110 (text), line 1112 (text), line 1115 (text), line 1178 (text), line 1296 (text) and line 1302
  (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][185], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][186], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][187], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85
  (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text),
  line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text),
  line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text),
  line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text),
  line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text),
  line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md][188], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57
  (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111
  (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134
  (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149
  (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235
  (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][189], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][190], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][191], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the
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
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md][192], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text),
  line 57 (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line
  111 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line
  134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line
  149 (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line
  187 (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line
  208 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line
  235 (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][193], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][194], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][195], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35
  (text), line 35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142
  (text), line 143 (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the
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
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md][196], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text),
  line 57 (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74
  (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text),
  line 92 (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line
  111 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line
  134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line
  149 (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line
  187 (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line
  208 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line
  235 (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][197], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 29 (text), line 30 (text), line 34 (text), line 37 (text), line
  38 (text), line 42 (text), line 45 (text), line 46 (text), line 50 (text), line 53 (text) and line 54 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][198], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][199], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 30 (text), line 31 (text), line 31 (text), line 42 (text), line 43 (text), line
  43 (text), line 50 (text), line 51 (text), line 51 (text), line 79 (text), line 80 (text), line 80 (text), line 776 (text), line 777
  (text), line 777 (text), line 815 (text), line 816 (text), line 816 (text), line 1025 (text), line 1026 (text), line 1026 (text), line
  1038 (text), line 1039 (text), line 1039 (text), line 1049 (text), line 1050 (text) and line 1050 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 45 (text), line 55 (text), line 56 (text), line 58 (text), line 60
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
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][200], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 72 (text), line 128 (text), line 136 (text), line 160 (text),
  line 348 (text), line 350 (text), line 354 (text), line 356 (text), line 358 (text), line 360 (text), line 362 (text), line 366 (text),
  line 371 (text), line 373 (text), line 374 (text), line 377 (text), line 382 (text), line 383 (text), line 386 (text), line 388 (text),
  line 391 (text), line 393 (text), line 395 (text), line 397 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text),
  line 413 (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 431 (text), line 437 (text), line 438 (text),
  line 441 (text), line 444 (text), line 446 (text), line 448 (text), line 451 (text), line 456 (text), line 473 (text), line 477 (text),
  line 479 (text), line 481 (text), line 483 (text), line 486 (text), line 488 (text), line 490 (text), line 492 (text), line 496 (text),
  line 498 (text), line 500 (text), line 509 (text), line 511 (text), line 516 (text), line 517 (text), line 522 (text), line 524 (text),
  line 527 (text), line 530 (text), line 532 (text), line 534 (text), line 538 (text), line 541 (text), line 544 (text), line 545 (text),
  line 551 (text), line 560 (text), line 703 (text), line 1098 (text), line 1100 (text), line 1102 (text), line 1104 (text), line 1106
  (text), line 1114 (text), line 1116 (text), line 1118 (text), line 1120 (text), line 1122 (text), line 1124 (text), line 1131 (text), line
  1133 (text), line 1135 (text), line 1137 (text), line 1139 (text), line 1142 (text), line 1205 (text), line 1333 (text) and line 1340
  (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][201], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][202], in the cell docs × markdown: selected
  by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][203], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line 35 (text),
  line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143 (text), line
  143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text),
  line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58
  (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86
  (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text),
  line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text),
  line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text),
  line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text),
  line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text),
  line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and
  line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md][204], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
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
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][205], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][206], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][207], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85
  (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text),
  line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text),
  line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text),
  line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text),
  line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text),
  line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md][208], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57
  (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111
  (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134
  (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149
  (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235
  (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][209], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text); selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][210], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][211], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 34 (text), line 35 (text), line
  35 (text), line 51 (text), line 52 (text), line 52 (text), line 131 (text), line 132 (text), line 132 (text), line 142 (text), line 143
  (text), line 143 (text), line 217 (text), line 218 (text) and line 218 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 46 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text), line 81 (text), line 83 (text), line 85
  (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text),
  line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line 126 (text), line 134 (text), line 136 (text),
  line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text),
  line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line 169 (text), line 171 (text), line 173 (text),
  line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text),
  line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text),
  line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line 221 (text), line 222 (text), line 223 (text),
  line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md][212], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 49 (text), line 51 (text), line 52 (text), line 54 (text), line 57
  (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text),
  line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 95 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 107 (text), line 111
  (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134
  (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 143 (text), line 145 (text), line 148 (text), line 149
  (text), line 151 (text), line 153 (text), line 155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 185 (text), line 187
  (text), line 189 (text), line 191 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206 (text), line 208
  (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 230 (text), line 233 (text), line 235
  (text), line 237 (text), line 243 (text), line 250 (text), line 257 (text) and line 264 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md][213], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md][214], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line 32 (text),
  line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md][215], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 27 (text), line 30 (text), line 31 (text), line 35 (text), line 38 (text), line
  39 (text), line 43 (text), line 46 (text), line 47 (text), line 51 (text), line 54 (text), line 55 (text), line 59 (text), line 62 (text)
  and line 63 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md][216], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 26 (text), line 27 (text), line 27 (text), line 33 (text), line 34 (text), line
  34 (text), line 49 (text), line 50 (text), line 50 (text), line 61 (text), line 62 (text), line 62 (text), line 114 (text), line 115
  (text) and line 115 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md][217], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md][218], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md][219], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md][220], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 24 (text), line 25 (text), line 25 (text), line 31 (text), line 32 (text), line
  32 (text), line 38 (text), line 39 (text), line 39 (text), line 77 (text), line 78 (text) and line 78 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md][221], in the cell docs ×
  markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 23 (text), line 26 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md][222], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 25 (text), line 26 (text), line 26 (text), line 32 (text), line 33 (text), line
  33 (text), line 39 (text), line 40 (text), line 40 (text), line 78 (text), line 79 (text) and line 79 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md][223], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md][224], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md][225], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md][226], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.chain.md][227], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.grid.md][228], in the cell docs × markdown: selected
  by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md][229], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md][230], in the cell docs × markdown:
  selected by [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and
  line 30 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md][231], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 25 (text) and line 26 (text).
- [docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md][232], in the cell docs × markdown: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 22 (text), line 23 (text), line 23 (text), line 29 (text), line 30 (text) and line 30
  (text).
- [docs/explanation/design/a-push-fires-only-touched-pipelines.md][233], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 16 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][234], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 52 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][235], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 55 (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][236], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 51 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][237], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md][238], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 16 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][239], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][240], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 59 (text).
- [docs/explanation/design/one-unit-one-pipeline.md][241], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 14 (text), line 38 (text), line 39 (text), line 40 (text) and line 43 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][242], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 49 (text) and line 67 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at
  line 38 (text), line 57 (text) and line 71 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][243], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and line 55 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][244], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 17 (text), line 54 (text), line 56 (text), line 57 (text), line 57 (text), line 58 (text) and line 60 (text);
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 59 (text) and line 59 (text); selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/units-not-tracks-own-the-pipelines.md][245], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 15 (text), line 47 (text), line 48 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][246], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][247], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][248], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][249], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][250], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][251], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][252], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57
  (text), line 58 (text), line 59 (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][253], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][254], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][255], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][256], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 18 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][257], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 16 (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][258], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 13 (text), line 38 (text) and line 40 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][259], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][260], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][261], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 15 (text), line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][262], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 18 (text).
- [docs/how-to/automation/manual-test-plan/repository-conventions.md][263], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 19 (text), line 25 (text), line 25 (text), line 28 (text), line 28 (text), line 30 (text), line 30 (text), line
  30 (text), line 31 (text) and line 32 (text).
- [docs/references/automation/catzc-base-globs.md][264], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][265], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 47 (text) and line 77 (text).
- [docs/references/automation/catzc-base-maps.md][266], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 68 (text), line 70 (text) and line 82 (text).

### Globs (38 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][267], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][268], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][269], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][270], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][271], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][272], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][273], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 72 (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][274], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][275], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][276], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][277], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][278], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][279], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][280], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 113 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 7
  (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][281], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][282], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][283], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][284], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][285], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][286], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][287], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][288], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][289], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][290], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][291], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][292], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][293], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][294], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][295], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][296], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][297], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][298], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][299], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 50 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 3 (header), line 5
  (header), line 13 (body comment), line 62 (text), line 75 (text), line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][300], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it
  at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][301], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][302], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][303], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites
  it at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][304], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][3]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### Maps (29 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1][305], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (header), line 11 (header), line 13 (header) and line 33 (header).
- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][306], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 8 (header), line 9 (header) and line 22 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 20
  (header).
- [automation/Catzc.Base.Maps/Get-ValueChainMap.ps1][307], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 6 (header), line 8 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/Get-WorldMap.ps1][308], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 6 (header), line 7 (header) and line 15 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][309], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 12 (header) and line 33 (header); selected by [ADR-FLOW-CD][2]: the file cites it at line 31 (header).
- [automation/Catzc.Base.Maps/Test-ValueChainMap.ps1][310], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 14 (header), line 16 (header), line 19 (header), line 23 (header), line 54 (text), line 55 (text), line 65 (text), line
  68 (text) and line 85 (text).
- [automation/Catzc.Base.Maps/Test-WorldMap.ps1][311], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 11 (header), line 14 (header), line 18 (header), line 22 (header), line 23 (header), line 66 (text), line 85 (text), line 102
  (text), line 106 (text) and line 107 (text).
- [automation/Catzc.Base.Maps/configs/maps.yml][312], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 26 (header), line 32 (header), line 34 (header) and line 39 (header).
- [automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1][313], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 9 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1][314], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 21 (text), line 27 (text) and line 46 (text).
- [automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1][315], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 2 (header), line 21 (text), line 42 (text) and line 42 (body comment).
- [automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1][316], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 72 (body comment) and line 88 (text).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][317], in the cell automation × powershell: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and line 71 (text).
- [automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1][318], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 4 (header), line 57 (text), line 57 (body comment), line
  61 (text), line 62 (text), line 63 (text), line 64 (text), line 68 (text), line 71 (text), line 90 (text), line 90 (body comment) and line
  90 (body comment).
- [automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1][319], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header), line 3 (header), line 65 (text), line 69 (text), line 72 (text), line 76 (text), line 77 (text), line 81
  (text), line 90 (text), line 91 (text), line 95 (text), line 99 (text), line 100 (text), line 121 (text), line 121 (body comment) and line
  121 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1][320], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 3 (header), line 19 (text), line 26 (text), line 32 (text), line 49 (text)
  and line 49 (body comment).
- [automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1][321], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 2 (header), line 20 (text), line 29 (text), line 34 (text) and line 42 (text).
- [automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1][322], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 104 (text) and line 119 (text).
- [automation/Catzc.Base.Maps/types/MapCell.cs][323], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 2 (header), line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][324], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 5 (header), line 6 (header) and line 10 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][325], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header), line 3 (header), line 15 (body comment) and line 18 (body comment).
- [automation/Catzc.Base.Maps/types/ValueChainHighlight.cs][326], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainMap.cs][327], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 2 (header), line 3 (header) and line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][328], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMap.cs][329], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][330], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 7 (header), line 8 (header) and line 11 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][331], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 3 (header) and line 4 (header).
- [automation/Catzc.Base.Maps/types/WorldMapHighlight.cs][332], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Maps/types/WorldMapPdf.cs][333], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 4 (header), line 5 (header) and line 6 (header).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][334], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][335], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][336], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][4], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][337], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][338], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][339], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][340], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][341], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][342], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][343], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][344], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][345], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][346], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][347], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][4]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Docs (9 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][348], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 11 (header), line 12 (header) and line 95 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line
  118 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 122 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 307 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][349], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][350], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][4]: the file cites
  it at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][351], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][4]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][352], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]:
  the file cites it at line 99 (text) and line 99 (body comment).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][353], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][354], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 8 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][355], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file cites it
  at line 21 (header), line 24 (header), line 43 (body comment) and line 47 (body comment); selected by [ADR-FLOW-CD][2]: the file cites it
  at line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][356], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Languages (9 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/Get-FileLanguage.ps1][357], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/configs/glossary.yml][358], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 10 (text).
- [automation/Catzc.Base.Languages/configs/languages.yml][359], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1][360], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 47 (body comment), line 124 (text), line 136 (text) and line 178 (text).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][361], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][362], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][363], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][364], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the
  file cites it at line 2 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][365], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][4]: the file
  cites it at line 15 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][366], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][367], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][368], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][369], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][370], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][371], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][372], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][1], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][373], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### QualityGates (6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][374], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/glossary.yml][375], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 62 (text).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][376], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1][377], in the cell automation × powershell: selected by
  [ADR-DSGN-TRACK][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][378], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][379], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 9 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain
  of that code.
- [docs/adr/flow/dora-explains.md][380], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][3], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][381], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-runner-pattern.md][382], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that
  code.
- [docs/adr/flow/pipeline-types.md][383], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code; selected by [ADR-FLOW-CD-GLOBS][3]: an ADR file of the `flow` ADR domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][384], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][385], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][386], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][387], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][388], in the cell pipelines × pipeline-yaml: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 6
  (header); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4 (header).
- [pipelines/ci-infrastructure.yaml][389], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][390], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][391], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][392], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][393], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][394], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 8 (header).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Track.ps1][395], in the cell automation × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 5 (header), line 7 (header), line 8 (header) and line 12 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][396], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file cites
  it at line 45 (body comment), line 48 (body comment) and line 50 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][397], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 1 (header), line 3 (header) and line 17 (body comment).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][398], in the cell automation × csharp: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 22 (header), line 25 (header), line 27 (header) and line 270 (text).

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][399], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/drawio/STYLE.md][400], in the cell .claude × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 181 (text),
  line 182 (text), line 188 (text), line 196 (text), line 198 (text), line 199 (text) and line 210 (text); selected by [ADR-FLOW-CD][2]: the
  file cites it at line 28 (text).
- [.claude/drawio/minimaps/highlights.ps1][401], in the cell .claude × powershell: selected by [ADR-DSGN-TRACK][1]: the file cites it at
  line 52 (body comment) (a passing mention only).

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][402], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][4]: the file cites it at line 8 (header) and line 89 (body comment).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][403], in the cell automation × yaml: selected by [ADR-DSGN-TRACK][1]: the file
  cites it at line 9 (text), line 65 (text), line 84 (text), line 95 (text), line 110 (text), line 123 (text), line 137 (text), line 152
  (text), line 165 (text), line 177 (text), line 190 (text), line 192 (text) and line 204 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 21 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][404], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 91 (text), line 107
  (text), line 121 (text), line 137 (text), line 166 (text), line 176 (text), line 178 (text), line 192 (text), line 211 (text), line 225
  (text), line 239 (text), line 252 (text), line 265 (text) and line 277 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 292
  (text) and line 305 (text); selected by [ADR-REPO-FOLDERS][4]: the file cites it at line 752 (text).
- [docs/adr/index.md][405], in the cell docs × markdown: selected by [ADR-DSGN-TRACK][1]: the file cites it at line 88 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text); selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 111 (text); selected
  by [ADR-REPO-FOLDERS][4]: the file cites it at line 286 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][406], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][3]: the file cites it at line 4
  (body comment) (a passing mention only).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][407], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][3]:
  the file cites it at line 6 (header).

## Keywords

- [world map][408]
- [track][409]
- [file language][410]
- [cell][411]
- [lit cell][412]
- [.claude][396]: a track
- [.github][396]: a track
- [automation][396]: a track
- [docs][396]: a track
- [pipelines][396]: a track
- [csharp][359]: a file language
- [markdown][359]: a file language
- [pipeline-yaml][359]: a file language
- [powershell][359]: a file language
- [yaml][359]: a file language

Terms the cited ADRs define:

- [cell][411], defined by [ADR-DSGN-TRACK#10][413]
- [deployable-unit][414], defined by [ADR-DSGN-TRACK#5][415]
- [domain][416], defined by [ADR-REPO-FOLDERS#5][417]
- [file language][410], defined by [ADR-DSGN-TRACK#6][418]
- [gate][419], defined by [ADR-FLOW-CD#13][420]
- [lit cell][412], defined by [ADR-DSGN-TRACK#12][421]
- [release candidate][422], defined by [ADR-FLOW-CD#14][423]
- [root file][424], defined by [ADR-DSGN-TRACK#7][425]
- [stack violation][426], defined by [ADR-DSGN-TRACK#11][427]
- [track][409], defined by [ADR-DSGN-TRACK#1][428]
- [unlisted file][429], defined by [ADR-DSGN-TRACK#8][430]
- [value-chain concern][431], defined by [ADR-DSGN-TRACK#15][432]
- [value-chain map][433], defined by [ADR-DSGN-TRACK#16][434]
- [value-chain stack][435], defined by [ADR-DSGN-TRACK#14][436]
- [verification track][437], defined by [ADR-DSGN-TRACK#2][438]
- [world map][408], defined by [ADR-DSGN-TRACK#9][439]

[1]: ../../adr/design/tracks.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: ../../adr/flow/durable-sha-globs.md
[4]: ../../adr/repository/conventional-folders.md
[5]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[6]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[7]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[8]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[9]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[10]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[11]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[12]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[13]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[14]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[15]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[16]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[17]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[18]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[19]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[20]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[21]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[22]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[23]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[24]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[25]: adr-auto-depm--a-declared-allow-list-of-layers--meta.chain.md
[26]: adr-auto-depm--a-declared-allow-list-of-layers--meta.grid.md
[27]: adr-auto-depm--three-layers-edges-point-down--architecture.chain.md
[28]: adr-auto-depm--three-layers-edges-point-down--architecture.grid.md
[29]: adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md
[30]: adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md
[31]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.chain.md
[32]: adr-auto-depm--two-sections-unioned-into-one-allow-set--implementation.grid.md
[33]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.chain.md
[34]: adr-auto-depm--undeclared-edge-fails-with-one-line--operations.grid.md
[35]: adr-az-naming--how-each-naming-rule-is-held--governance.chain.md
[36]: adr-az-naming--how-each-naming-rule-is-held--governance.grid.md
[37]: adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md
[38]: adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md
[39]: adr-az-naming--names-are-derived-never-typed--operations.chain.md
[40]: adr-az-naming--names-are-derived-never-typed--operations.grid.md
[41]: adr-az-naming--names-are-pure-and-never-truncated--meta.chain.md
[42]: adr-az-naming--names-are-pure-and-never-truncated--meta.grid.md
[43]: adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
[44]: adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
[45]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.chain.md
[46]: adr-conf-loading--ask-by-name-get-the-cached-object--operations.grid.md
[47]: adr-conf-loading--callers-depend-on-one-config-module--architecture.chain.md
[48]: adr-conf-loading--callers-depend-on-one-config-module--architecture.grid.md
[49]: adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
[50]: adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
[51]: adr-conf-loading--one-reader-one-cache-per-session--meta.chain.md
[52]: adr-conf-loading--one-reader-one-cache-per-session--meta.grid.md
[53]: adr-conf-loading--three-caches-back-one-reader--implementation.chain.md
[54]: adr-conf-loading--three-caches-back-one-reader--implementation.grid.md
[55]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
[56]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
[57]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
[58]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
[59]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
[60]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
[61]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
[62]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
[63]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[64]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[65]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[66]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[67]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[68]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[69]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[70]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[71]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[72]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[73]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[74]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[75]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[76]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[77]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[78]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[79]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[80]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[81]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[82]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[83]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[84]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[85]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[86]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[87]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[88]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[89]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[90]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[91]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[92]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[93]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[94]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[95]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[96]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[97]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[98]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[99]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[100]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[101]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[102]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[103]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[104]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[105]: adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
[106]: adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
[107]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[108]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[109]: adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md
[110]: adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md
[111]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
[112]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
[113]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[114]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[115]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[116]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[117]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[118]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[119]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[120]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[121]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[122]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[123]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[124]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[125]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[126]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[127]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[128]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[129]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[130]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[131]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[132]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[133]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md
[134]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
[135]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md
[136]: adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md
[137]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md
[138]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
[139]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md
[140]: adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md
[141]: adr-dsgn-track--one-unit-one-pipeline--meta.chain.md
[142]: adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
[143]: adr-dsgn-track--one-unit-one-pipeline--meta.grid.md
[144]: adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
[145]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[146]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[147]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[148]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[149]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md
[150]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
[151]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md
[152]: adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md
[153]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[154]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[155]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[156]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
[157]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[158]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[159]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[160]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
[161]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[162]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[163]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[164]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md
[165]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[166]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[167]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[168]: adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md
[169]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[170]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[171]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[172]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
[173]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[174]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[175]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[176]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
[177]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[178]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[179]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[180]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
[181]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[182]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[183]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[184]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[185]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[186]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[187]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[188]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
[189]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[190]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[191]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[192]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
[193]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[194]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[195]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[196]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md
[197]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[198]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[199]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[200]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[201]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[202]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[203]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[204]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md
[205]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[206]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[207]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[208]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
[209]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[210]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[211]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[212]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
[213]: adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
[214]: adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
[215]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
[216]: adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
[217]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md
[218]: adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md
[219]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
[220]: adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
[221]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md
[222]: adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md
[223]: adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
[224]: adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
[225]: adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
[226]: adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
[227]: adr-pipe-auth--three-guarded-early-returns--implementation.chain.md
[228]: adr-pipe-auth--three-guarded-early-returns--implementation.grid.md
[229]: adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
[230]: adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
[231]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
[232]: adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
[233]: ../../explanation/design/a-push-fires-only-touched-pipelines.md
[234]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[235]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[236]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[237]: ../../explanation/design/four-domains-promote-one-artifact.md
[238]: ../../explanation/design/globs-yml-pipeline-field-is-the-binding.md
[239]: ../../explanation/design/integrators-depend-on-an-occupant.md
[240]: ../../explanation/design/one-folder-two-independent-readers.md
[241]: ../../explanation/design/one-unit-one-pipeline.md
[242]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[243]: ../../explanation/design/sync-point-rules-are-adr-only.md
[244]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[245]: ../../explanation/design/units-not-tracks-own-the-pipelines.md
[246]: ../../explanation/design/which-rung-gates-exist-in-code.md
[247]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[248]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[249]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[250]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[251]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[252]: ../../explanation/flow/gates-check-source-and-trigger.md
[253]: ../../explanation/flow/globs-module-owns-config-and-types.md
[254]: ../../explanation/flow/independence-check-groups-by-layer.md
[255]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[256]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[257]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[258]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[259]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[260]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[261]: ../../explanation/flow/two-declared-layers-one-derived.md
[262]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[263]: ../../how-to/automation/manual-test-plan/repository-conventions.md
[264]: ../../references/automation/catzc-base-globs.md
[265]: ../../references/automation/catzc-base-languages.md
[266]: ../../references/automation/catzc-base-maps.md
[267]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[268]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[269]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[270]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[271]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[272]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[273]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[274]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[275]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[276]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[277]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[278]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[279]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[280]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[281]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[282]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[283]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[284]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[285]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[286]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[287]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[288]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[289]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[290]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[291]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[292]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[293]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[294]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[295]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[296]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[297]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[298]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[299]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[300]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[301]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[302]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[303]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[304]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[305]: ../../../automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1
[306]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[307]: ../../../automation/Catzc.Base.Maps/Get-ValueChainMap.ps1
[308]: ../../../automation/Catzc.Base.Maps/Get-WorldMap.ps1
[309]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[310]: ../../../automation/Catzc.Base.Maps/Test-ValueChainMap.ps1
[311]: ../../../automation/Catzc.Base.Maps/Test-WorldMap.ps1
[312]: ../../../automation/Catzc.Base.Maps/configs/maps.yml
[313]: ../../../automation/Catzc.Base.Maps/private/Resolve-MapLabelTerm.ps1
[314]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
[315]: ../../../automation/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
[316]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMap.Tests.ps1
[317]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[318]: ../../../automation/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
[319]: ../../../automation/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
[320]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
[321]: ../../../automation/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
[322]: ../../../automation/Catzc.Base.Maps/tests/types/WorldMapHighlight.Tests.ps1
[323]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[324]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[325]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[326]: ../../../automation/Catzc.Base.Maps/types/ValueChainHighlight.cs
[327]: ../../../automation/Catzc.Base.Maps/types/ValueChainMap.cs
[328]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[329]: ../../../automation/Catzc.Base.Maps/types/WorldMap.cs
[330]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[331]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[332]: ../../../automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
[333]: ../../../automation/Catzc.Base.Maps/types/WorldMapPdf.cs
[334]: ../../adr/repository/agent-definitions.md
[335]: ../../adr/repository/api-contracts.md
[336]: ../../adr/repository/controlled-vocabulary.md
[337]: ../../adr/repository/dedicated-output-directory.md
[338]: ../../adr/repository/documentation-examples.md
[339]: ../../adr/repository/domain-language-separation.md
[340]: ../../adr/repository/dora-explains.md
[341]: ../../adr/repository/generated-readmes.md
[342]: ../../adr/repository/generated-root-configs.md
[343]: ../../adr/repository/inspiration.md
[344]: ../../adr/repository/markdown-links.md
[345]: ../../adr/repository/output-formats.md
[346]: ../../adr/repository/repo-variants.md
[347]: ../../adr/repository/uniform-formatting.md
[348]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[349]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[350]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[351]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[352]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[353]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[354]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[355]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[356]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[357]: ../../../automation/Catzc.Base.Languages/Get-FileLanguage.ps1
[358]: ../../../automation/Catzc.Base.Languages/configs/glossary.yml
[359]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[360]: ../../../automation/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
[361]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[362]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[363]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[364]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[365]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[366]: ../../adr/design/commit-lifecycle.md
[367]: ../../adr/design/dora-explains.md
[368]: ../../adr/design/module-aspects.md
[369]: ../../adr/design/run-modes.md
[370]: ../../adr/design/self-service.md
[371]: ../../adr/design/server-remote-integration.md
[372]: ../../adr/design/thin-platforms.md
[373]: ../../adr/design/visual-design.md
[374]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[375]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[376]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[377]: ../../../automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
[378]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[379]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[380]: ../../adr/flow/dora-explains.md
[381]: ../../adr/flow/pipeline-detection.md
[382]: ../../adr/flow/pipeline-runner-pattern.md
[383]: ../../adr/flow/pipeline-types.md
[384]: ../../../pipelines/cd-apex.yaml
[385]: ../../../pipelines/cd-flux.yaml
[386]: ../../../pipelines/cd-nova.yaml
[387]: ../../../pipelines/cd-shared.yaml
[388]: ../../../pipelines/ci-automation.yaml
[389]: ../../../pipelines/ci-infrastructure.yaml
[390]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[391]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[392]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[393]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[394]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[395]: ../../../automation/Catzc.Base.Variants/Get-Track.ps1
[396]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[397]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[398]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[399]: ../../../.claude/CLAUDE.md
[400]: ../../../.claude/drawio/STYLE.md
[401]: ../../../.claude/drawio/minimaps/highlights.ps1
[402]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[403]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[404]: ../../adr/glossary.md
[405]: ../../adr/index.md
[406]: ../../../.github/workflows/ci-automation.yml
[407]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[408]: ../../adr/glossary.md#world-map
[409]: ../../adr/glossary.md#track
[410]: ../../adr/glossary.md#file-language
[411]: ../../adr/glossary.md#cell
[412]: ../../adr/glossary.md#lit-cell
[413]: ../../adr/design/tracks.md#rule-adr-dsgn-track10
[414]: ../../adr/glossary.md#deployable-unit
[415]: ../../adr/design/tracks.md#rule-adr-dsgn-track5
[416]: ../../adr/glossary.md#domain
[417]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
[418]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[419]: ../../adr/glossary.md#gate
[420]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[421]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[422]: ../../adr/glossary.md#release-candidate
[423]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
[424]: ../../adr/glossary.md#root-file
[425]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[426]: ../../adr/glossary.md#stack-violation
[427]: ../../adr/design/tracks.md#rule-adr-dsgn-track11
[428]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[429]: ../../adr/glossary.md#unlisted-file
[430]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[431]: ../../adr/glossary.md#value-chain-concern
[432]: ../../adr/design/tracks.md#rule-adr-dsgn-track15
[433]: ../../adr/glossary.md#value-chain-map
[434]: ../../adr/design/tracks.md#rule-adr-dsgn-track16
[435]: ../../adr/glossary.md#value-chain-stack
[436]: ../../adr/design/tracks.md#rule-adr-dsgn-track14
[437]: ../../adr/glossary.md#verification-track
[438]: ../../adr/design/tracks.md#rule-adr-dsgn-track2
[439]: ../../adr/design/tracks.md#rule-adr-dsgn-track9
