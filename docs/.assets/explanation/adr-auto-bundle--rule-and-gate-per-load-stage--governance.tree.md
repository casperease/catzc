# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md

`Tree minimap: adr-auto-bundle--rule-and-gate-per-load-stage--governance`

![Tree minimap of adr-auto-bundle--rule-and-gate-per-load-stage--governance](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.png)

The tree minimap of the slide `adr-auto-bundle--rule-and-gate-per-load-stage--governance` (governance lens). The slide supports
[ADR-AUTO-BUNDLE][1], [ADR-AUTO-TYPES][2], [ADR-DSGN-RUNMODE][3], [ADR-PRIN-ONELIVE][4], [ADR-PWSH-ERROR][5] and [ADR-REPO-ROOTCFG][6]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 375 files in 39 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 87 lit files
- adr/auto (docs/adr/automation): 39 lit files
- adr/pwsh (docs/adr/pwsh): 26 lit files
- Docs (automation/Catzc.Base.Docs): 22 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 20 lit files
- Maps (automation/Catzc.Base.Maps): 16 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 16 lit files
- adr/repo (docs/adr/repository): 15 lit files
- Languages (automation/Catzc.Base.Languages): 12 lit files
- VSCode (automation/Catzc.Base.VSCode): 12 lit files
- Exporter (automation/Catzc.Base.Exporter): 11 lit files
- Azure (automation/Catzc.Azure): 9 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 9 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- RootConfig (automation/Catzc.Base.RootConfig): 8 lit files
- adr/prin (docs/adr/principles): 7 lit files
- Contracts (automation/Catzc.Base.Contracts): 6 lit files
- Az.Templates (automation/Catzc.Azure.Templates): 5 lit files
- Repository (automation/Catzc.Base.Repository): 5 lit files
- .internal (automation/.internal): 4 lit files
- Reports (automation/Catzc.Base.Reports): 4 lit files
- Root files: 3 lit files
- Git (automation/Catzc.Base.Git): 3 lit files
- Variants (automation/Catzc.Base.Variants): 3 lit files
- Vendor (automation/Catzc.Base.Vendor): 3 lit files
- .claude: 2 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 2 lit files
- Files (automation/Catzc.Base.Files): 2 lit files
- Objects (automation/Catzc.Base.Objects): 2 lit files
- Timeouts (automation/Catzc.Base.Timeouts): 2 lit files
- Tool.Inspiration (automation/Catzc.Tooling.Inspiration): 2 lit files
- Tool.KeyHandler (automation/Catzc.Tooling.KeyHandler): 2 lit files
- .github: 1 lit file
- .scriptanalyzer (automation/.scriptanalyzer): 1 lit file
- Az.DevOps (automation/Catzc.Azure.DevOps): 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Engines (automation/Catzc.Base.Engines): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (87 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][7], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][9], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line
  46 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text),
  line 70 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text),
  line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text),
  line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text),
  line 183 (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md][10], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line
  144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line
  197 (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][11], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][12], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][13], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line
  46 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text),
  line 70 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text),
  line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text),
  line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text),
  line 183 (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md][14], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line
  144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line
  197 (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][15], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][16], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text),
  line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70
  (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183
  (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.tree.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text),
  line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197
  (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][19], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][20], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][21], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 39 (text), line 40 (text), line 47 (text), line 52 (text),
  line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 60 (text), line 62 (text), line 105 (text), line 107 (text), line 115
  (text), line 118 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 132
  (text), line 134 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159
  (text), line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175
  (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191
  (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207
  (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223
  (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 252 (text), line 254 (text), line 256
  (text), line 259 (text), line 262 (text), line 264 (text) and line 283 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 8 (text), line 48 (text), line 49 (text), line 50 (text), line 54 (text), line 64 (text), line 65 (text), line 66 (text), line 68
  (text), line 69 (text), line 71 (text), line 73 (text), line 74 (text), line 75 (text), line 77 (text), line 78 (text), line 79 (text),
  line 81 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 98 (text), line 106 (text), line 108 (text), line 122 (text), line 128 (text), line 130
  (text), line 135 (text), line 137 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 225 (text), line 227
  (text), line 229 (text), line 231 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241
  (text), line 250 (text), line 253 (text), line 257 (text), line 260 (text), line 266 (text), line 267 (text), line 269 (text), line 271
  (text), line 273 (text), line 275 (text), line 284 (text), line 293 (text) and line 297 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md][22], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101
  (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117
  (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139
  (text), line 142 (text), line 144 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 165 (text), line 168
  (text), line 170 (text), line 173 (text), line 176 (text), line 178 (text), line 198 (text), line 200 (text), line 202 (text), line 204
  (text), line 206 (text), line 208 (text), line 211 (text), line 212 (text), line 214 (text), line 303 (text), line 324 (text), line 333
  (text), line 351 (text), line 365 (text) and line 386 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line
  131 (text), line 137 (text), line 139 (text), line 144 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line
  155 (text), line 164 (text), line 166 (text), line 171 (text), line 175 (text), line 180 (text), line 182 (text), line 184 (text), line
  186 (text), line 188 (text), line 190 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line
  231 (text), line 233 (text), line 235 (text), line 237 (text), line 244 (text), line 247 (text), line 248 (text), line 251 (text), line
  253 (text), line 254 (text), line 256 (text), line 259 (text), line 265 (text), line 267 (text), line 269 (text), line 272 (text), line
  274 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 295 (text), line 299 (text), line
  305 (text), line 313 (text), line 315 (text), line 317 (text), line 325 (text), line 327 (text), line 334 (text), line 335 (text), line
  342 (text), line 344 (text), line 359 (text), line 372 (text), line 379 (text) and line 387 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][23], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][24], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][25], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46 (text),
  line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text), line 70
  (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136
  (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183
  (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md][26], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57
  (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text),
  line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129
  (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144
  (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line 166
  (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line 197
  (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][27], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][28], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][29], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line
  46 (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text),
  line 70 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text),
  line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text),
  line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text),
  line 183 (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md][30], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line
  39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line
  144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line
  197 (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][31], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][32], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][33], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (text), line 30 (text), line 38 (text), line 39 (text), line 46 (text), line 51 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 61 (text), line 104 (text), line 106 (text), line 114
  (text), line 117 (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158
  (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174
  (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206
  (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222
  (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 251 (text), line 253 (text), line 255
  (text), line 258 (text), line 261 (text), line 263 (text) and line 282 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 8 (text), line 47 (text), line 48 (text), line 49 (text), line 53 (text), line 63 (text), line 64 (text), line 65 (text), line 67
  (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 77 (text), line 78 (text),
  line 80 (text), line 82 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 96 (text), line 97 (text), line 105 (text), line 107 (text), line 121 (text), line 127 (text), line 129
  (text), line 134 (text), line 136 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 224 (text), line 226
  (text), line 228 (text), line 230 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 238 (text), line 240
  (text), line 249 (text), line 252 (text), line 256 (text), line 259 (text), line 265 (text), line 266 (text), line 268 (text), line 270
  (text), line 272 (text), line 274 (text), line 283 (text), line 292 (text) and line 296 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md][34], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text),
  line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 141 (text), line 143 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 164 (text), line 167
  (text), line 169 (text), line 172 (text), line 175 (text), line 177 (text), line 197 (text), line 199 (text), line 201 (text), line 203
  (text), line 205 (text), line 207 (text), line 210 (text), line 211 (text), line 213 (text), line 302 (text), line 323 (text), line 332
  (text), line 350 (text), line 364 (text) and line 385 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line
  130 (text), line 136 (text), line 138 (text), line 143 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 163 (text), line 165 (text), line 170 (text), line 174 (text), line 179 (text), line 181 (text), line 183 (text), line
  185 (text), line 187 (text), line 189 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line
  230 (text), line 232 (text), line 234 (text), line 236 (text), line 243 (text), line 246 (text), line 247 (text), line 250 (text), line
  252 (text), line 253 (text), line 255 (text), line 258 (text), line 264 (text), line 266 (text), line 268 (text), line 271 (text), line
  273 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 294 (text), line 298 (text), line
  304 (text), line 312 (text), line 314 (text), line 316 (text), line 324 (text), line 326 (text), line 333 (text), line 334 (text), line
  341 (text), line 343 (text), line 358 (text), line 371 (text), line 378 (text) and line 386 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][35], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 68 (text), line 68 (text), line 79 (text) and line 79 (text); selected
  by [ADR-AUTO-TYPES][2]: the file cites it at line 8 (text), line 54 (text), line 54 (text), line 71 (text) and line 71 (text); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 38 (text), line 38 (text), line 46 (text) and line 46 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 30 (text) and line 30 (text); selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 8 (text), line 57 (text) and line 57 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (text), line
  60 (text) and line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][36], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 56 (text) and line 63 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 56 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 56 (text) and line 64 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text) and line 64 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line
  56 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][37], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 41 (text), line 90 (text), line 92 (text), line 178 (text), line 192
  (text), line 205 (text), line 206 (text), line 208 (text), line 209 (text), line 210 (text), line 212 (text), line 309 (text), line 313
  (text), line 334 (text), line 336 (text), line 337 (text), line 339 (text), line 341 (text), line 344 (text), line 345 (text), line 347
  (text), line 352 (text), line 354 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 377 (text), line 379
  (text), line 381 (text), line 384 (text), line 386 (text), line 388 (text), line 390 (text), line 392 (text), line 394 (text), line 396
  (text), line 398 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text), line 412
  (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text), line 428
  (text), line 430 (text), line 432 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445
  (text), line 447 (text), line 465 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 569 (text), line 571
  (text), line 573 (text), line 576 (text), line 582 (text), line 584 (text) and line 616 (text); selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (text), line 34 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text),
  line 59 (text), line 60 (text), line 61 (text), line 62 (text), line 63 (text), line 64 (text), line 65 (text), line 66 (text), line 67
  (text), line 68 (text), line 69 (text), line 70 (text), line 71 (text), line 72 (text), line 73 (text), line 76 (text), line 77 (text),
  line 78 (text), line 79 (text), line 81 (text), line 82 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87
  (text), line 88 (text), line 89 (text), line 91 (text), line 93 (text), line 94 (text), line 96 (text), line 97 (text), line 98 (text),
  line 99 (text), line 100 (text), line 101 (text), line 102 (text), line 104 (text), line 105 (text), line 106 (text), line 107 (text),
  line 109 (text), line 110 (text), line 111 (text), line 112 (text), line 113 (text), line 114 (text), line 115 (text), line 116 (text),
  line 117 (text), line 118 (text), line 119 (text), line 120 (text), line 121 (text), line 122 (text), line 123 (text), line 124 (text),
  line 125 (text), line 126 (text), line 127 (text), line 128 (text), line 130 (text), line 131 (text), line 132 (text), line 133 (text),
  line 135 (text), line 136 (text), line 137 (text), line 139 (text), line 141 (text), line 142 (text), line 143 (text), line 144 (text),
  line 145 (text), line 147 (text), line 149 (text), line 151 (text), line 152 (text), line 154 (text), line 158 (text), line 160 (text),
  line 161 (text), line 162 (text), line 163 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 180 (text),
  line 183 (text), line 194 (text), line 202 (text), line 204 (text), line 219 (text), line 223 (text), line 230 (text), line 234 (text),
  line 236 (text), line 238 (text), line 264 (text), line 265 (text), line 278 (text), line 282 (text), line 288 (text), line 290 (text),
  line 292 (text), line 294 (text), line 310 (text), line 348 (text), line 370 (text), line 372 (text), line 374 (text), line 376 (text),
  line 378 (text), line 380 (text), line 382 (text), line 385 (text), line 387 (text), line 389 (text), line 391 (text), line 393 (text),
  line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 403 (text), line 405 (text), line 407 (text), line 409 (text),
  line 411 (text), line 413 (text), line 415 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 425 (text),
  line 427 (text), line 429 (text), line 431 (text), line 433 (text), line 436 (text), line 438 (text), line 440 (text), line 442 (text),
  line 444 (text), line 446 (text), line 448 (text), line 465 (text), line 577 (text), line 599 (text), line 607 (text), line 608 (text),
  line 617 (text), line 632 (text) and line 638 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 179
  (text), line 182 (text), line 190 (text), line 201 (text), line 217 (text), line 220 (text), line 221 (text), line 224 (text), line 225
  (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 242 (text), line 244 (text), line 253 (text), line 255
  (text), line 261 (text), line 262 (text), line 263 (text), line 267 (text), line 280 (text), line 283 (text), line 284 (text), line 286
  (text), line 289 (text), line 301 (text), line 302 (text), line 310 (text), line 317 (text), line 340 (text), line 346 (text), line 349
  (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 449 (text), line 451
  (text), line 453 (text), line 455 (text), line 456 (text), line 458 (text), line 460 (text), line 462 (text), line 463 (text), line 466
  (text), line 567 (text), line 570 (text), line 574 (text), line 578 (text), line 586 (text), line 587 (text), line 589 (text), line 591
  (text), line 593 (text), line 595 (text), line 623 (text), line 634 (text) and line 640 (text); selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 8 (text), line 32 (text), line 215 (text), line 311 (text), line 318 (text), line 349 (text), line 368 (text), line
  467 (text), line 469 (text), line 471 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line
  579 (text) and line 597 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 8 (text), line 33 (text), line 74 (text), line
  134 (text), line 185 (text), line 186 (text), line 188 (text), line 196 (text), line 198 (text), line 199 (text), line 211 (text), line
  240 (text), line 247 (text), line 249 (text), line 251 (text), line 257 (text), line 259 (text), line 311 (text), line 315 (text), line
  350 (text), line 467 (text), line 483 (text), line 485 (text), line 486 (text), line 488 (text), line 490 (text), line 492 (text), line
  493 (text), line 495 (text), line 497 (text), line 498 (text), line 500 (text), line 502 (text), line 503 (text), line 505 (text), line
  507 (text), line 509 (text), line 511 (text), line 513 (text), line 515 (text), line 517 (text), line 519 (text), line 520 (text), line
  522 (text), line 524 (text), line 526 (text), line 528 (text), line 580 (text), line 601 (text) and line 602 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (text), line 95 (text), line 103 (text), line 108 (text), line 148 (text), line 153
  (text), line 155 (text), line 156 (text), line 159 (text), line 214 (text), line 216 (text), line 218 (text), line 245 (text), line 268
  (text), line 269 (text), line 271 (text), line 272 (text), line 274 (text), line 276 (text), line 296 (text), line 297 (text), line 298
  (text), line 300 (text), line 312 (text), line 314 (text), line 318 (text), line 320 (text), line 321 (text), line 323 (text), line 324
  (text), line 326 (text), line 351 (text), line 468 (text), line 530 (text), line 532 (text), line 534 (text), line 536 (text), line 538
  (text), line 540 (text), line 542 (text), line 544 (text), line 546 (text), line 548 (text), line 550 (text), line 552 (text), line 554
  (text), line 556 (text), line 558 (text), line 580 (text), line 604 (text) and line 605 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md][38], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 62 (text), line 65 (text), line 68 (text), line 71 (text), line 74 (text),
  line 77 (text), line 80 (text), line 83 (text), line 86 (text), line 89 (text), line 92 (text), line 95 (text), line 98 (text), line 101
  (text), line 104 (text), line 107 (text), line 110 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 125
  (text), line 128 (text), line 131 (text), line 134 (text), line 137 (text), line 140 (text), line 143 (text), line 146 (text), line 149
  (text), line 152 (text), line 155 (text), line 158 (text), line 161 (text), line 164 (text), line 167 (text), line 170 (text), line 173
  (text), line 176 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197
  (text), line 199 (text), line 204 (text), line 206 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 229
  (text), line 232 (text), line 234 (text), line 237 (text), line 243 (text), line 245 (text), line 344 (text), line 603 (text), line 605
  (text), line 607 (text), line 609 (text), line 612 (text), line 613 (text), line 616 (text), line 617 (text), line 619 (text), line 737
  (text), line 784 (text), line 822 (text), line 933 (text) and line 975 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line
  8 (text), line 63 (text), line 66 (text), line 69 (text), line 72 (text), line 75 (text), line 78 (text), line 81 (text), line 84 (text),
  line 87 (text), line 90 (text), line 93 (text), line 96 (text), line 99 (text), line 102 (text), line 105 (text), line 108 (text), line
  111 (text), line 114 (text), line 117 (text), line 120 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line
  135 (text), line 138 (text), line 141 (text), line 144 (text), line 147 (text), line 150 (text), line 153 (text), line 156 (text), line
  159 (text), line 162 (text), line 165 (text), line 168 (text), line 171 (text), line 174 (text), line 177 (text), line 199 (text), line
  239 (text), line 262 (text), line 272 (text), line 274 (text), line 345 (text), line 351 (text), line 352 (text), line 354 (text), line
  356 (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 368 (text), line 370 (text), line 372 (text), line
  374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 416 (text), line 418 (text), line 420 (text), line
  422 (text), line 425 (text), line 426 (text), line 428 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line
  443 (text), line 445 (text), line 447 (text), line 449 (text), line 451 (text), line 453 (text), line 455 (text), line 457 (text), line
  459 (text), line 461 (text), line 463 (text), line 465 (text), line 472 (text), line 476 (text), line 484 (text), line 490 (text), line
  491 (text), line 493 (text), line 495 (text), line 497 (text), line 499 (text), line 501 (text), line 503 (text), line 547 (text), line
  549 (text), line 551 (text), line 553 (text), line 555 (text), line 557 (text), line 559 (text), line 561 (text), line 563 (text), line
  565 (text), line 567 (text), line 590 (text), line 592 (text), line 596 (text), line 618 (text), line 620 (text), line 621 (text), line
  628 (text), line 630 (text), line 632 (text), line 634 (text), line 636 (text), line 638 (text), line 640 (text), line 642 (text), line
  644 (text), line 652 (text), line 655 (text), line 661 (text), line 664 (text), line 666 (text), line 668 (text), line 740 (text), line
  741 (text), line 743 (text), line 745 (text), line 747 (text), line 758 (text), line 760 (text), line 762 (text), line 775 (text), line
  778 (text), line 786 (text), line 790 (text), line 797 (text), line 799 (text), line 801 (text), line 803 (text), line 810 (text), line
  816 (text), line 824 (text), line 848 (text), line 850 (text), line 852 (text), line 863 (text), line 872 (text), line 880 (text), line
  882 (text), line 898 (text), line 900 (text), line 906 (text), line 908 (text), line 915 (text), line 917 (text), line 924 (text), line
  927 (text), line 947 (text), line 961 (text) and line 976 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text),
  line 191 (text), line 197 (text), line 200 (text), line 206 (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text),
  line 217 (text), line 228 (text), line 230 (text), line 235 (text), line 239 (text), line 247 (text), line 249 (text), line 251 (text),
  line 253 (text), line 255 (text), line 257 (text), line 345 (text), line 348 (text), line 391 (text), line 393 (text), line 397 (text),
  line 409 (text), line 411 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 482 (text),
  line 485 (text), line 488 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line 662 (text), line 674 (text),
  line 676 (text), line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line 690 (text),
  line 697 (text), line 769 (text), line 771 (text), line 773 (text), line 785 (text), line 789 (text), line 812 (text), line 818 (text),
  line 829 (text), line 859 (text), line 861 (text), line 955 (text), line 968 (text) and line 976 (text); selected by
  [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 201 (text), line 219 (text), line 240 (text), line 260 (text), line 346
  (text), line 398 (text), line 718 (text), line 720 (text), line 722 (text), line 724 (text), line 726 (text), line 728 (text), line 730
  (text), line 870 (text), line 890 (text) and line 977 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 8 (text), line
  201 (text), line 241 (text), line 264 (text), line 266 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line
  289 (text), line 291 (text), line 293 (text), line 295 (text), line 297 (text), line 299 (text), line 301 (text), line 303 (text), line
  305 (text), line 307 (text), line 309 (text), line 311 (text), line 313 (text), line 315 (text), line 317 (text), line 319 (text), line
  321 (text), line 323 (text), line 325 (text), line 327 (text), line 329 (text), line 331 (text), line 338 (text), line 340 (text), line
  342 (text), line 346 (text), line 358 (text), line 389 (text), line 395 (text), line 403 (text), line 405 (text), line 407 (text), line
  413 (text), line 415 (text), line 417 (text), line 612 (text), line 754 (text), line 756 (text), line 871 (text), line 941 (text) and line
  977 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (text), line 202 (text), line 242 (text), line 268 (text), line
  270 (text), line 347 (text), line 399 (text), line 401 (text), line 510 (text), line 512 (text), line 514 (text), line 516 (text), line
  518 (text), line 520 (text), line 522 (text), line 524 (text), line 526 (text), line 528 (text), line 530 (text), line 532 (text), line
  534 (text), line 536 (text), line 538 (text), line 545 (text), line 560 (text), line 568 (text), line 574 (text), line 576 (text), line
  578 (text), line 580 (text), line 582 (text), line 584 (text), line 586 (text), line 588 (text), line 591 (text), line 593 (text), line
  595 (text), line 597 (text), line 698 (text), line 700 (text), line 701 (text), line 703 (text), line 706 (text), line 708 (text), line
  710 (text), line 711 (text), line 837 (text), line 839 (text), line 841 (text), line 888 (text) and line 978 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][39], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][40], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][41], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 45 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 51 (text), line 52 (text), line 54 (text), line 62 (text), line 63 (text),
  line 70 (text), line 73 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text),
  line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text),
  line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text),
  line 136 (text), line 138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text),
  line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text),
  line 168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text),
  line 183 (text), line 185 (text), line 187 (text) and line 195 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md][42], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text),
  line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73
  (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line
  129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line 142 (text), line
  144 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 160 (text), line 162 (text), line 164 (text), line
  166 (text), line 168 (text), line 170 (text), line 173 (text), line 174 (text), line 176 (text), line 183 (text), line 190 (text), line
  197 (text), line 204 (text), line 211 (text) and line 218 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][43], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 57 (text), line 57 (text), line 73 (text) and line 73 (text); selected
  by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 30 (text), line 30 (text), line 38 (text) and line 38 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][44], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 67 (text) and line 74 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][45], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 71 (text), line 181 (text),
  line 278 (text), line 279 (text), line 281 (text), line 282 (text), line 283 (text), line 285 (text), line 763 (text), line 773 (text),
  line 794 (text), line 796 (text), line 797 (text), line 799 (text), line 801 (text), line 804 (text), line 805 (text), line 807 (text),
  line 810 (text), line 812 (text), line 836 (text), line 839 (text), line 842 (text), line 845 (text), line 848 (text), line 851 (text),
  line 854 (text), line 857 (text), line 860 (text), line 863 (text), line 866 (text), line 869 (text), line 872 (text), line 875 (text),
  line 878 (text), line 881 (text), line 884 (text), line 887 (text), line 890 (text), line 893 (text), line 896 (text), line 899 (text),
  line 902 (text), line 905 (text), line 908 (text), line 911 (text), line 914 (text), line 917 (text), line 920 (text), line 923 (text),
  line 926 (text), line 929 (text), line 932 (text), line 935 (text), line 938 (text), line 941 (text), line 944 (text), line 947 (text),
  line 950 (text), line 971 (text), line 974 (text), line 977 (text), line 979 (text), line 981 (text), line 984 (text), line 986 (text),
  line 988 (text), line 991 (text), line 994 (text), line 999 (text) and line 1050 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 8 (text), line 72 (text), line 77 (text), line 176 (text), line 200 (text), line 295 (text), line 351 (text), line 352 (text),
  line 354 (text), line 356 (text), line 358 (text), line 359 (text), line 360 (text), line 367 (text), line 407 (text), line 409 (text),
  line 592 (text), line 594 (text), line 650 (text), line 652 (text), line 653 (text), line 658 (text), line 672 (text), line 674 (text),
  line 676 (text), line 678 (text), line 680 (text), line 691 (text), line 692 (text), line 764 (text), line 781 (text), line 800 (text),
  line 806 (text), line 808 (text), line 814 (text), line 821 (text), line 824 (text), line 826 (text), line 828 (text), line 830 (text),
  line 952 (text), line 954 (text), line 956 (text), line 958 (text), line 959 (text), line 961 (text), line 963 (text), line 965 (text),
  line 966 (text), line 972 (text), line 982 (text), line 985 (text), line 989 (text), line 992 (text), line 1001 (text), line 1005 (text),
  line 1008 (text), line 1010 (text), line 1012 (text), line 1015 (text), line 1055 (text), line 1069 (text) and line 1077 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][46], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360
  (text), line 362 (text), line 364 (text), line 366 (text), line 369 (text), line 371 (text), line 393 (text), line 396 (text), line 398
  (text), line 400 (text), line 403 (text), line 406 (text), line 408 (text), line 411 (text), line 414 (text), line 419 (text), line 480
  (text), line 558 (text), line 561 (text), line 564 (text), line 567 (text), line 570 (text), line 573 (text), line 576 (text), line 580
  (text), line 583 (text), line 586 (text), line 589 (text), line 592 (text), line 595 (text), line 598 (text), line 601 (text), line 604
  (text), line 607 (text), line 610 (text), line 613 (text), line 616 (text), line 619 (text), line 622 (text), line 625 (text), line 628
  (text), line 631 (text), line 634 (text), line 637 (text), line 640 (text), line 643 (text), line 646 (text), line 649 (text), line 652
  (text), line 656 (text), line 659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line 849
  (text), line 851 (text), line 853 (text), line 855 (text), line 858 (text), line 859 (text), line 862 (text), line 869 (text), line 871
  (text), line 1079 (text), line 1120 (text), line 1239 (text), line 1317 (text) and line 1324 (text); selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 8 (text), line 74 (text), line 76 (text), line 120 (text), line 286 (text), line 288 (text), line 358 (text),
  line 364 (text), line 366 (text), line 372 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 388 (text),
  line 402 (text), line 404 (text), line 409 (text), line 413 (text), line 421 (text), line 425 (text), line 429 (text), line 431 (text),
  line 433 (text), line 436 (text), line 481 (text), line 484 (text), line 752 (text), line 755 (text), line 756 (text), line 759 (text),
  line 762 (text), line 764 (text), line 766 (text), line 773 (text), line 814 (text), line 986 (text), line 988 (text), line 990 (text),
  line 992 (text), line 994 (text), line 1033 (text), line 1056 (text), line 1058 (text), line 1060 (text), line 1062 (text), line 1064
  (text), line 1066 (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1121 (text), line 1127 (text), line 1169 (text), line
  1172 (text), line 1173 (text), line 1228 (text), line 1236 (text), line 1245 (text), line 1265 (text), line 1304 (text), line 1306 (text)
  and line 1318 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][47], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][48], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][49], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md][50], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][51], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][52], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][53], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md][54], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][55], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md][58], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][59], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][60], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][61], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md][62], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][63], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][64], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][65], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md][66], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][67], in the cell docs × markdown:
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 28 (text) and line 28 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][68], in the cell docs × markdown:
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][69], in the cell docs × markdown:
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 33 (text), line 288 (text), line 786 (text), line 806 (text),
  line 818 (text), line 847 (text), line 949 (text), line 951 (text), line 953 (text), line 955 (text), line 957 (text), line 959 (text),
  line 961 (text), line 963 (text), line 965 (text) and line 1000 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][70], in the cell docs × markdown:
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 8 (text), line 117 (text), line 465 (text), line 493 (text), line 501 (text),
  line 539 (text), line 703 (text), line 1078 (text), line 1080 (text), line 1082 (text), line 1084 (text), line 1086 (text), line 1088
  (text), line 1090 (text), line 1248 (text), line 1293 (text) and line 1333 (text).
- [docs/explanation/automation/build-then-place-with-one-command.md][71], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][72], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][73], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][74], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][75], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 47
  (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][76], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][77], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it
  at line 15 (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][78], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 45 (text) and line 68 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line
  41 (text), line 51 (text), line 66 (text), line 69 (text) and line 73 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line
  33 (text) and line 61 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 62 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 33 (text), line 44 (text), line 60 (text) and line 67 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][79], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][80], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text)
  and line 61 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text)
  and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][81], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 17 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][82], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][83], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 17 (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][84], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 14 (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][85], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line
  61 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][86], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 32 (text).
- [docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md][87], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 30 (text).
- [docs/how-to/getting-started/automation/add-a-doc-chapter.md][88], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 72 (text).
- [docs/how-to/getting-started/automation/powershell/add-a-function.md][89], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 111 (text), line 114 (text), line 120 (text) and line 121 (text).
- [docs/references/automation/catzc-base-languages.md][90], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 10 (text).
- [docs/references/automation/catzc-base-rootconfig.md][91], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 43 (text) and line 52 (text).
- [docs/references/automation/catzc-base-typessystem.md][92], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 37 (text).
- [docs/references/automation/internal/catzc-internal-importer.md][93], in the cell docs × markdown: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 36 (text).

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][94], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/BCL/native-csharp-types.md][2], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][95], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][96], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/caching.md][97], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/console-output-matters.md][98], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][99], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][100], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/cross-platform.md][101], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][102], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dora-explains.md][103], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/dry-run.md][104], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/effective-in-enterprises.md][105], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/environment-variables.md][106], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/execution-engines.md][107], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][108], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/go/index.md][109], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of that
  code.
- [docs/adr/automation/go/test-artifacts.md][110], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][111], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][112], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][113], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/managed-guids.md][114], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][115], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/open-closed-architecture.md][116], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/path-representation.md][117], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/protected-globs.md][118], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/python/index.md][119], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR domain of
  that code.
- [docs/adr/automation/python/python-test-artifacts.md][120], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][121], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/sensible-defaults.md][122], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][123], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain,
  the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][124], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/test-automation.md][125], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][126], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][127], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][128], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the
  ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][129], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][130], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code; selected by [ADR-AUTO-TYPES][2]: an ADR file of the `automation` ADR domain, the ADR
  domain of that code.

### adr/pwsh (26 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/announce-state-changes.md][131], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/assert-idioms.md][132], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][133], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][134], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/cross-platform-powershell.md][135], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dora-explains.md][136], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][137], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/environment-variable-mechanics.md][138], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/error-handling.md][5], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][139], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/identifier-names.md][140], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][141], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][142], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/one-function-per-file.md][143], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/parameter-design.md][144], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][145], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][146], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][147], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][148], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][149], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pwsh-engine.md][150], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR domain,
  the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][151], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/script-scope-caching.md][152], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][153], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][154], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/working-directory-mechanics.md][155], in the cell docs × markdown: selected by [ADR-PWSH-ERROR][5]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code.

### Docs (22 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/Build-AdrIndex.ps1][156], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file cites
  it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1][157], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 21 (header).
- [automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1][158], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 3 (header) and line 24 (header).
- [automation/Catzc.Base.Docs/configs/adrs.yml][159], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 162 (text); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 167 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites
  it at line 101 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 56 (text); selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 192 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 313 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][160], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1][161], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (text).
- [automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1][162], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 1 (text).
- [automation/Catzc.Base.Docs/types/AdrCitationChange.cs][163], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs][164], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrCitationMap.cs][165], in the cell automation × csharp: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 60 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs][166], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Docs/types/AdrDomain.cs][167], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Base.Docs/types/AdrDomainEdge.cs][168], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Docs/types/AdrRuleSet.cs][169], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header) and line 7 (header).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][170], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Docs/types/AgentEntry.cs][171], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Docs/types/AgentsConfig.cs][172], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryAvoid.cs][173], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][174], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.Docs/types/GlossaryEntry.cs][175], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Docs/types/GlossaryOptions.cs][176], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).
- [automation/Catzc.Base.Docs/types/GlossaryRealization.cs][177], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 8 (header).

### QualityGates (20 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][178], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the
  file cites it at line 65 (header), line 117 (header) and line 117 (header).
- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][179], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][180], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml][181], in the cell automation × yaml: selected by [ADR-PWSH-ERROR][5]:
  the file cites it at line 18 (text), line 18 (body comment) and line 35 (text).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][182], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 590 (text); selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 570 (text); selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 610 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1][183], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1][184], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 7 (header) and line 19 (header).
- [automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1][185], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 81 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1][186], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 37 (text) and line 37 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][187], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][188], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (header) and line 6 (text).
- [automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1][189], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 29 (text) and line 80 (text).
- [automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1][190], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 35 (text) and line 36 (text).
- [automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs][191], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 81 (text).
- [automation/Catzc.Base.QualityGates/types/GuidsConfig.cs][192], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/types/LinksConfig.cs][193], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs][194], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs][195], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/types/SpellingOracle.cs][196], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs][197], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).

### Maps (16 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/types/CitationSite.cs][198], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/HighlightReason.cs][199], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/HighlightedCell.cs][200], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapCell.cs][201], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 7 (header).
- [automation/Catzc.Base.Maps/types/MapPlacement.cs][202], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsConfig.cs][203], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Base.Maps/types/MapsHighlight.cs][204], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).
- [automation/Catzc.Base.Maps/types/MapsLabels.cs][205], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 14 (header).
- [automation/Catzc.Base.Maps/types/MapsLimits.cs][206], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPalette.cs][207], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 4 (header).
- [automation/Catzc.Base.Maps/types/MapsPin.cs][208], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Base.Maps/types/TreemapRect.cs][209], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Maps/types/ValueChainCell.cs][210], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Maps/types/ValueChainReason.cs][211], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Maps/types/WorldMapBuilder.cs][212], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 25 (header).
- [automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs][213], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 10 (header).

### ModuleSystem (16 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][214], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 29 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][215], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][216], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][217], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][218], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][219], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][220], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 23 (header) and line 109 (body comment); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 17
  (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][221], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 21 (header).
- [automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1][222], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 35 (text) and line 113 (text).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs][223], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs][224], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/types/BaseModule.cs][225], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs][226], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs][227], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs][228], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).
- [automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs][229], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header).

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][230], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][231], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][232], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][233], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][234], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][235], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][236], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][237], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][238], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][6], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][239], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][240], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][241], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][242], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][243], in the cell docs × markdown: selected by [ADR-REPO-ROOTCFG][6]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### Languages (12 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/New-GoWorkspace.ps1][244], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 25 (header).
- [automation/Catzc.Base.Languages/types/BashConfig.cs][245], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/BashTestResult.cs][246], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FileLanguage.cs][247], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/FormatterEngine.cs][248], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][249], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 7 (header).
- [automation/Catzc.Base.Languages/types/GoTestResult.cs][250], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs][251], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 2 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Languages/types/LanguagesConfig.cs][252], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][253], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Languages/types/PythonTestResult.cs][254], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs][255], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 3 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 4 (header).

### VSCode (12 lit files)

The group holds the files of automation/Catzc.Base.VSCode; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1][256], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1][257], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 14 (header).
- [automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1][258], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 18 (header).
- [automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1][259], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 20 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-extensions.yml][260], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-launch.yml][261], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml][262], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.VSCode/configs/vscode-settings.yml][263], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs][264], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs][265], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 2 (header).
- [automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs][266], in the cell automation × csharp: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).
- [automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs][267], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 9 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 3 (header).

### Exporter (11 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][268], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][269], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][270], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][271], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][272], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 14 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][273], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][274], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][275], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][276], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][277], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header); selected by [ADR-AUTO-TYPES][2]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterPackage.cs][278], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Azure (9 lit files)

The group holds the files of automation/Catzc.Azure; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure/types/AzureConfig.cs][279], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 5 (header).
- [automation/Catzc.Azure/types/AzureCustomer.cs][280], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/AzureEnvironmentRecord.cs][281], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/AzureSubscriptionRecord.cs][282], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Azure/types/AzureTenantRecord.cs][283], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 3 (header).
- [automation/Catzc.Azure/types/CustomerConfig.cs][284], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 5 (header).
- [automation/Catzc.Azure/types/NetworkConfig.cs][285], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites it
  at line 6 (header).
- [automation/Catzc.Azure/types/NetworkEnvironment.cs][286], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).
- [automation/Catzc.Azure/types/NetworkSubscription.cs][287], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 3 (header).

### TypesSystem (9 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1][288], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][289], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][290], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 12 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][291], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][292], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][293], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 19 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 22 (header).
- [automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1][294], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1][295], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 4 (text).
- [automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1][296], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][297], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][298], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][299], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][3], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][300], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][301], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][302], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][303], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][304], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][3]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### RootConfig (8 lit files)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][305], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 24 (header); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 21 (header).
- [automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1][306], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 6 (header).
- [automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1][307], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.RootConfig/configs/rootconfig.yml][308], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1][309], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 16 (header).
- [automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1][310], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 8 (header).
- [automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1][311], in the cell automation × powershell: selected by
  [ADR-REPO-ROOTCFG][6]: the file cites it at line 12 (header).
- [automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs][312], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the
  file cites it at line 6 (header).

### adr/prin (7 lit files)

The group holds the files of docs/adr/principles; each sits in its world-map cell and is lit by:

- [docs/adr/principles/configure-not-program.md][313], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/dora-explains.md][314], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/everything-as-code.md][315], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/one-living-version.md][4], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/poka-yoke.md][316], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the `principles`
  ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-variability.md][317], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.
- [docs/adr/principles/reduce-waste.md][318], in the cell docs × markdown: selected by [ADR-PRIN-ONELIVE][4]: an ADR file of the
  `principles` ADR domain, the ADR domain of that code.

### Contracts (6 lit files)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][319], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).
- [automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1][320], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header) and line 23 (text).
- [automation/Catzc.Base.Contracts/types/ContractAsset.cs][321], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractCheckResult.cs][322], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 5 (header).
- [automation/Catzc.Base.Contracts/types/ContractManifest.cs][323], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header).
- [automation/Catzc.Base.Contracts/types/ContractsConfig.cs][324], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 12 (header).

### Az.Templates (5 lit files)

The group holds the files of automation/Catzc.Azure.Templates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.Templates/Build-Bicep.ps1][325], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 103 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/Deploy-Bicep.ps1][326], in the cell automation × powershell: selected by [ADR-PWSH-ERROR][5]: the file
  cites it at line 133 (body comment) (a passing mention only).
- [automation/Catzc.Azure.Templates/types/BicepParameter.cs][327], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 7 (header) and line 8 (header).
- [automation/Catzc.Azure.Templates/types/BicepParameterModel.cs][328], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Azure.Templates/types/BicepShortName.cs][329], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 11 (header).

### Repository (5 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][330], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][331], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][332], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/Get-SessionActor.ps1][333], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1][334], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 1 (text).

### .internal (4 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][335], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 5 (header).
- [automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1][336], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 4 (header) and line 9 (text).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][337], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 1 (text).
- [automation/.internal/tests/Restart-ImporterSession.Tests.ps1][338], in the cell automation × powershell: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 2 (header), line 17 (text), line 38 (text) and line 75 (text).

### Reports (4 lit files)

The group holds the files of automation/Catzc.Base.Reports; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Reports/types/OutputFormat.cs][339], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs][340], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Reports/types/OutputPattern.cs][341], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 67 (body comment) (a passing mention only).
- [automation/Catzc.Base.Reports/types/ReportsConfig.cs][342], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][343], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [.gitignore][344], in the cell Root files × Unlisted files: selected by [ADR-AUTO-TYPES][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Get-SessionActor.ps1` line 6 (header) and
  `automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1` line 1 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries
  the citations of its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8
  (header), `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and
  `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1` line 6 (header).
- [importer.ps1][345], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-AUTO-TYPES][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1` line 4 (header), `automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1`
  line 9 (text), `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 2 (header),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 17 (text),
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 38 (text) and
  `automation/.internal/tests/Restart-ImporterSession.Tests.ps1` line 75 (text); selected by [ADR-DSGN-RUNMODE][3]: a root file carries the
  citations of its owner module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and
  `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1 (text).

### Git (3 lit files)

The group holds the files of automation/Catzc.Base.Git; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Git/New-GitIgnore.ps1][346], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 17 (header).
- [automation/Catzc.Base.Git/configs/gitignore.yml][347], in the cell automation × yaml: selected by [ADR-REPO-ROOTCFG][6]: the file cites
  it at line 3 (header).
- [automation/Catzc.Base.Git/types/GitIgnoreConfig.cs][348], in the cell automation × csharp: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 6 (header).

### Variants (3 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/types/VariantAspect.cs][349], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).
- [automation/Catzc.Base.Variants/types/VariantTrack.cs][350], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][351], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 6 (header).

### Vendor (3 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][352], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][353], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the
  file cites it at line 18 (header).
- [automation/Catzc.Base.Vendor/types/VendorConfig.cs][354], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 5 (header).

### .claude (2 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][355], in the cell .claude × markdown: selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 57 (text) and line
  121 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 30 (text).
- [.claude/agents/build-inspiration-module.md][356], in the cell .claude × markdown: selected by [ADR-AUTO-TYPES][2]: the file cites it at
  line 25 (text).

### Az.DevOps.BuildValidation (2 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs][357], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs][358], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 3 (header).

### Files (2 lit files)

The group holds the files of automation/Catzc.Base.Files; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Files/Set-FileLink.ps1][359], in the cell automation × powershell: selected by [ADR-REPO-ROOTCFG][6]: the file
  cites it at line 17 (header).
- [automation/Catzc.Base.Files/Write-FileIfChanged.ps1][360], in the cell automation × powershell: selected by [ADR-PRIN-ONELIVE][4]: the
  file cites it at line 20 (header).

### Objects (2 lit files)

The group holds the files of automation/Catzc.Base.Objects; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1][361], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 5 (text).
- [automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1][362], in the cell automation × powershell: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (text).

### Timeouts (2 lit files)

The group holds the files of automation/Catzc.Base.Timeouts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs][363], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs][364], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 4 (header).

### Tool.Inspiration (2 lit files)

The group holds the files of automation/Catzc.Tooling.Inspiration; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs][365], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs][366], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 4 (header).

### Tool.KeyHandler (2 lit files)

The group holds the files of automation/Catzc.Tooling.KeyHandler; each sits in its world-map cell and is lit by:

- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs][367], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]:
  the file cites it at line 5 (header).
- [automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs][368], in the cell automation × csharp: selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 6 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][369], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### .scriptanalyzer (1 lit file)

The group holds the files of automation/.scriptanalyzer; each sits in its world-map cell and is lit by:

- [automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1][370], in the cell automation × powershell: selected by
  [ADR-PWSH-ERROR][5]: the file cites it at line 3 (text).

### Az.DevOps (1 lit file)

The group holds the files of automation/Catzc.Azure.DevOps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps/types/AdoConfig.cs][371], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file cites
  it at line 5 (header).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][372], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][3]: the file cites it at line 12 (header).

### Engines (1 lit file)

The group holds the files of automation/Catzc.Base.Engines; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Engines/types/ExecutionEngine.cs][373], in the cell automation × csharp: selected by [ADR-AUTO-TYPES][2]: the file
  cites it at line 9 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][374], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][3]: the file
  cites it at line 29 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][375], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by
  [ADR-AUTO-TYPES][2]: the file cites it at line 155 (text); selected by [ADR-DSGN-RUNMODE][3]: the file cites it at line 94 (text);
  selected by [ADR-PRIN-ONELIVE][4]: the file cites it at line 53 (text); selected by [ADR-PWSH-ERROR][5]: the file cites it at line 15
  (text) and line 178 (text); selected by [ADR-REPO-ROOTCFG][6]: the file cites it at line 292 (text).

## Keywords

- [world map][376]
- [track][377]
- [file language][378]
- [cell][379]
- [lit cell][380]
- [root file][381]
- [unlisted file][382]
- [.claude][383]: a track
- [.github][383]: a track
- [automation][383]: a track
- [docs][383]: a track
- [csharp][384]: a file language
- [markdown][384]: a file language
- [powershell][384]: a file language
- [yaml][384]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/automation/BCL/native-csharp-types.md
[3]: ../../adr/design/run-modes.md
[4]: ../../adr/principles/one-living-version.md
[5]: ../../adr/pwsh/error-handling.md
[6]: ../../adr/repository/generated-root-configs.md
[7]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[8]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[9]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[10]: adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
[11]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[12]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[13]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[14]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
[15]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[16]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[17]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[18]: adr-auto-bundle--dot-source-one-entry-script--operations.tree.md
[19]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[20]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[21]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[22]: adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
[23]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[24]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[25]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[26]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md
[27]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[28]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[29]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[30]: adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md
[31]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[32]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[33]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[34]: adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md
[35]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[36]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[37]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[38]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
[39]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[40]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[41]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[42]: adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
[43]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[44]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[45]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[46]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[47]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[48]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[49]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[50]: adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
[51]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[52]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[53]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[54]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
[55]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[56]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[57]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[58]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
[59]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[60]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[61]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[62]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
[63]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[64]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[65]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[66]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md
[67]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[68]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[69]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[70]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[71]: ../../explanation/automation/build-then-place-with-one-command.md
[72]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[73]: ../../explanation/automation/dot-source-one-entry-script.md
[74]: ../../explanation/automation/every-code-root-is-a-copy.md
[75]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[76]: ../../explanation/automation/invoke-importer-in-code-order.md
[77]: ../../explanation/automation/one-commit-one-immutable-package.md
[78]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[79]: ../../explanation/automation/two-entries-feed-one-importer.md
[80]: ../../explanation/automation/what-gates-each-bundle-stage.md
[81]: ../../explanation/design/one-entry-script-per-mode.md
[82]: ../../explanation/design/shims-set-roots-mode-read-back.md
[83]: ../../explanation/design/two-roots-one-importer-same-modules.md
[84]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[85]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[86]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[87]: ../../how-to/getting-started/automation/BCL/add-a-dotnet-type.md
[88]: ../../how-to/getting-started/automation/add-a-doc-chapter.md
[89]: ../../how-to/getting-started/automation/powershell/add-a-function.md
[90]: ../../references/automation/catzc-base-languages.md
[91]: ../../references/automation/catzc-base-rootconfig.md
[92]: ../../references/automation/catzc-base-typessystem.md
[93]: ../../references/automation/internal/catzc-internal-importer.md
[94]: ../../adr/automation/BCL/index.md
[95]: ../../adr/automation/avoid-deep-nesting.md
[96]: ../../adr/automation/bash/bash-test-artifacts.md
[97]: ../../adr/automation/caching.md
[98]: ../../adr/automation/console-output-matters.md
[99]: ../../adr/automation/controlling-module-dependencies.md
[100]: ../../adr/automation/controlling-systemwide-deps.md
[101]: ../../adr/automation/cross-platform.md
[102]: ../../adr/automation/devbox-pipeline-parity.md
[103]: ../../adr/automation/dora-explains.md
[104]: ../../adr/automation/dry-run.md
[105]: ../../adr/automation/effective-in-enterprises.md
[106]: ../../adr/automation/environment-variables.md
[107]: ../../adr/automation/execution-engines.md
[108]: ../../adr/automation/fail-fast-with-asserts.md
[109]: ../../adr/automation/go/index.md
[110]: ../../adr/automation/go/test-artifacts.md
[111]: ../../adr/automation/idempotent-state-functions.md
[112]: ../../adr/automation/internal-asset-dependencies.md
[113]: ../../adr/automation/log-before-invoke.md
[114]: ../../adr/automation/managed-guids.md
[115]: ../../adr/automation/never-depend-on-pwd.md
[116]: ../../adr/automation/open-closed-architecture.md
[117]: ../../adr/automation/path-representation.md
[118]: ../../adr/automation/protected-globs.md
[119]: ../../adr/automation/python/index.md
[120]: ../../adr/automation/python/python-test-artifacts.md
[121]: ../../adr/automation/retry-as-last-resort.md
[122]: ../../adr/automation/sensible-defaults.md
[123]: ../../adr/automation/single-responsibility-functions.md
[124]: ../../adr/automation/spell-out-names.md
[125]: ../../adr/automation/test-automation.md
[126]: ../../adr/automation/tool-removal-lifecycle.md
[127]: ../../adr/automation/tracked-files-from-the-index.md
[128]: ../../adr/automation/use-proper-package-managers.md
[129]: ../../adr/automation/uv-python-handler.md
[130]: ../../adr/automation/zero-ceremony-poka-yoke.md
[131]: ../../adr/pwsh/announce-state-changes.md
[132]: ../../adr/pwsh/assert-idioms.md
[133]: ../../adr/pwsh/automatic-variable-pitfalls.md
[134]: ../../adr/pwsh/avoid-using-semicolons.md
[135]: ../../adr/pwsh/cross-platform-powershell.md
[136]: ../../adr/pwsh/dora-explains.md
[137]: ../../adr/pwsh/dynamic-module-manifests.md
[138]: ../../adr/pwsh/environment-variable-mechanics.md
[139]: ../../adr/pwsh/hosting-csharp-types.md
[140]: ../../adr/pwsh/identifier-names.md
[141]: ../../adr/pwsh/index.md
[142]: ../../adr/pwsh/module-path-hygiene.md
[143]: ../../adr/pwsh/one-function-per-file.md
[144]: ../../adr/pwsh/parameter-design.md
[145]: ../../adr/pwsh/pester-testing.md
[146]: ../../adr/pwsh/powershell-formatting.md
[147]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[148]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[149]: ../../adr/pwsh/prepost-extension-modules.md
[150]: ../../adr/pwsh/pwsh-engine.md
[151]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[152]: ../../adr/pwsh/script-scope-caching.md
[153]: ../../adr/pwsh/use-ps1-not-psm1.md
[154]: ../../adr/pwsh/vendor-toolset-dependencies.md
[155]: ../../adr/pwsh/working-directory-mechanics.md
[156]: ../../../automation/Catzc.Base.Docs/Build-AdrIndex.ps1
[157]: ../../../automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1
[158]: ../../../automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1
[159]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[160]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[161]: ../../../automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1
[162]: ../../../automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1
[163]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChange.cs
[164]: ../../../automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
[165]: ../../../automation/Catzc.Base.Docs/types/AdrCitationMap.cs
[166]: ../../../automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
[167]: ../../../automation/Catzc.Base.Docs/types/AdrDomain.cs
[168]: ../../../automation/Catzc.Base.Docs/types/AdrDomainEdge.cs
[169]: ../../../automation/Catzc.Base.Docs/types/AdrRuleSet.cs
[170]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[171]: ../../../automation/Catzc.Base.Docs/types/AgentEntry.cs
[172]: ../../../automation/Catzc.Base.Docs/types/AgentsConfig.cs
[173]: ../../../automation/Catzc.Base.Docs/types/GlossaryAvoid.cs
[174]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[175]: ../../../automation/Catzc.Base.Docs/types/GlossaryEntry.cs
[176]: ../../../automation/Catzc.Base.Docs/types/GlossaryOptions.cs
[177]: ../../../automation/Catzc.Base.Docs/types/GlossaryRealization.cs
[178]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[179]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[180]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[181]: ../../../automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml
[182]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[183]: ../../../automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
[184]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
[185]: ../../../automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1
[186]: ../../../automation/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
[187]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[188]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[189]: ../../../automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1
[190]: ../../../automation/Catzc.Base.QualityGates/tests/types/AnalyzerAdrMapConfig.Tests.ps1
[191]: ../../../automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
[192]: ../../../automation/Catzc.Base.QualityGates/types/GuidsConfig.cs
[193]: ../../../automation/Catzc.Base.QualityGates/types/LinksConfig.cs
[194]: ../../../automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
[195]: ../../../automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
[196]: ../../../automation/Catzc.Base.QualityGates/types/SpellingOracle.cs
[197]: ../../../automation/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
[198]: ../../../automation/Catzc.Base.Maps/types/CitationSite.cs
[199]: ../../../automation/Catzc.Base.Maps/types/HighlightReason.cs
[200]: ../../../automation/Catzc.Base.Maps/types/HighlightedCell.cs
[201]: ../../../automation/Catzc.Base.Maps/types/MapCell.cs
[202]: ../../../automation/Catzc.Base.Maps/types/MapPlacement.cs
[203]: ../../../automation/Catzc.Base.Maps/types/MapsConfig.cs
[204]: ../../../automation/Catzc.Base.Maps/types/MapsHighlight.cs
[205]: ../../../automation/Catzc.Base.Maps/types/MapsLabels.cs
[206]: ../../../automation/Catzc.Base.Maps/types/MapsLimits.cs
[207]: ../../../automation/Catzc.Base.Maps/types/MapsPalette.cs
[208]: ../../../automation/Catzc.Base.Maps/types/MapsPin.cs
[209]: ../../../automation/Catzc.Base.Maps/types/TreemapRect.cs
[210]: ../../../automation/Catzc.Base.Maps/types/ValueChainCell.cs
[211]: ../../../automation/Catzc.Base.Maps/types/ValueChainReason.cs
[212]: ../../../automation/Catzc.Base.Maps/types/WorldMapBuilder.cs
[213]: ../../../automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs
[214]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[215]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[216]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[217]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[218]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[219]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[220]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[221]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[222]: ../../../automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
[223]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
[224]: ../../../automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
[225]: ../../../automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
[226]: ../../../automation/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
[227]: ../../../automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs
[228]: ../../../automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs
[229]: ../../../automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
[230]: ../../adr/repository/agent-definitions.md
[231]: ../../adr/repository/api-contracts.md
[232]: ../../adr/repository/controlled-vocabulary.md
[233]: ../../adr/repository/conventional-folders.md
[234]: ../../adr/repository/dedicated-output-directory.md
[235]: ../../adr/repository/documentation-examples.md
[236]: ../../adr/repository/domain-language-separation.md
[237]: ../../adr/repository/dora-explains.md
[238]: ../../adr/repository/generated-readmes.md
[239]: ../../adr/repository/inspiration.md
[240]: ../../adr/repository/markdown-links.md
[241]: ../../adr/repository/output-formats.md
[242]: ../../adr/repository/repo-variants.md
[243]: ../../adr/repository/uniform-formatting.md
[244]: ../../../automation/Catzc.Base.Languages/New-GoWorkspace.ps1
[245]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[246]: ../../../automation/Catzc.Base.Languages/types/BashTestResult.cs
[247]: ../../../automation/Catzc.Base.Languages/types/FileLanguage.cs
[248]: ../../../automation/Catzc.Base.Languages/types/FormatterEngine.cs
[249]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[250]: ../../../automation/Catzc.Base.Languages/types/GoTestResult.cs
[251]: ../../../automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
[252]: ../../../automation/Catzc.Base.Languages/types/LanguagesConfig.cs
[253]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[254]: ../../../automation/Catzc.Base.Languages/types/PythonTestResult.cs
[255]: ../../../automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs
[256]: ../../../automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
[257]: ../../../automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
[258]: ../../../automation/Catzc.Base.VSCode/New-VSCodePipelineSchema.ps1
[259]: ../../../automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
[260]: ../../../automation/Catzc.Base.VSCode/configs/vscode-extensions.yml
[261]: ../../../automation/Catzc.Base.VSCode/configs/vscode-launch.yml
[262]: ../../../automation/Catzc.Base.VSCode/configs/vscode-pipeline-schema.yml
[263]: ../../../automation/Catzc.Base.VSCode/configs/vscode-settings.yml
[264]: ../../../automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
[265]: ../../../automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
[266]: ../../../automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
[267]: ../../../automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
[268]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[269]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[270]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[271]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[272]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[273]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[274]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[275]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[276]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[277]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[278]: ../../../automation/Catzc.Base.Exporter/types/ExporterPackage.cs
[279]: ../../../automation/Catzc.Azure/types/AzureConfig.cs
[280]: ../../../automation/Catzc.Azure/types/AzureCustomer.cs
[281]: ../../../automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
[282]: ../../../automation/Catzc.Azure/types/AzureSubscriptionRecord.cs
[283]: ../../../automation/Catzc.Azure/types/AzureTenantRecord.cs
[284]: ../../../automation/Catzc.Azure/types/CustomerConfig.cs
[285]: ../../../automation/Catzc.Azure/types/NetworkConfig.cs
[286]: ../../../automation/Catzc.Azure/types/NetworkEnvironment.cs
[287]: ../../../automation/Catzc.Azure/types/NetworkSubscription.cs
[288]: ../../../automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1
[289]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[290]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[291]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[292]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[293]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[294]: ../../../automation/Catzc.Base.TypesSystem/Test-LoadedTypesCurrent.ps1
[295]: ../../../automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
[296]: ../../../automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
[297]: ../../adr/design/commit-lifecycle.md
[298]: ../../adr/design/dora-explains.md
[299]: ../../adr/design/module-aspects.md
[300]: ../../adr/design/self-service.md
[301]: ../../adr/design/server-remote-integration.md
[302]: ../../adr/design/thin-platforms.md
[303]: ../../adr/design/tracks.md
[304]: ../../adr/design/visual-design.md
[305]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[306]: ../../../automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
[307]: ../../../automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
[308]: ../../../automation/Catzc.Base.RootConfig/configs/rootconfig.yml
[309]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
[310]: ../../../automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
[311]: ../../../automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
[312]: ../../../automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
[313]: ../../adr/principles/configure-not-program.md
[314]: ../../adr/principles/dora-explains.md
[315]: ../../adr/principles/everything-as-code.md
[316]: ../../adr/principles/poka-yoke.md
[317]: ../../adr/principles/reduce-variability.md
[318]: ../../adr/principles/reduce-waste.md
[319]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[320]: ../../../automation/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
[321]: ../../../automation/Catzc.Base.Contracts/types/ContractAsset.cs
[322]: ../../../automation/Catzc.Base.Contracts/types/ContractCheckResult.cs
[323]: ../../../automation/Catzc.Base.Contracts/types/ContractManifest.cs
[324]: ../../../automation/Catzc.Base.Contracts/types/ContractsConfig.cs
[325]: ../../../automation/Catzc.Azure.Templates/Build-Bicep.ps1
[326]: ../../../automation/Catzc.Azure.Templates/Deploy-Bicep.ps1
[327]: ../../../automation/Catzc.Azure.Templates/types/BicepParameter.cs
[328]: ../../../automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
[329]: ../../../automation/Catzc.Azure.Templates/types/BicepShortName.cs
[330]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[331]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[332]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[333]: ../../../automation/Catzc.Base.Repository/Get-SessionActor.ps1
[334]: ../../../automation/Catzc.Base.Repository/tests/Get-SessionActor.Tests.ps1
[335]: ../../../automation/.internal/assets/Import-Catzc.ps1
[336]: ../../../automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1
[337]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[338]: ../../../automation/.internal/tests/Restart-ImporterSession.Tests.ps1
[339]: ../../../automation/Catzc.Base.Reports/types/OutputFormat.cs
[340]: ../../../automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs
[341]: ../../../automation/Catzc.Base.Reports/types/OutputPattern.cs
[342]: ../../../automation/Catzc.Base.Reports/types/ReportsConfig.cs
[343]: ../../../.gitattributes
[344]: ../../../.gitignore
[345]: ../../../importer.ps1
[346]: ../../../automation/Catzc.Base.Git/New-GitIgnore.ps1
[347]: ../../../automation/Catzc.Base.Git/configs/gitignore.yml
[348]: ../../../automation/Catzc.Base.Git/types/GitIgnoreConfig.cs
[349]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[350]: ../../../automation/Catzc.Base.Variants/types/VariantTrack.cs
[351]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[352]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[353]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[354]: ../../../automation/Catzc.Base.Vendor/types/VendorConfig.cs
[355]: ../../../.claude/CLAUDE.md
[356]: ../../../.claude/agents/build-inspiration-module.md
[357]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs
[358]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs
[359]: ../../../automation/Catzc.Base.Files/Set-FileLink.ps1
[360]: ../../../automation/Catzc.Base.Files/Write-FileIfChanged.ps1
[361]: ../../../automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
[362]: ../../../automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
[363]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
[364]: ../../../automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
[365]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
[366]: ../../../automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs
[367]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerBinding.cs
[368]: ../../../automation/Catzc.Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs
[369]: ../../../.github/workflows/ci-automation.yml
[370]: ../../../automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1
[371]: ../../../automation/Catzc.Azure.DevOps/types/AdoConfig.cs
[372]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[373]: ../../../automation/Catzc.Base.Engines/types/ExecutionEngine.cs
[374]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[375]: ../../adr/index.md
[376]: ../../adr/glossary.md#world-map
[377]: ../../adr/glossary.md#track
[378]: ../../adr/glossary.md#file-language
[379]: ../../adr/glossary.md#cell
[380]: ../../adr/glossary.md#lit-cell
[381]: ../../adr/glossary.md#root-file
[382]: ../../adr/glossary.md#unlisted-file
[383]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[384]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
