# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md

`Tree minimap: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance`

![Tree minimap of adr-dsgn-remote--ingress-gated-the-rest-by-review--governance](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.png)

The tree minimap of the slide `adr-dsgn-remote--ingress-gated-the-rest-by-review--governance` (governance lens). The slide supports
[ADR-DSGN-LIFE][1], [ADR-DSGN-REMOTE][2] and [ADR-REPO-VARIANT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 122 files in 8 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 90 lit files
- adr/repo (docs/adr/repository): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 2 lit files
- Variants (automation/Catzc.Base.Variants): 2 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file

## Why each group is lit

### docs (90 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line
  42 (text), line 42 (text) and line 56 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line
  44 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line
  37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 118 (text), line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][8], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38
  (text), line 49 (text), line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][9], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][10], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48
  (text), line 51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text),
  line 66 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84
  (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text),
  line 101 (text), line 103 (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text),
  line 119 (text), line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md][11], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37
  (text), line 39 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text),
  line 57 (text), line 60 (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text),
  line 100 (text), line 108 (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text),
  line 128 (text), line 130 (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text),
  line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68
  (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102
  (text), line 104 (text), line 107 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md][15], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59
  (text), line 61 (text), line 64 (text), line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text),
  line 80 (text), line 82 (text), line 85 (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107
  (text), line 110 (text), line 113 (text), line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129
  (text), line 139 (text), line 148 (text), line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][18], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][19], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][20], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line
  49 (text), line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][21], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][22], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line
  51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md][23], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line
  39 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text),
  line 60 (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79
  (text), line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text),
  line 108 (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text),
  line 130 (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][24], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][25], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][26], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][27], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][28], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][29], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][30], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][31], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][32], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][33], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][34], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md][35], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][36], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text),
  line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][37], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][38], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68
  (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102
  (text), line 104 (text), line 107 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md][39], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59
  (text), line 61 (text), line 64 (text), line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text),
  line 80 (text), line 82 (text), line 85 (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107
  (text), line 110 (text), line 113 (text), line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129
  (text), line 139 (text), line 148 (text), line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][40], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][41], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][42], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md][43], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][44], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text),
  line 42 (text) and line 56 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][45], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][46], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md][47], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95
  (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 118 (text), line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][48], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text),
  line 58 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][49], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 65 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][50], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text),
  line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115
  (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155
  (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][51], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61
  (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line
  126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][52], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 51 (text), line 65 (text),
  line 65 (text) and line 97 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][53], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][54], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 39 (text), line 687 (text), line 699 (text), line 723 (text), line 726
  (text), line 727 (text), line 730 (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739 (text), line 741
  (text), line 744 (text), line 746 (text), line 749 (text), line 752 (text), line 754 (text), line 849 (text), line 851 (text), line 853
  (text), line 855 (text), line 857 (text), line 859 (text), line 861 (text), line 863 (text), line 865 (text), line 879 (text), line 881
  (text), line 890 (text), line 892 (text), line 894 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text), line 907
  (text), line 909 (text), line 912 (text), line 914 (text), line 918 (text), line 921 (text), line 923 (text), line 928 (text) and line
  1013 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][55], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 336 (text), line 338 (text), line 341 (text), line 343 (text), line 345
  (text), line 348 (text), line 350 (text), line 352 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 365
  (text), line 369 (text), line 371 (text), line 394 (text), line 396 (text), line 398 (text), line 401 (text), line 404 (text), line 406
  (text), line 408 (text), line 411 (text), line 413 (text), line 416 (text), line 418 (text), line 422 (text), line 425 (text), line 427
  (text), line 433 (text), line 567 (text), line 729 (text), line 925 (text), line 928 (text), line 931 (text), line 934 (text), line 936
  (text), line 939 (text), line 942 (text), line 945 (text), line 947 (text), line 1024 (text), line 1210 (text), line 1213 (text) and line
  1297 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][56], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 55 (text),
  line 55 (text) and line 69 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text),
  line 39 (text) and line 39 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 70
  (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][58], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 36 (text), line 43 (text), line 46 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63
  (text), line 65 (text), line 67 (text), line 69 (text), line 73 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 103
  (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 117 (text), line 120 (text), line 124
  (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 137 (text) and line 155 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 35 (text), line 70 (text), line 71 (text), line 74 (text), line 76 (text),
  line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94
  (text), line 96 (text), line 98 (text), line 101 (text), line 115 (text), line 118 (text), line 122 (text) and line 126 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md][59], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56
  (text), line 61 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text),
  line 84 (text), line 87 (text), line 91 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 104 (text), line 112
  (text), line 115 (text), line 118 (text), line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line 134
  (text), line 142 (text), line 143 (text), line 150 (text), line 157 (text), line 164 (text) and line 182 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 56 (text), line 59 (text), line 61 (text), line 64 (text), line 66 (text),
  line 68 (text), line 82 (text), line 85 (text), line 89 (text), line 93 (text), line 113 (text), line 116 (text), line 119 (text), line
  122 (text), line 124 (text), line 127 (text), line 130 (text), line 133 (text), line 135 (text), line 144 (text) and line 158 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md][60], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md][61], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md][62], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 39
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md][63], in the cell docs × markdown: selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35
  (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][64], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text), line
  56 (text), line 56 (text) and line 78 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 29 (text), line
  29 (text), line 40 (text) and line 40 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 8 (text), line 64 (text) and
  line 64 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][65], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 73 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 73
  (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][66], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 29 (text), line 51 (text), line 53 (text), line 61 (text), line
  64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 91 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 117 (text), line 149
  (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 166 (text), line 170
  (text), line 174 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 187 (text) and line 207 (text); selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 52 (text), line 88 (text), line 89 (text), line 92 (text), line 95
  (text), line 96 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 113 (text), line 115 (text), line 117 (text), line 150 (text), line 164 (text), line 167 (text), line 172 (text) and line 176
  (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 8 (text), line 36 (text), line 43 (text), line 52 (text), line 54
  (text), line 93 (text), line 118 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145
  (text), line 147 (text), line 165 (text), line 168 (text) and line 173 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md][67], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line
  40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 63 (text), line 69 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 87 (text), line 91 (text), line 96 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 109
  (text), line 152 (text), line 155 (text), line 158 (text), line 161 (text), line 163 (text), line 166 (text), line 169 (text), line 172
  (text), line 174 (text), line 184 (text), line 200 (text), line 201 (text), line 208 (text), line 215 (text) and line 236 (text); selected
  by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 58 (text), line 61 (text), line 63 (text), line 66 (text), line 68
  (text), line 70 (text), line 84 (text), line 88 (text), line 93 (text), line 98 (text), line 153 (text), line 156 (text), line 159 (text),
  line 162 (text), line 164 (text), line 167 (text), line 170 (text), line 173 (text), line 175 (text), line 202 (text) and line 216 (text);
  selected by [ADR-REPO-VARIANT][3]: the file cites it at line 8 (text), line 64 (text), line 85 (text), line 89 (text), line 94 (text),
  line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text),
  line 133 (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 182 (text),
  line 191 (text), line 193 (text), line 202 (text) and line 216 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md][68], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md][69], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md][70], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line
  39 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md][71], in the cell docs × markdown:
  selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line
  35 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md][72], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md][73], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md][74], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 25 (text), line 32 (text), line 34 (text), line 36 (text), line 39 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 56 (text), line 58 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text) and line 67 (text).
- [docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md][75], in the cell docs × markdown: selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text),
  line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text), line 51 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 74 (text) and line 81 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][76], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 15 (text), line 45
  (text), line 46 (text) and line 48 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][77], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][78], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][79], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][80], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][81], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][82], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/guard-and-policies-by-command.md][83], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 16 (text), line 48 (text) and line 51 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 16 (text) and
  line 50 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][84], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 16 (text), line
  19 (text), line 22 (text), line 49 (text), line 50 (text), line 50 (text) and line 52 (text); selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 16 (text), line 22 (text) and line 54 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][85], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text).
- [docs/explanation/design/local-guard-and-server-policies.md][86], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 19 (text), line 55 (text) and line 58 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 19 (text) and
  line 57 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][87], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-door-in-one-stable-point-out.md][88], in the cell docs × markdown: selected by [ADR-DSGN-REMOTE][2]: the file
  cites it at line 14 (text), line 43 (text), line 44 (text), line 45 (text) and line 47 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][89], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][90], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][91], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][92], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][93], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][94], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][95], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][96], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][97], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][98], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][99], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][100], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][101], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][102], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][103], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][104], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][105], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][106], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][3], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][107], in the cell docs × markdown: selected by [ADR-REPO-VARIANT][3]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/dora-explains.md][108], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/module-aspects.md][109], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/run-modes.md][110], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][111], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][2], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain
  of that code.
- [docs/adr/design/thin-platforms.md][112], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][113], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][114], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code; selected by [ADR-DSGN-REMOTE][2]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.

### ModuleSystem (2 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][115], in the cell automation × powershell: selected by [ADR-REPO-VARIANT][3]:
  the file cites it at line 29 (header) and line 100 (text).
- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][116], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text).

### Variants (2 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/configs/variants.yml][117], in the cell automation × yaml: selected by [ADR-REPO-VARIANT][3]: the file
  cites it at line 1 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][118], in the cell automation × csharp: selected by [ADR-REPO-VARIANT][3]: the
  file cites it at line 1 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][119], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text).
- [docs/adr/index.md][120], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-DSGN-REMOTE][2]: the file cites it at line 93 (text); selected by [ADR-REPO-VARIANT][3]: the file cites it at line 294 (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/agents/write-drawio-files.md][121], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][122], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-DSGN-REMOTE][2]: the file cites it at line 100 (text); selected by [ADR-REPO-VARIANT][3]: the file cites
  it at line 315 (text).

## Keywords

- [world map][123]
- [track][124]
- [file language][125]
- [cell][126]
- [lit cell][127]
- [.claude][117]: a track
- [automation][117]: a track
- [docs][117]: a track
- [csharp][128]: a file language
- [markdown][128]: a file language
- [powershell][128]: a file language
- [yaml][128]: a file language

Terms the cited ADRs define:

- [occupant][129], defined by [ADR-DSGN-LIFE#5][130]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/design/server-remote-integration.md
[3]: ../../adr/repository/repo-variants.md
[4]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[5]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[6]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[7]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md
[8]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[9]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[10]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[11]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
[12]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[13]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[14]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[15]: adr-dsgn-life--deploying-is-not-integrating--meta.tree.md
[16]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[17]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[18]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[19]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[20]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[21]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[22]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[23]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md
[24]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[25]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[26]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[27]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[28]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[29]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[30]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[31]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[32]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[33]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[34]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[35]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md
[36]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[37]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[38]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[39]: adr-dsgn-life--one-way-climb-three-endings--meta.tree.md
[40]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[41]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[42]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[43]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md
[44]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[45]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[46]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[47]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md
[48]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[49]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[50]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[51]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[52]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[53]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[54]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[55]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[56]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[57]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[58]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[59]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md
[60]: adr-dsgn-remote--guard-and-policies-by-command--operations.chain.md
[61]: adr-dsgn-remote--guard-and-policies-by-command--operations.drawio.md
[62]: adr-dsgn-remote--guard-and-policies-by-command--operations.grid.md
[63]: adr-dsgn-remote--guard-and-policies-by-command--operations.tree.md
[64]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[65]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[66]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[67]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
[68]: adr-dsgn-remote--local-guard-and-server-policies--implementation.chain.md
[69]: adr-dsgn-remote--local-guard-and-server-policies--implementation.drawio.md
[70]: adr-dsgn-remote--local-guard-and-server-policies--implementation.grid.md
[71]: adr-dsgn-remote--local-guard-and-server-policies--implementation.tree.md
[72]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
[73]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
[74]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
[75]: adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md
[76]: ../../explanation/design/clients-bridge-to-one-server.md
[77]: ../../explanation/design/code-wires-only-the-first-rungs.md
[78]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[79]: ../../explanation/design/deploying-is-not-integrating.md
[80]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[81]: ../../explanation/design/every-deploy-stage-is-main-only.md
[82]: ../../explanation/design/four-domains-promote-one-artifact.md
[83]: ../../explanation/design/guard-and-policies-by-command.md
[84]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[85]: ../../explanation/design/integrators-depend-on-an-occupant.md
[86]: ../../explanation/design/local-guard-and-server-policies.md
[87]: ../../explanation/design/merging-to-main-is-what-deploys.md
[88]: ../../explanation/design/one-door-in-one-stable-point-out.md
[89]: ../../explanation/design/one-way-climb-three-endings.md
[90]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[91]: ../../explanation/design/sync-from-the-last-certified-commit.md
[92]: ../../explanation/design/sync-point-rules-are-adr-only.md
[93]: ../../explanation/design/which-rung-gates-exist-in-code.md
[94]: ../../adr/repository/agent-definitions.md
[95]: ../../adr/repository/api-contracts.md
[96]: ../../adr/repository/controlled-vocabulary.md
[97]: ../../adr/repository/conventional-folders.md
[98]: ../../adr/repository/dedicated-output-directory.md
[99]: ../../adr/repository/documentation-examples.md
[100]: ../../adr/repository/domain-language-separation.md
[101]: ../../adr/repository/dora-explains.md
[102]: ../../adr/repository/generated-readmes.md
[103]: ../../adr/repository/generated-root-configs.md
[104]: ../../adr/repository/inspiration.md
[105]: ../../adr/repository/markdown-links.md
[106]: ../../adr/repository/output-formats.md
[107]: ../../adr/repository/uniform-formatting.md
[108]: ../../adr/design/dora-explains.md
[109]: ../../adr/design/module-aspects.md
[110]: ../../adr/design/run-modes.md
[111]: ../../adr/design/self-service.md
[112]: ../../adr/design/thin-platforms.md
[113]: ../../adr/design/tracks.md
[114]: ../../adr/design/visual-design.md
[115]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[116]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[117]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[118]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[119]: ../../adr/glossary.md
[120]: ../../adr/index.md
[121]: ../../../.claude/agents/write-drawio-files.md
[122]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[123]: ../../adr/glossary.md#world-map
[124]: ../../adr/glossary.md#track
[125]: ../../adr/glossary.md#file-language
[126]: ../../adr/glossary.md#cell
[127]: ../../adr/glossary.md#lit-cell
[128]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[129]: ../../adr/glossary.md#occupant
[130]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
