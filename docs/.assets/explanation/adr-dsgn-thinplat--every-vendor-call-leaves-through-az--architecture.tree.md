# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md

`Tree minimap: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture`

![Tree minimap of adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.png)

The tree minimap of the slide `adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture` (architecture lens). The slide supports
[ADR-AZ-CLI][1] and [ADR-DSGN-THINPLAT][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 71 files in 7 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- adr/azure (docs/adr/azure): 25 lit files
- docs (docs/ outside docs/adr/): 25 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- Az.Cli (automation/Catzc.Azure.Cli): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 2 lit files
- Docs (automation/Catzc.Base.Docs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### adr/azure (25 lit files)

The group holds the files of docs/adr/azure; each sits in its world-map cell and is lit by:

- [docs/adr/azure/az-session-verification.md][3], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-customer-model.md][4], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-data-model.md][5], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/azure-naming-standard.md][6], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/azure-network-model.md][7], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/billing-and-tenant.md][8], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/design-principles.md][9], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/governance.md][10], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/identity-and-access.md][11], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/landing-zone-security.md][12], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/management.md][13], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/caf/naming-and-tagging.md][14], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-connectivity.md][15], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-private-access.md][16], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/network-topology.md][17], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/caf/platform-automation-and-devops.md][18], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the
  `azure` ADR domain, the ADR domain of that code.
- [docs/adr/azure/caf/resource-organization.md][19], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/dora-explains.md][20], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/landing-zones.md][21], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/prefer-az-cli.md][1], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.
- [docs/adr/azure/waf/cost-optimization.md][22], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR
  domain, the ADR domain of that code.
- [docs/adr/azure/waf/operational-excellence.md][23], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/performance-efficiency.md][24], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure`
  ADR domain, the ADR domain of that code.
- [docs/adr/azure/waf/reliability.md][25], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain,
  the ADR domain of that code.
- [docs/adr/azure/waf/security.md][26], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: an ADR file of the `azure` ADR domain, the
  ADR domain of that code.

### docs (25 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md][27], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md][28], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md][29], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text), line 38
  (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and line 69
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md][30], in the cell docs × markdown: selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text), line 36
  (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and line 89
  (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md][31], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md][32], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md][33], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md][34], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md][35], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md][36], in the cell docs ×
  markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 68 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line
  68 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md][37], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 27 (text), line 28 (text), line 29 (text), line 31 (text), line 32
  (text), line 33 (text), line 34 (text), line 35 (text), line 42 (text), line 44 (text), line 45 (text), line 58 (text), line 61 (text),
  line 63 (text), line 65 (text), line 67 (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 75 (text), line 76
  (text), line 78 (text), line 80 (text), line 81 (text), line 82 (text), line 83 (text), line 84 (text), line 86 (text), line 88 (text),
  line 90 (text), line 91 (text), line 109 (text), line 113 (text), line 115 (text) and line 120 (text); selected by [ADR-DSGN-THINPLAT][2]:
  the file cites it at line 8 (text), line 43 (text), line 46 (text), line 53 (text), line 56 (text), line 58 (text), line 60 (text), line
  62 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104 (text), line 106
  (text), line 107 (text), line 109 (text), line 111 (text), line 114 (text), line 116 (text), line 118 (text) and line 122 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md][38], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38
  (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 78 (text), line 83 (text), line 86
  (text), line 89 (text), line 94 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 147 (text), line 149 (text), line 156 (text) and line 163 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 74 (text), line 76 (text), line 78 (text), line 81 (text), line 83
  (text), line 84 (text), line 87 (text), line 90 (text), line 92 (text), line 96 (text), line 103 (text), line 105 (text), line 107 (text),
  line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 150 (text), line 157 (text) and
  line 164 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md][39], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md][40], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md][41], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 25 (text), line 26 (text), line 33 (text), line 36 (text),
  line 38 (text), line 40 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53
  (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text) and
  line 69 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md][42], in the cell docs × markdown:
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 28 (text), line 30 (text), line 32 (text), line 34 (text),
  line 36 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 52 (text), line 54 (text), line 56
  (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 75 (text), line 82 (text) and
  line 89 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md][43], in the cell docs × markdown: selected
  by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 53 (text), line 53 (text), line 61 (text) and line 61 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 29 (text), line 29 (text), line 37 (text) and line 37 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md][44], in the cell docs × markdown:
  selected by [ADR-AZ-CLI][1]: the file cites it at line 74 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md][45], in the cell docs × markdown: selected
  by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 36 (text), line 45 (text), line 46 (text), line 47 (text), line 60 (text), line 63 (text), line 143
  (text), line 145 (text), line 147 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 155 (text), line 156
  (text), line 158 (text), line 160 (text), line 161 (text), line 162 (text), line 163 (text), line 164 (text), line 166 (text), line 168
  (text), line 170 (text), line 171 (text), line 189 (text), line 193 (text), line 197 (text) and line 202 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 45 (text), line 48 (text), line 55 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 180 (text), line 182
  (text), line 184 (text), line 186 (text), line 187 (text), line 190 (text), line 191 (text), line 194 (text), line 198 (text), line 201
  (text) and line 204 (text).
- [docs/.assets/explanation/adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md][46], in the cell docs × markdown: selected
  by [ADR-AZ-CLI][1]: the file cites it at line 8 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 124
  (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140
  (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 164 (text), line 169
  (text), line 172 (text), line 177 (text), line 182 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222
  (text), line 224 (text), line 226 (text), line 228 (text), line 244 (text), line 246 (text), line 254 (text) and line 269 (text); selected
  by [ADR-DSGN-THINPLAT][2]: the file cites it at line 8 (text), line 160 (text), line 162 (text), line 164 (text), line 167 (text), line
  169 (text), line 170 (text), line 173 (text), line 178 (text), line 181 (text), line 184 (text), line 191 (text), line 193 (text), line
  195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 247 (text), line
  254 (text) and line 269 (text).
- [docs/explanation/design/bind-to-one-cli-delegate-the-rest.md][47], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 13 (text), line 37 (text), line 38 (text), line 40 (text) and line 42 (text).
- [docs/explanation/design/deploy-bicep-delegates-to-az.md][48], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 63 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 19 (text), line 58 (text), line 59 (text) and line 65
  (text).
- [docs/explanation/design/every-vendor-call-leaves-through-az.md][49], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 53 (text) and line 57 (text); selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 17 (text), line 48 (text), line 49 (text) and line 51 (text).
- [docs/explanation/design/same-deploy-bicep-on-both-sides.md][50], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: the
  file cites it at line 16 (text), line 52 (text) and line 53 (text).
- [docs/explanation/design/what-keeps-the-platform-thin.md][51], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 17 (text), line 34 (text), line 60 (text), line 60 (text), line 61 (text), line 65 (text), line 67 (text) and line 71 (text);
  selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 17 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][52], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][53], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][54], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][55], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][56], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][57], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][2], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][58], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][59], in the cell docs × markdown: selected by [ADR-DSGN-THINPLAT][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### Az.Cli (8 lit files)

The group holds the files of automation/Catzc.Azure.Cli; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1][60], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1][61], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 15 (header).
- [automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1][62], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 14 (header).
- [automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1][63], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 21 (header).
- [automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1][64], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 11 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1][65], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites it
  at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1][66], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]: the file cites
  it at line 14 (header).
- [automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1][67], in the cell automation × powershell: selected by [ADR-AZ-CLI][1]:
  the file cites it at line 13 (header).

### QualityGates (2 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][68], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the
  file cites it at line 19 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][69], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file
  cites it at line 580 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 664 (text).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][70], in the cell automation × yaml: selected by [ADR-AZ-CLI][1]: the file cites it at line
  270 (text); selected by [ADR-DSGN-THINPLAT][2]: the file cites it at line 96 (text).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][71], in the cell docs × markdown: selected by [ADR-AZ-CLI][1]: the file cites it at line 252 (text); selected by
  [ADR-DSGN-THINPLAT][2]: the file cites it at line 89 (text).

## Keywords

- [world map][72]
- [track][73]
- [file language][74]
- [cell][75]
- [lit cell][76]
- [automation][77]: a track
- [docs][77]: a track
- [markdown][78]: a file language
- [powershell][78]: a file language
- [yaml][78]: a file language

[1]: ../../adr/azure/prefer-az-cli.md
[2]: ../../adr/design/thin-platforms.md
[3]: ../../adr/azure/az-session-verification.md
[4]: ../../adr/azure/azure-customer-model.md
[5]: ../../adr/azure/azure-data-model.md
[6]: ../../adr/azure/azure-naming-standard.md
[7]: ../../adr/azure/azure-network-model.md
[8]: ../../adr/azure/caf/billing-and-tenant.md
[9]: ../../adr/azure/caf/design-principles.md
[10]: ../../adr/azure/caf/governance.md
[11]: ../../adr/azure/caf/identity-and-access.md
[12]: ../../adr/azure/caf/landing-zone-security.md
[13]: ../../adr/azure/caf/management.md
[14]: ../../adr/azure/caf/naming-and-tagging.md
[15]: ../../adr/azure/caf/network-connectivity.md
[16]: ../../adr/azure/caf/network-private-access.md
[17]: ../../adr/azure/caf/network-topology.md
[18]: ../../adr/azure/caf/platform-automation-and-devops.md
[19]: ../../adr/azure/caf/resource-organization.md
[20]: ../../adr/azure/dora-explains.md
[21]: ../../adr/azure/landing-zones.md
[22]: ../../adr/azure/waf/cost-optimization.md
[23]: ../../adr/azure/waf/operational-excellence.md
[24]: ../../adr/azure/waf/performance-efficiency.md
[25]: ../../adr/azure/waf/reliability.md
[26]: ../../adr/azure/waf/security.md
[27]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.chain.md
[28]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.drawio.md
[29]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.grid.md
[30]: adr-dsgn-thinplat--bind-to-one-cli-delegate-the-rest--meta.tree.md
[31]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
[32]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
[33]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
[34]: adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
[35]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.chain.md
[36]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md
[37]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.grid.md
[38]: adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.tree.md
[39]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
[40]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
[41]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
[42]: adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
[43]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.chain.md
[44]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.drawio.md
[45]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.grid.md
[46]: adr-dsgn-thinplat--what-keeps-the-platform-thin--governance.tree.md
[47]: ../../explanation/design/bind-to-one-cli-delegate-the-rest.md
[48]: ../../explanation/design/deploy-bicep-delegates-to-az.md
[49]: ../../explanation/design/every-vendor-call-leaves-through-az.md
[50]: ../../explanation/design/same-deploy-bicep-on-both-sides.md
[51]: ../../explanation/design/what-keeps-the-platform-thin.md
[52]: ../../adr/design/commit-lifecycle.md
[53]: ../../adr/design/dora-explains.md
[54]: ../../adr/design/module-aspects.md
[55]: ../../adr/design/run-modes.md
[56]: ../../adr/design/self-service.md
[57]: ../../adr/design/server-remote-integration.md
[58]: ../../adr/design/tracks.md
[59]: ../../adr/design/visual-design.md
[60]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
[61]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
[62]: ../../../automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
[63]: ../../../automation/Catzc.Azure.Cli/Get-AzCliSubscriptionAccessState.ps1
[64]: ../../../automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
[65]: ../../../automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
[66]: ../../../automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
[67]: ../../../automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
[68]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[69]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[70]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[71]: ../../adr/index.md
[72]: ../../adr/glossary.md#world-map
[73]: ../../adr/glossary.md#track
[74]: ../../adr/glossary.md#file-language
[75]: ../../adr/glossary.md#cell
[76]: ../../adr/glossary.md#lit-cell
[77]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[78]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
