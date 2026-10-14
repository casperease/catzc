# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md

`Tree minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Tree minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 114 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/auto (docs/adr/automation): 39 lit files
- docs (docs/ outside docs/adr/): 26 lit files
- adr/azure (docs/adr/azure): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- Root files: 2 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Repository (automation/Catzc.Base.Repository): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][4], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][5], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][6], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][7], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][8], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][9], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][10], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][11], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][12], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][1], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][13], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][14], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][15], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][16], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][17], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][18], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][19], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][20], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][21], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][22], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][23], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][24], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][25], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][26], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][27], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][28], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][29], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][30], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][31], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][32], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][33], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][34], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][35], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][36], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][37], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][38], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][39], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][40], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][41], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### docs (26 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][42], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][43], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][44], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38
  (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md][45], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36
  (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][46], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][47], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][48], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md][49], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][50], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][51], in the cell docs ×
  markdown: selected by [ADR-AZ-CLI][2]: the file cites it at line 68 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line
  68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][52], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 33 (text), line 34 (text), line 35 (text), line 42 (text), line 44 (text), line 45 (text), line 58 (text), line 61 (text),
  line 63 (text), line 65 (text), line 67 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 75 (text), line 76
  (text), line 78 (text), line 80 (text), line 81 (text), line 82 (text), line 83 (text), line 84 (text), line 86 (text), line 88 (text),
  line 90 (text), line 91 (text), line 109 (text), line 113 (text), line 115 (text) and line 120 (text); selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 8 (text), line 43 (text), line 46 (text), line 53 (text), line 56 (text), line 58 (text), line 60 (text), line
  62 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 107 (text), line 109 (text), line 111 (text), line 114 (text), line 116 (text), line 118 (text) and line 122 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md][53], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 78 (text), line 83 (text), line 86
  (text), line 89 (text), line 94 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 147 (text), line 149 (text), line 156 (text) and line 163 (text); selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 74 (text), line 76 (text), line 78 (text), line 81 (text), line 83
  (text), line 84 (text), line 87 (text), line 90 (text), line 92 (text), line 96 (text), line 103 (text), line 105 (text), line 107 (text),
  line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 150 (text), line 157 (text) and
  line 164 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][54], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][55], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][58], in the cell docs × markdown: selected
  by [ADR-AUTO-PARITY][1]: the file cites it at line 8 (text), line 45 (text) and line 45 (text); selected by [ADR-AZ-CLI][2]: the file
  cites it at line 8 (text), line 53 (text), line 53 (text), line 61 (text) and line 61 (text); selected by [ADR-DSGN-THINPLAT][3]: the file
  cites it at line 8 (text), line 29 (text), line 29 (text), line 37 (text) and line 37 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][59], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][2]: the file cites it at line 74 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][60], in the cell docs × markdown: selected
  by [ADR-AUTO-PARITY][1]: the file cites it at line 8 (text), line 37 (text), line 44 (text), line 65 (text), line 67 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119
  (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135
  (text), line 137 (text), line 139 (text), line 141 (text), line 189 (text), line 195 (text), line 200 (text), line 212 (text) and line 214
  (text); selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 36 (text), line 45 (text), line 46 (text), line 47 (text), line 60 (text), line 63
  (text), line 143 (text), line 145 (text), line 147 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 155
  (text), line 156 (text), line 158 (text), line 160 (text), line 161 (text), line 162 (text), line 163 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 171 (text), line 189 (text), line 193 (text), line 197 (text) and line 202 (text); selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 45 (text), line 48 (text), line 55 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 186 (text), line 187 (text), line 190 (text), line 191 (text), line 194 (text), line 198 (text), line 201
  (text) and line 204 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md][61], in the cell docs × markdown: selected
  by [ADR-AUTO-PARITY][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75
  (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line
  109 (text), line 175 (text), line 180 (text), line 235 (text), line 237 (text), line 253 (text), line 261 (text) and line 268 (text);
  selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line
  124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line
  140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 164 (text), line
  169 (text), line 172 (text), line 177 (text), line 182 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line
  222 (text), line 224 (text), line 226 (text), line 228 (text), line 244 (text), line 246 (text), line 254 (text) and line 269 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 160 (text), line 162 (text), line 164 (text), line 167
  (text), line 169 (text), line 170 (text), line 173 (text), line 178 (text), line 181 (text), line 184 (text), line 191 (text), line 193
  (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 247
  (text), line 254 (text) and line 269 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][62], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][63], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 63 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 19 (text), line 58 (text), line 59 (text) and line 65
  (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][64], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 54 (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][65], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 53 (text) and line 57 (text); selected by [ADR-DSGN-THINPLAT][3]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][66], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the file
  cites it at line 57 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][67], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 17 (text), line 34 (text), line 60 (text), line 60 (text), line 61 (text), line 65 (text), line 67 (text) and line 71 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/azure (25 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][68], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][69], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][70], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][71], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][72], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/billing-and-tenant.md][73], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][74], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][75], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][76], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/landing-zone-security.md][77], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][78], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][79], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-connectivity.md][80], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-private-access.md][81], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-topology.md][82], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][83], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][84], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][85], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][86], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][2], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][87], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][88], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][89], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][90], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/security.md][91], in the cell docs × markdown: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][92], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][93], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][94], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][95], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][96], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][97], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][3], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][98], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][99], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Az.Cli (8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][100], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][101], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][102], in the cell automation × powershell: selected by
  [ADR-AZ-CLI][2]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][103], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][104], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][105], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][106], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][107], in the cell automation × powershell: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 13 (header).

### Root files (2 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][108], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).
- [.gitignore][109], in the cell Root files × Unlisted files: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][110], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][111], in the cell automation × yaml: selected by [ADR-AZ-CLI][2]: the file
  cites it at line 580 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 664 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][112], in the cell automation × yaml: selected by [ADR-AUTO-PARITY][1]: the file cites it at
  line 137 (text); selected by [ADR-AZ-CLI][2]: the file cites it at line 270 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it
  at line 96 (text).

### Repository (1 lit file)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Get-RunEnvironment.ps1][113], in the cell automation × powershell: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 6 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][114], in the cell docs × markdown: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 125 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 89 (text).

## Keywords

- [world map][115]
- [track][116]
- [file language][117]
- [cell][118]
- [lit cell][119]
- [root file][120]
- [unlisted file][121]
- [automation][122]: a track
- [docs][122]: a track
- [markdown][123]: a file language
- [powershell][123]: a file language
- [yaml][123]: a file language

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../adr/automation/BCL/index.md
[5]: ../../adr/automation/BCL/native-csharp-types.md
[6]: ../../adr/automation/avoid-deep-nesting.md
[7]: ../../adr/automation/bash/bash-test-artifacts.md
[8]: ../../adr/automation/caching.md
[9]: ../../adr/automation/console-output-matters.md
[10]: ../../adr/automation/controlling-module-dependencies.md
[11]: ../../adr/automation/controlling-systemwide-deps.md
[12]: ../../adr/automation/cross-platform.md
[13]: ../../adr/automation/dora-explains.md
[14]: ../../adr/automation/dry-run.md
[15]: ../../adr/automation/effective-in-enterprises.md
[16]: ../../adr/automation/environment-variables.md
[17]: ../../adr/automation/execution-engines.md
[18]: ../../adr/automation/fail-fast-with-asserts.md
[19]: ../../adr/automation/go/index.md
[20]: ../../adr/automation/go/test-artifacts.md
[21]: ../../adr/automation/idempotent-state-functions.md
[22]: ../../adr/automation/internal-asset-dependencies.md
[23]: ../../adr/automation/log-before-invoke.md
[24]: ../../adr/automation/managed-guids.md
[25]: ../../adr/automation/never-depend-on-pwd.md
[26]: ../../adr/automation/open-closed-architecture.md
[27]: ../../adr/automation/path-representation.md
[28]: ../../adr/automation/platform-bundle.md
[29]: ../../adr/automation/protected-globs.md
[30]: ../../adr/automation/python/index.md
[31]: ../../adr/automation/python/python-test-artifacts.md
[32]: ../../adr/automation/retry-as-last-resort.md
[33]: ../../adr/automation/sensible-defaults.md
[34]: ../../adr/automation/single-responsibility-functions.md
[35]: ../../adr/automation/spell-out-names.md
[36]: ../../adr/automation/test-automation.md
[37]: ../../adr/automation/tool-removal-lifecycle.md
[38]: ../../adr/automation/tracked-files-from-the-index.md
[39]: ../../adr/automation/use-proper-package-managers.md
[40]: ../../adr/automation/uv-python-handler.md
[41]: ../../adr/automation/zero-ceremony-poka-yoke.md
[42]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[43]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[44]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[45]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
[46]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[47]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[48]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[49]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
[50]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[51]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[52]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[53]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
[54]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[55]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[56]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[57]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
[58]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[59]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[60]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[61]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
[62]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[63]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[64]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[65]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[66]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[67]: ../../explanation/design/what-keeps-the-platform-thin.md
[68]: ../../adr/azure/az-session-verification.md
[69]: ../../adr/azure/azure-customer-model.md
[70]: ../../adr/azure/azure-data-model.md
[71]: ../../adr/azure/azure-naming-standard.md
[72]: ../../adr/azure/azure-network-model.md
[73]: ../../adr/azure/caf/billing-and-tenant.md
[74]: ../../adr/azure/caf/design-principles.md
[75]: ../../adr/azure/caf/governance.md
[76]: ../../adr/azure/caf/identity-and-access.md
[77]: ../../adr/azure/caf/landing-zone-security.md
[78]: ../../adr/azure/caf/management.md
[79]: ../../adr/azure/caf/naming-and-tagging.md
[80]: ../../adr/azure/caf/network-connectivity.md
[81]: ../../adr/azure/caf/network-private-access.md
[82]: ../../adr/azure/caf/network-topology.md
[83]: ../../adr/azure/caf/platform-automation-and-devops.md
[84]: ../../adr/azure/caf/resource-organization.md
[85]: ../../adr/azure/dora-explains.md
[86]: ../../adr/azure/landing-zones.md
[87]: ../../adr/azure/waf/cost-optimization.md
[88]: ../../adr/azure/waf/operational-excellence.md
[89]: ../../adr/azure/waf/performance-efficiency.md
[90]: ../../adr/azure/waf/reliability.md
[91]: ../../adr/azure/waf/security.md
[92]: ../../adr/design/commit-lifecycle.md
[93]: ../../adr/design/dora-explains.md
[94]: ../../adr/design/module-aspects.md
[95]: ../../adr/design/run-modes.md
[96]: ../../adr/design/self-service.md
[97]: ../../adr/design/server-remote-integration.md
[98]: ../../adr/design/tracks.md
[99]: ../../adr/design/visual-design.md
[100]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[101]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[102]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[103]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[104]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[105]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[106]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[107]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[108]: ../../../.gitattributes
[109]: ../../../.gitignore
[110]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[111]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[112]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[113]: ../../../automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
[114]: ../../adr/index.md
[115]: ../../adr/glossary.md#world-map
[116]: ../../adr/glossary.md#track
[117]: ../../adr/glossary.md#file-language
[118]: ../../adr/glossary.md#cell
[119]: ../../adr/glossary.md#lit-cell
[120]: ../../adr/glossary.md#root-file
[121]: ../../adr/glossary.md#unlisted-file
[122]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[123]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
