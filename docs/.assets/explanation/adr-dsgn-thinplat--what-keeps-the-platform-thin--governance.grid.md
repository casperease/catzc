# docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md

`Grid minimap: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance`

![Grid minimap of adr-dsgn-thinplat--what-keeps-the-platform-thin--governance](adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.png)

The grid minimap of the slide `adr-dsgn-thinplat--what-keeps-the-platform-thin--governance` (governance lens). The slide supports
[ADR-AUTO-PARITY][1], [ADR-AZ-CLI][2] and [ADR-DSGN-THINPLAT][3]; the highlight of those ADR codes selects what is lit, and each reason
below names the code that selects it.

## What the minimap shows

The grid crosses the 12 tracks (rows) with the 18 file languages (columns) of the world map and lights 4 cells, filled in ink. A cell lit
only by passing mentions (citations in body comments, not in a file's header or text) is touched: a lighter ink. Every other cell is idle, a
grey box: it holds files the slide's ADR codes do not select, or no file at all (174 of the 216 cells hold none). The minimap shows where
the slide sits, not how many files a cell holds; the world-map PDFs show the counts.

- automation × powershell: 9 lit of 1400 files
- automation × yaml: 3 lit of 95 files
- docs × markdown: 100 lit of 741 files
- Root files × Unlisted files: 2 lit of 4 files

## Key

A lit row prints its track's name; a lit column prints a short code, the first extension of its file language:

- `.md`: markdown
- `.ps1`: powershell
- `.yml`: yaml
- `other`: Unlisted files

## Why each cell is lit

### automation × powershell (9 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.ps1` names the file language
powershell ([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][7]: selected by [ADR-AZ-CLI][2]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][8]: selected by [ADR-AZ-CLI][2]: the file cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][9]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14
  (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][10]: selected by [ADR-AZ-CLI][2]: the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][11]: selected by [ADR-AZ-CLI][2]: the file cites it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][12]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][13]: selected by [ADR-AZ-CLI][2]: the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][14]: selected by [ADR-AZ-CLI][2]: the file cites it at line 13 (header).
- [automation/Catzc.Base.Repository/Get-RunEnvironment.ps1][15]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 6 (header).

### automation × yaml (3 lit files)

Placed: the root folder `automation/` names the track automation ([ADR-DSGN-TRACK#1][4]); the extension `.yml` names the file language yaml
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][16]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 137 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 270 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 96 (text).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][17]: selected by [ADR-AZ-CLI][2]: the file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][18]: selected by [ADR-AZ-CLI][2]: the file cites it at line 580 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 664 (text).

### docs × markdown (100 lit files)

Placed: the root folder `docs/` names the track docs ([ADR-DSGN-TRACK#1][4]); the extension `.md` names the file language markdown
([ADR-DSGN-TRACK#6][5]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][19]: selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][20]: selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][21]: selected by [ADR-DSGN-THINPLAT][3]: the
  file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38 (text), line 40 (text), line 41
  (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md][22]: selected by [ADR-DSGN-THINPLAT][3]: the
  file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][23]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][24]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][25]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38
  (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md][26]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36
  (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][27]: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][28]: selected by
  [ADR-AZ-CLI][2]: the file cites it at line 68 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][29]: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 31 (text), line 32 (text), line 33 (text), line
  34 (text), line 35 (text), line 42 (text), line 44 (text), line 45 (text), line 58 (text), line 61 (text), line 63 (text), line 65 (text),
  line 67 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 82 (text), line 83 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 91 (text),
  line 109 (text), line 113 (text), line 115 (text) and line 120 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8
  (text), line 43 (text), line 46 (text), line 53 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 92 (text),
  line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line
  109 (text), line 111 (text), line 114 (text), line 116 (text), line 118 (text) and line 122 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md][30]: selected by [ADR-AZ-CLI][2]:
  the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line
  42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text),
  line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 78 (text), line 83 (text), line 86 (text), line 89 (text), line 94
  (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140
  (text), line 147 (text), line 149 (text), line 156 (text) and line 163 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at
  line 8 (text), line 74 (text), line 76 (text), line 78 (text), line 81 (text), line 83 (text), line 84 (text), line 87 (text), line 90
  (text), line 92 (text), line 96 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113
  (text), line 115 (text), line 117 (text), line 119 (text), line 150 (text), line 157 (text) and line 164 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][31]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][32]: selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][33]: selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38 (text), line 40 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text),
  line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md][34]: selected by [ADR-DSGN-THINPLAT][3]:
  the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][35]: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 8 (text), line 45 (text) and line 45 (text); selected by [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line
  53 (text), line 53 (text), line 61 (text) and line 61 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line
  29 (text), line 29 (text), line 37 (text) and line 37 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][36]: selected by [ADR-AZ-CLI][2]: the
  file cites it at line 74 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][37]: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 8 (text), line 37 (text), line 44 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line
  123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line
  139 (text), line 141 (text), line 189 (text), line 195 (text), line 200 (text), line 212 (text) and line 214 (text); selected by
  [ADR-AZ-CLI][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text), line
  34 (text), line 35 (text), line 36 (text), line 45 (text), line 46 (text), line 47 (text), line 60 (text), line 63 (text), line 143
  (text), line 145 (text), line 147 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 155 (text), line 156
  (text), line 158 (text), line 160 (text), line 161 (text), line 162 (text), line 163 (text), line 164 (text), line 166 (text), line 168
  (text), line 170 (text), line 171 (text), line 189 (text), line 193 (text), line 197 (text) and line 202 (text); selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 8 (text), line 45 (text), line 48 (text), line 55 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 186 (text), line 187 (text), line 190 (text), line 191 (text), line 194 (text), line 198 (text), line 201
  (text) and line 204 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md][38]: selected by [ADR-AUTO-PARITY][1]: the
  file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45
  (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text),
  line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79
  (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text),
  line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 175 (text), line
  180 (text), line 235 (text), line 237 (text), line 253 (text), line 261 (text) and line 268 (text); selected by [ADR-AZ-CLI][2]: the file
  cites it at line 8 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128
  (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 164 (text), line 169 (text), line 172 (text), line 177
  (text), line 182 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 226
  (text), line 228 (text), line 244 (text), line 246 (text), line 254 (text) and line 269 (text); selected by [ADR-DSGN-THINPLAT][3]: the
  file cites it at line 8 (text), line 160 (text), line 162 (text), line 164 (text), line 167 (text), line 169 (text), line 170 (text), line
  173 (text), line 178 (text), line 181 (text), line 184 (text), line 191 (text), line 193 (text), line 195 (text), line 197 (text), line
  199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 247 (text), line 254 (text) and line 269 (text).
- [docs/adr/automation/BCL/index.md][39]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/BCL/native-csharp-types.md][40]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][41]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][42]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/caching.md][43]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][44]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][45]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][46]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][47]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][1]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][48]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/dry-run.md][49]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][50]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/environment-variables.md][51]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][52]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][53]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][54]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/go/test-artifacts.md][55]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][56]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][57]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][58]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][59]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/never-depend-on-pwd.md][60]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][61]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/path-representation.md][62]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][63]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/protected-globs.md][64]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/python/index.md][65]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][66]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][67]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][68]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][69]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][70]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/test-automation.md][71]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR domain
  of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][72]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][73]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][74]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][75]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][76]: selected by [ADR-AUTO-PARITY][1]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/az-session-verification.md][77]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/azure-customer-model.md][78]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-data-model.md][79]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][80]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/azure-network-model.md][81]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/billing-and-tenant.md][82]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/design-principles.md][83]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/governance.md][84]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][85]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/landing-zone-security.md][86]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/management.md][87]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][88]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/network-connectivity.md][89]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-private-access.md][90]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/caf/network-topology.md][91]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][92]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR
  domain of that code.
- [docs/adr/azure/caf/resource-organization.md][93]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/dora-explains.md][94]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][95]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][2]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][96]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that
  code.
- [docs/adr/azure/waf/operational-excellence.md][97]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/performance-efficiency.md][98]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of
  that code.
- [docs/adr/azure/waf/reliability.md][99]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/security.md][100]: selected by [ADR-AZ-CLI][2]: an ADR file of the `azure` ADR domain, the ADR domain of that code.
- [docs/adr/design/commit-lifecycle.md][101]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/dora-explains.md][102]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/module-aspects.md][103]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/design/run-modes.md][104]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/self-service.md][105]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/server-remote-integration.md][106]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR
  domain of that code.
- [docs/adr/design/thin-platforms.md][3]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of that
  code.
- [docs/adr/design/tracks.md][107]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/visual-design.md][108]: selected by [ADR-DSGN-THINPLAT][3]: an ADR file of the `design` ADR domain, the ADR domain of
  that code.
- [docs/adr/index.md][109]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 125 (text); selected by [ADR-AZ-CLI][2]: the file
  cites it at line 252 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 89 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][110]: selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 13
  (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][111]: selected by [ADR-AZ-CLI][2]: the file cites it at line 63 (text); selected
  by [ADR-DSGN-THINPLAT][3]: the file cites it at line 19 (text), line 58 (text), line 59 (text) and line 65 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][112]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 54
  (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][113]: selected by [ADR-AZ-CLI][2]: the file cites it at line 17 (text),
  line 52 (text), line 53 (text), line 53 (text) and line 57 (text); selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 17
  (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][114]: selected by [ADR-AUTO-PARITY][1]: the file cites it at line 57 (text);
  selected by [ADR-DSGN-THINPLAT][3]: the file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][115]: selected by [ADR-AZ-CLI][2]: the file cites it at line 17 (text), line 34
  (text), line 60 (text), line 60 (text), line 61 (text), line 65 (text), line 67 (text) and line 71 (text); selected by
  [ADR-DSGN-THINPLAT][3]: the file cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text) and line 59
  (text).

### Root files × Unlisted files (2 lit files)

Placed: each file sits directly in the repository root, so it is a root file ([ADR-DSGN-TRACK#7][116]); no extension names no file language,
so each is an unlisted file ([ADR-DSGN-TRACK#8][117]). Lit ([ADR-DSGN-TRACK#12][6]) by:

- [.gitattributes][118]: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its owner module's files (files.yml), which
  cite it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).
- [.gitignore][119]: selected by [ADR-AUTO-PARITY][1]: a root file carries the citations of its owner module's files (files.yml), which cite
  it at `automation/Catzc.Base.Repository/Get-RunEnvironment.ps1` line 6 (header).

## Keywords

- [world map][120]
- [track][121]
- [file language][122]
- [cell][123]
- [lit cell][124]
- [root file][125]
- [unlisted file][126]
- [automation][127]: a track
- [docs][127]: a track
- [markdown][128]: a file language
- [powershell][128]: a file language
- [yaml][128]: a file language

[1]: ../../adr/automation/devbox-pipeline-parity.md
[2]: ../../adr/azure/prefer-az-cli.md
[3]: ../../adr/design/thin-platforms.md
[4]: ../../adr/design/tracks.md#rule-adr-dsgn-track1
[5]: ../../adr/design/tracks.md#rule-adr-dsgn-track6
[6]: ../../adr/design/tracks.md#rule-adr-dsgn-track12
[7]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[8]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[9]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[10]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[11]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[12]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[13]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[14]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[15]: ../../../automation/Catzc.Base.Repository/Get-RunEnvironment.ps1
[16]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[17]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[18]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[19]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[20]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[21]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[22]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
[23]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[24]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[25]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[26]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
[27]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[28]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[29]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[30]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
[31]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[32]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[33]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[34]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
[35]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[36]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[37]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[38]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
[39]: ../../adr/automation/BCL/index.md
[40]: ../../adr/automation/BCL/native-csharp-types.md
[41]: ../../adr/automation/avoid-deep-nesting.md
[42]: ../../adr/automation/bash/bash-test-artifacts.md
[43]: ../../adr/automation/caching.md
[44]: ../../adr/automation/console-output-matters.md
[45]: ../../adr/automation/controlling-module-dependencies.md
[46]: ../../adr/automation/controlling-systemwide-deps.md
[47]: ../../adr/automation/cross-platform.md
[48]: ../../adr/automation/dora-explains.md
[49]: ../../adr/automation/dry-run.md
[50]: ../../adr/automation/effective-in-enterprises.md
[51]: ../../adr/automation/environment-variables.md
[52]: ../../adr/automation/execution-engines.md
[53]: ../../adr/automation/fail-fast-with-asserts.md
[54]: ../../adr/automation/go/index.md
[55]: ../../adr/automation/go/test-artifacts.md
[56]: ../../adr/automation/idempotent-state-functions.md
[57]: ../../adr/automation/internal-asset-dependencies.md
[58]: ../../adr/automation/log-before-invoke.md
[59]: ../../adr/automation/managed-guids.md
[60]: ../../adr/automation/never-depend-on-pwd.md
[61]: ../../adr/automation/open-closed-architecture.md
[62]: ../../adr/automation/path-representation.md
[63]: ../../adr/automation/platform-bundle.md
[64]: ../../adr/automation/protected-globs.md
[65]: ../../adr/automation/python/index.md
[66]: ../../adr/automation/python/python-test-artifacts.md
[67]: ../../adr/automation/retry-as-last-resort.md
[68]: ../../adr/automation/sensible-defaults.md
[69]: ../../adr/automation/single-responsibility-functions.md
[70]: ../../adr/automation/spell-out-names.md
[71]: ../../adr/automation/test-automation.md
[72]: ../../adr/automation/tool-removal-lifecycle.md
[73]: ../../adr/automation/tracked-files-from-the-index.md
[74]: ../../adr/automation/use-proper-package-managers.md
[75]: ../../adr/automation/uv-python-handler.md
[76]: ../../adr/automation/zero-ceremony-poka-yoke.md
[77]: ../../adr/azure/az-session-verification.md
[78]: ../../adr/azure/azure-customer-model.md
[79]: ../../adr/azure/azure-data-model.md
[80]: ../../adr/azure/azure-naming-standard.md
[81]: ../../adr/azure/azure-network-model.md
[82]: ../../adr/azure/caf/billing-and-tenant.md
[83]: ../../adr/azure/caf/design-principles.md
[84]: ../../adr/azure/caf/governance.md
[85]: ../../adr/azure/caf/identity-and-access.md
[86]: ../../adr/azure/caf/landing-zone-security.md
[87]: ../../adr/azure/caf/management.md
[88]: ../../adr/azure/caf/naming-and-tagging.md
[89]: ../../adr/azure/caf/network-connectivity.md
[90]: ../../adr/azure/caf/network-private-access.md
[91]: ../../adr/azure/caf/network-topology.md
[92]: ../../adr/azure/caf/platform-automation-and-devops.md
[93]: ../../adr/azure/caf/resource-organization.md
[94]: ../../adr/azure/dora-explains.md
[95]: ../../adr/azure/landing-zones.md
[96]: ../../adr/azure/waf/cost-optimization.md
[97]: ../../adr/azure/waf/operational-excellence.md
[98]: ../../adr/azure/waf/performance-efficiency.md
[99]: ../../adr/azure/waf/reliability.md
[100]: ../../adr/azure/waf/security.md
[101]: ../../adr/design/commit-lifecycle.md
[102]: ../../adr/design/dora-explains.md
[103]: ../../adr/design/module-aspects.md
[104]: ../../adr/design/run-modes.md
[105]: ../../adr/design/self-service.md
[106]: ../../adr/design/server-remote-integration.md
[107]: ../../adr/design/tracks.md
[108]: ../../adr/design/visual-design.md
[109]: ../../adr/index.md
[110]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[111]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[112]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[113]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[114]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[115]: ../../explanation/design/what-keeps-the-platform-thin.md
[116]: ../../adr/design/tracks.md#rule-adr-dsgn-track7
[117]: ../../adr/design/tracks.md#rule-adr-dsgn-track8
[118]: ../../../.gitattributes
[119]: ../../../.gitignore
[120]: ../../adr/glossary.md#world-map
[121]: ../../adr/glossary.md#track
[122]: ../../adr/glossary.md#file-language
[123]: ../../adr/glossary.md#cell
[124]: ../../adr/glossary.md#lit-cell
[125]: ../../adr/glossary.md#root-file
[126]: ../../adr/glossary.md#unlisted-file
[127]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[128]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
