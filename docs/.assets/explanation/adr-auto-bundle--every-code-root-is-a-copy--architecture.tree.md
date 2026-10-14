# docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md

`Tree minimap: adr-auto-bundle--every-code-root-is-a-copy--architecture`

![Tree minimap of adr-auto-bundle--every-code-root-is-a-copy--architecture](adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.png)

The tree minimap of the slide `adr-auto-bundle--every-code-root-is-a-copy--architecture` (architecture lens). The slide supports
[ADR-AUTO-BUNDLE][1] and [ADR-DSGN-RUNMODE][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code
that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 169 files in 18 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 75 lit files
- adr/auto (docs/adr/automation): 39 lit files
- Exporter (automation/Catzc.Base.Exporter): 10 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 8 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 5 lit files
- TypesSystem (automation/Catzc.Base.TypesSystem): 5 lit files
- Root files: 3 lit files
- Repository (automation/Catzc.Base.Repository): 3 lit files
- .internal (automation/.internal): 2 lit files
- Docs (automation/Catzc.Base.Docs): 2 lit files
- Vendor (automation/Catzc.Base.Vendor): 2 lit files
- .github: 1 lit file
- ConfigExtensions (automation/Catzc.Base.ConfigExtensions): 1 lit file
- Contracts (automation/Catzc.Base.Contracts): 1 lit file
- Globs (automation/Catzc.Base.Globs): 1 lit file
- RootConfig (automation/Catzc.Base.RootConfig): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (75 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md][3], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md][4], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md][5], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md][6], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md][7], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md][9], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md][10], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.chain.md][11], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md][12], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.grid.md][13], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.tree.md][14], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md][15], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md][16], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 70 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md][17], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 31 (text), line 39 (text), line 40 (text), line 47 (text), line 52 (text),
  line 55 (text), line 56 (text), line 58 (text), line 59 (text), line 60 (text), line 62 (text), line 105 (text), line 107 (text), line 115
  (text), line 118 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 132
  (text), line 134 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line 155 (text), line 157 (text), line 159
  (text), line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 171 (text), line 173 (text), line 175
  (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 189 (text), line 191
  (text), line 193 (text), line 195 (text), line 197 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207
  (text), line 209 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223
  (text), line 241 (text), line 243 (text), line 245 (text), line 247 (text), line 249 (text), line 252 (text), line 254 (text), line 256
  (text), line 259 (text), line 262 (text), line 264 (text) and line 283 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 8 (text), line 48 (text), line 49 (text), line 50 (text), line 54 (text), line 64 (text), line 65 (text), line 66 (text), line 68
  (text), line 69 (text), line 71 (text), line 73 (text), line 74 (text), line 75 (text), line 77 (text), line 78 (text), line 79 (text),
  line 81 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 98 (text), line 106 (text), line 108 (text), line 122 (text), line 128 (text), line 130
  (text), line 135 (text), line 137 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 225 (text), line 227
  (text), line 229 (text), line 231 (text), line 232 (text), line 234 (text), line 236 (text), line 238 (text), line 239 (text), line 241
  (text), line 250 (text), line 253 (text), line 257 (text), line 260 (text), line 266 (text), line 267 (text), line 269 (text), line 271
  (text), line 273 (text), line 275 (text), line 284 (text), line 293 (text) and line 297 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md][18], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 67
  (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text),
  line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101
  (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 117
  (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 137 (text), line 139
  (text), line 142 (text), line 144 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 165 (text), line 168
  (text), line 170 (text), line 173 (text), line 176 (text), line 178 (text), line 198 (text), line 200 (text), line 202 (text), line 204
  (text), line 206 (text), line 208 (text), line 211 (text), line 212 (text), line 214 (text), line 303 (text), line 324 (text), line 333
  (text), line 351 (text), line 365 (text) and line 386 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line
  131 (text), line 137 (text), line 139 (text), line 144 (text), line 147 (text), line 149 (text), line 151 (text), line 153 (text), line
  155 (text), line 164 (text), line 166 (text), line 171 (text), line 175 (text), line 180 (text), line 182 (text), line 184 (text), line
  186 (text), line 188 (text), line 190 (text), line 221 (text), line 223 (text), line 225 (text), line 227 (text), line 229 (text), line
  231 (text), line 233 (text), line 235 (text), line 237 (text), line 244 (text), line 247 (text), line 248 (text), line 251 (text), line
  253 (text), line 254 (text), line 256 (text), line 259 (text), line 265 (text), line 267 (text), line 269 (text), line 272 (text), line
  274 (text), line 281 (text), line 283 (text), line 285 (text), line 287 (text), line 289 (text), line 295 (text), line 299 (text), line
  305 (text), line 313 (text), line 315 (text), line 317 (text), line 325 (text), line 327 (text), line 334 (text), line 335 (text), line
  342 (text), line 344 (text), line 359 (text), line 372 (text), line 379 (text) and line 387 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md][19], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md][20], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 60 (text).
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md][21], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md][22], in the cell docs × markdown: selected by
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
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md][23], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md][24], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 61 (text).
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md][25], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md][26], in the cell docs × markdown:
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
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md][27], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 44 (text), line 52 (text) and line 52 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md][28], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 69 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md][29], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (text), line 30 (text), line 38 (text), line 39 (text), line 46 (text), line 51 (text),
  line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 61 (text), line 104 (text), line 106 (text), line 114
  (text), line 117 (text), line 118 (text), line 120 (text), line 122 (text), line 124 (text), line 126 (text), line 128 (text), line 131
  (text), line 133 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line 154 (text), line 156 (text), line 158
  (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 168 (text), line 170 (text), line 172 (text), line 174
  (text), line 176 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 186 (text), line 188 (text), line 190
  (text), line 192 (text), line 194 (text), line 196 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 206
  (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 218 (text), line 220 (text), line 222
  (text), line 240 (text), line 242 (text), line 244 (text), line 246 (text), line 248 (text), line 251 (text), line 253 (text), line 255
  (text), line 258 (text), line 261 (text), line 263 (text) and line 282 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 8 (text), line 47 (text), line 48 (text), line 49 (text), line 53 (text), line 63 (text), line 64 (text), line 65 (text), line 67
  (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 74 (text), line 76 (text), line 77 (text), line 78 (text),
  line 80 (text), line 82 (text), line 83 (text), line 84 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 94 (text), line 96 (text), line 97 (text), line 105 (text), line 107 (text), line 121 (text), line 127 (text), line 129
  (text), line 134 (text), line 136 (text), line 139 (text), line 141 (text), line 143 (text), line 145 (text), line 224 (text), line 226
  (text), line 228 (text), line 230 (text), line 231 (text), line 233 (text), line 235 (text), line 237 (text), line 238 (text), line 240
  (text), line 249 (text), line 252 (text), line 256 (text), line 259 (text), line 265 (text), line 266 (text), line 268 (text), line 270
  (text), line 272 (text), line 274 (text), line 283 (text), line 292 (text) and line 296 (text).
- [docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md][30], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (text), line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text),
  line 50 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66
  (text), line 68 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 100
  (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138
  (text), line 141 (text), line 143 (text), line 155 (text), line 157 (text), line 159 (text), line 161 (text), line 164 (text), line 167
  (text), line 169 (text), line 172 (text), line 175 (text), line 177 (text), line 197 (text), line 199 (text), line 201 (text), line 203
  (text), line 205 (text), line 207 (text), line 210 (text), line 211 (text), line 213 (text), line 302 (text), line 323 (text), line 332
  (text), line 350 (text), line 364 (text) and line 385 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line
  130 (text), line 136 (text), line 138 (text), line 143 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 163 (text), line 165 (text), line 170 (text), line 174 (text), line 179 (text), line 181 (text), line 183 (text), line
  185 (text), line 187 (text), line 189 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 228 (text), line
  230 (text), line 232 (text), line 234 (text), line 236 (text), line 243 (text), line 246 (text), line 247 (text), line 250 (text), line
  252 (text), line 253 (text), line 255 (text), line 258 (text), line 264 (text), line 266 (text), line 268 (text), line 271 (text), line
  273 (text), line 280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 294 (text), line 298 (text), line
  304 (text), line 312 (text), line 314 (text), line 316 (text), line 324 (text), line 326 (text), line 333 (text), line 334 (text), line
  341 (text), line 343 (text), line 358 (text), line 371 (text), line 378 (text) and line 386 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md][31], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 68 (text), line 68 (text), line 79 (text) and line 79 (text); selected
  by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 38 (text), line 38 (text), line 46 (text) and line 46 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md][32], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 56 (text) and line 63 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 56 (text) and line 64 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md][33], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 41 (text), line 90 (text), line 92 (text), line 178 (text), line 192
  (text), line 205 (text), line 206 (text), line 208 (text), line 209 (text), line 210 (text), line 212 (text), line 309 (text), line 313
  (text), line 334 (text), line 336 (text), line 337 (text), line 339 (text), line 341 (text), line 344 (text), line 345 (text), line 347
  (text), line 352 (text), line 354 (text), line 369 (text), line 371 (text), line 373 (text), line 375 (text), line 377 (text), line 379
  (text), line 381 (text), line 384 (text), line 386 (text), line 388 (text), line 390 (text), line 392 (text), line 394 (text), line 396
  (text), line 398 (text), line 400 (text), line 402 (text), line 404 (text), line 406 (text), line 408 (text), line 410 (text), line 412
  (text), line 414 (text), line 416 (text), line 418 (text), line 420 (text), line 422 (text), line 424 (text), line 426 (text), line 428
  (text), line 430 (text), line 432 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 443 (text), line 445
  (text), line 447 (text), line 465 (text), line 560 (text), line 562 (text), line 564 (text), line 566 (text), line 569 (text), line 571
  (text), line 573 (text), line 576 (text), line 582 (text), line 584 (text) and line 616 (text); selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 8 (text), line 179 (text), line 182 (text), line 190 (text), line 201 (text), line 217 (text), line 220 (text), line
  221 (text), line 224 (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 242 (text), line
  244 (text), line 253 (text), line 255 (text), line 261 (text), line 262 (text), line 263 (text), line 267 (text), line 280 (text), line
  283 (text), line 284 (text), line 286 (text), line 289 (text), line 301 (text), line 302 (text), line 310 (text), line 317 (text), line
  340 (text), line 346 (text), line 349 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 364 (text), line
  366 (text), line 449 (text), line 451 (text), line 453 (text), line 455 (text), line 456 (text), line 458 (text), line 460 (text), line
  462 (text), line 463 (text), line 466 (text), line 567 (text), line 570 (text), line 574 (text), line 578 (text), line 586 (text), line
  587 (text), line 589 (text), line 591 (text), line 593 (text), line 595 (text), line 623 (text), line 634 (text) and line 640 (text).
- [docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md][34], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 62 (text), line 65 (text), line 68 (text), line 71 (text), line 74 (text),
  line 77 (text), line 80 (text), line 83 (text), line 86 (text), line 89 (text), line 92 (text), line 95 (text), line 98 (text), line 101
  (text), line 104 (text), line 107 (text), line 110 (text), line 113 (text), line 116 (text), line 119 (text), line 122 (text), line 125
  (text), line 128 (text), line 131 (text), line 134 (text), line 137 (text), line 140 (text), line 143 (text), line 146 (text), line 149
  (text), line 152 (text), line 155 (text), line 158 (text), line 161 (text), line 164 (text), line 167 (text), line 170 (text), line 173
  (text), line 176 (text), line 185 (text), line 187 (text), line 189 (text), line 191 (text), line 193 (text), line 195 (text), line 197
  (text), line 199 (text), line 204 (text), line 206 (text), line 220 (text), line 222 (text), line 224 (text), line 226 (text), line 229
  (text), line 232 (text), line 234 (text), line 237 (text), line 243 (text), line 245 (text), line 344 (text), line 603 (text), line 605
  (text), line 607 (text), line 609 (text), line 612 (text), line 613 (text), line 616 (text), line 617 (text), line 619 (text), line 737
  (text), line 784 (text), line 822 (text), line 933 (text) and line 975 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 8 (text), line 191 (text), line 197 (text), line 200 (text), line 206 (text), line 209 (text), line 211 (text), line 213 (text), line
  215 (text), line 217 (text), line 228 (text), line 230 (text), line 235 (text), line 239 (text), line 247 (text), line 249 (text), line
  251 (text), line 253 (text), line 255 (text), line 257 (text), line 345 (text), line 348 (text), line 391 (text), line 393 (text), line
  397 (text), line 409 (text), line 411 (text), line 473 (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line
  482 (text), line 485 (text), line 488 (text), line 654 (text), line 656 (text), line 658 (text), line 660 (text), line 662 (text), line
  674 (text), line 676 (text), line 678 (text), line 680 (text), line 682 (text), line 684 (text), line 686 (text), line 688 (text), line
  690 (text), line 697 (text), line 769 (text), line 771 (text), line 773 (text), line 785 (text), line 789 (text), line 812 (text), line
  818 (text), line 829 (text), line 859 (text), line 861 (text), line 955 (text), line 968 (text) and line 976 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md][35], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md][36], in the cell docs × markdown:
  selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md][37], in the cell docs × markdown: selected
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
- [docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md][38], in the cell docs × markdown: selected
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
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md][39], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 57 (text), line 57 (text), line 73 (text) and line 73 (text); selected
  by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 30 (text), line 30 (text), line 38 (text) and line 38 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][40], in the cell docs × markdown: selected
  by [ADR-AUTO-BUNDLE][1]: the file cites it at line 67 (text) and line 74 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at
  line 67 (text) and line 74 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md][41], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 71 (text), line 181 (text),
  line 278 (text), line 279 (text), line 281 (text), line 282 (text), line 283 (text), line 285 (text), line 763 (text), line 773 (text),
  line 794 (text), line 796 (text), line 797 (text), line 799 (text), line 801 (text), line 804 (text), line 805 (text), line 807 (text),
  line 810 (text), line 812 (text), line 836 (text), line 839 (text), line 842 (text), line 845 (text), line 848 (text), line 851 (text),
  line 854 (text), line 857 (text), line 860 (text), line 863 (text), line 866 (text), line 869 (text), line 872 (text), line 875 (text),
  line 878 (text), line 881 (text), line 884 (text), line 887 (text), line 890 (text), line 893 (text), line 896 (text), line 899 (text),
  line 902 (text), line 905 (text), line 908 (text), line 911 (text), line 914 (text), line 917 (text), line 920 (text), line 923 (text),
  line 926 (text), line 929 (text), line 932 (text), line 935 (text), line 938 (text), line 941 (text), line 944 (text), line 947 (text),
  line 950 (text), line 971 (text), line 974 (text), line 977 (text), line 979 (text), line 981 (text), line 984 (text), line 986 (text),
  line 988 (text), line 991 (text), line 994 (text), line 999 (text) and line 1050 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites
  it at line 8 (text), line 72 (text), line 77 (text), line 176 (text), line 200 (text), line 295 (text), line 351 (text), line 352 (text),
  line 354 (text), line 356 (text), line 358 (text), line 359 (text), line 360 (text), line 367 (text), line 407 (text), line 409 (text),
  line 592 (text), line 594 (text), line 650 (text), line 652 (text), line 653 (text), line 658 (text), line 672 (text), line 674 (text),
  line 676 (text), line 678 (text), line 680 (text), line 691 (text), line 692 (text), line 764 (text), line 781 (text), line 800 (text),
  line 806 (text), line 808 (text), line 814 (text), line 821 (text), line 824 (text), line 826 (text), line 828 (text), line 830 (text),
  line 952 (text), line 954 (text), line 956 (text), line 958 (text), line 959 (text), line 961 (text), line 963 (text), line 965 (text),
  line 966 (text), line 972 (text), line 982 (text), line 985 (text), line 989 (text), line 992 (text), line 1001 (text), line 1005 (text),
  line 1008 (text), line 1010 (text), line 1012 (text), line 1015 (text), line 1055 (text), line 1069 (text) and line 1077 (text).
- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md][42], in the cell docs × markdown: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 8 (text), line 352 (text), line 354 (text), line 356 (text), line 358 (text), line 360
  (text), line 362 (text), line 364 (text), line 366 (text), line 369 (text), line 371 (text), line 393 (text), line 396 (text), line 398
  (text), line 400 (text), line 403 (text), line 406 (text), line 408 (text), line 411 (text), line 414 (text), line 419 (text), line 480
  (text), line 558 (text), line 561 (text), line 564 (text), line 567 (text), line 570 (text), line 573 (text), line 576 (text), line 580
  (text), line 583 (text), line 586 (text), line 589 (text), line 592 (text), line 595 (text), line 598 (text), line 601 (text), line 604
  (text), line 607 (text), line 610 (text), line 613 (text), line 616 (text), line 619 (text), line 622 (text), line 625 (text), line 628
  (text), line 631 (text), line 634 (text), line 637 (text), line 640 (text), line 643 (text), line 646 (text), line 649 (text), line 652
  (text), line 656 (text), line 659 (text), line 662 (text), line 665 (text), line 668 (text), line 671 (text), line 674 (text), line 849
  (text), line 851 (text), line 853 (text), line 855 (text), line 858 (text), line 859 (text), line 862 (text), line 869 (text), line 871
  (text), line 1079 (text), line 1120 (text), line 1239 (text), line 1317 (text) and line 1324 (text); selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 8 (text), line 74 (text), line 76 (text), line 120 (text), line 286 (text), line 288 (text), line 358 (text),
  line 364 (text), line 366 (text), line 372 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 388 (text),
  line 402 (text), line 404 (text), line 409 (text), line 413 (text), line 421 (text), line 425 (text), line 429 (text), line 431 (text),
  line 433 (text), line 436 (text), line 481 (text), line 484 (text), line 752 (text), line 755 (text), line 756 (text), line 759 (text),
  line 762 (text), line 764 (text), line 766 (text), line 773 (text), line 814 (text), line 986 (text), line 988 (text), line 990 (text),
  line 992 (text), line 994 (text), line 1033 (text), line 1056 (text), line 1058 (text), line 1060 (text), line 1062 (text), line 1064
  (text), line 1066 (text), line 1068 (text), line 1070 (text), line 1072 (text), line 1121 (text), line 1127 (text), line 1169 (text), line
  1172 (text), line 1173 (text), line 1228 (text), line 1236 (text), line 1245 (text), line 1265 (text), line 1304 (text), line 1306 (text)
  and line 1318 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md][43], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md][44], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md][45], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text), line 33 (text),
  line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44 (text), line 46
  (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75 (text), line 82
  (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text),
  line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text), line 127 (text),
  line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md][46], in the cell docs × markdown: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text), line 84 (text),
  line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106 (text), line 107
  (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126 (text), line 128
  (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147 (text), line 154
  (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183 (text), line 190
  (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md][47], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md][48], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md][49], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md][50], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md][51], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md][52], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md][53], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md][54], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md][55], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md][57], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md][58], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md][59], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md][60], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 63 (text) and line 73 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md][61], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 30 (text), line 32 (text),
  line 33 (text), line 34 (text), line 35 (text), line 37 (text), line 38 (text), line 40 (text), line 42 (text), line 43 (text), line 44
  (text), line 46 (text), line 47 (text), line 48 (text), line 50 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 67 (text), line 74 (text), line 75
  (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 107 (text), line 109 (text), line 111 (text),
  line 113 (text), line 114 (text), line 116 (text), line 117 (text), line 119 (text), line 121 (text), line 123 (text), line 125 (text),
  line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 135 (text), line 143 (text), line 152 (text) and line 156 (text).
- [docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md][62], in the cell docs × markdown:
  selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (text), line 37 (text), line 39 (text), line 41 (text), line 43 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 54 (text), line 56 (text), line 58 (text), line 60
  (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 80 (text), line 82 (text),
  line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 103 (text), line 106
  (text), line 107 (text), line 110 (text), line 112 (text), line 113 (text), line 115 (text), line 118 (text), line 124 (text), line 126
  (text), line 128 (text), line 131 (text), line 133 (text), line 139 (text), line 141 (text), line 143 (text), line 146 (text), line 147
  (text), line 154 (text), line 158 (text), line 162 (text), line 170 (text), line 172 (text), line 174 (text), line 181 (text), line 183
  (text), line 190 (text), line 192 (text), line 199 (text), line 201 (text), line 209 (text), line 215 (text), line 222 (text) and line 229
  (text).
- [docs/explanation/automation/build-then-place-with-one-command.md][63], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/build-verify-then-copy-the-folder.md][64], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 17 (text), line 58 (text), line 60 (text), line 61 (text), line 63 (text), line 67 (text) and line 69 (text).
- [docs/explanation/automation/dot-source-one-entry-script.md][65], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 54 (text) and line 56 (text).
- [docs/explanation/automation/every-code-root-is-a-copy.md][66], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 51 (text), line 53 (text), line 54 (text), line 55 (text) and line 63 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 17 (text), line 62 (text) and line 63 (text).
- [docs/explanation/automation/every-entry-runs-one-load-sequence.md][67], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 14 (text), line 44 (text) and line 46 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 47
  (text).
- [docs/explanation/automation/invoke-importer-in-code-order.md][68], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 62 (text), line 63 (text) and line 64 (text).
- [docs/explanation/automation/one-commit-one-immutable-package.md][69], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 15 (text), line 45 (text), line 47 (text) and line 49 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it
  at line 15 (text), line 50 (text) and line 54 (text).
- [docs/explanation/automation/rule-and-gate-per-load-stage.md][70], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 17 (text), line 36 (text), line 36 (text), line 39 (text), line 62 (text), line 63 (text) and line 64 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 41 (text), line 51 (text), line 66 (text), line 69 (text) and line 73 (text).
- [docs/explanation/automation/two-entries-feed-one-importer.md][71], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 18 (text), line 59 (text) and line 61 (text).
- [docs/explanation/automation/what-gates-each-bundle-stage.md][72], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 16 (text), line 19 (text), line 31 (text), line 33 (text), line 49 (text), line 52 (text), line 53 (text), line 54 (text)
  and line 61 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 16 (text), line 42 (text), line 57 (text), line 63 (text)
  and line 64 (text).
- [docs/explanation/design/one-entry-script-per-mode.md][73], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the file cites
  it at line 17 (text), line 60 (text), line 61 (text), line 62 (text) and line 63 (text).
- [docs/explanation/design/shims-set-roots-mode-read-back.md][74], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 19 (text), line 58 (text), line 59 (text), line 61 (text) and line 62 (text).
- [docs/explanation/design/two-roots-one-importer-same-modules.md][75], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 17 (text), line 56 (text), line 57 (text), line 58 (text) and line 60 (text).
- [docs/explanation/design/where-code-loads-from-decides-the-mode.md][76], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 14 (text), line 40 (text), line 41 (text), line 42 (text) and line 43 (text).
- [docs/explanation/design/which-run-mode-rules-have-a-gate.md][77], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 17 (text), line 53 (text), line 55 (text), line 57 (text), line 58 (text), line 59 (text), line 60 (text) and line
  61 (text).

### adr/auto (39 lit files)

The group holds the files of docs/adr/automation; each sits in its world-map cell and is lit by:

- [docs/adr/automation/BCL/index.md][78], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/BCL/native-csharp-types.md][79], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/avoid-deep-nesting.md][80], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/bash/bash-test-artifacts.md][81], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/caching.md][82], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/console-output-matters.md][83], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-module-dependencies.md][84], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/controlling-systemwide-deps.md][85], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/cross-platform.md][86], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/devbox-pipeline-parity.md][87], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/dora-explains.md][88], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/dry-run.md][89], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/effective-in-enterprises.md][90], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/environment-variables.md][91], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/execution-engines.md][92], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/fail-fast-with-asserts.md][93], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/go/index.md][94], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation` ADR
  domain, the ADR domain of that code.
- [docs/adr/automation/go/test-artifacts.md][95], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/idempotent-state-functions.md][96], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/internal-asset-dependencies.md][97], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/log-before-invoke.md][98], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/managed-guids.md][99], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/never-depend-on-pwd.md][100], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/open-closed-architecture.md][101], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/path-representation.md][102], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/platform-bundle.md][1], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/protected-globs.md][103], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/index.md][104], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the `automation`
  ADR domain, the ADR domain of that code.
- [docs/adr/automation/python/python-test-artifacts.md][105], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/retry-as-last-resort.md][106], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/sensible-defaults.md][107], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/single-responsibility-functions.md][108], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file
  of the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/spell-out-names.md][109], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/test-automation.md][110], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tool-removal-lifecycle.md][111], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/tracked-files-from-the-index.md][112], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/use-proper-package-managers.md][113], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of
  the `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/uv-python-handler.md][114], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.
- [docs/adr/automation/zero-ceremony-poka-yoke.md][115], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: an ADR file of the
  `automation` ADR domain, the ADR domain of that code.

### Exporter (10 lit files)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1][116], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Build-Modules.ps1][117], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 5 (header) and line 54 (text).
- [automation/Catzc.Base.Exporter/Export-Catzc.ps1][118], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Install-Catzc.ps1][119], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1][120], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/configs/exporter.yml][121], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 7 (header).
- [automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1][122], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 6 (header).
- [automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1][123], in the cell automation × powershell: selected by
  [ADR-AUTO-BUNDLE][1]: the file cites it at line 5 (header).
- [automation/Catzc.Base.Exporter/types/ExporterBundle.cs][124], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 3 (header).
- [automation/Catzc.Base.Exporter/types/ExporterConfig.cs][125], in the cell automation × csharp: selected by [ADR-AUTO-BUNDLE][1]: the file
  cites it at line 2 (header).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][126], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design`
  ADR domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][127], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][128], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][2], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][129], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][130], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][131], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][132], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][133], in the cell docs × markdown: selected by [ADR-DSGN-RUNMODE][2]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### ModuleSystem (8 lit files)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1][134], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 26 (header).
- [automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1][135], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).
- [automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1][136], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 22 (header).
- [automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1][137], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 10 (header).
- [automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1][138], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 28 (header).
- [automation/Catzc.Base.ModuleSystem/New-Importer.ps1][139], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 16 (header).
- [automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1][140], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 17 (header).
- [automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1][141], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 21 (header).

### QualityGates (5 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1][142], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 25 (header).
- [automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1][143], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][144], in the cell automation × yaml: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 590 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1][145], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 7 (text).
- [automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1][146], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (header) and line 6 (text).

### TypesSystem (5 lit files)

The group holds the files of automation/Catzc.Base.TypesSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1][147], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 15 (header).
- [automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1][148], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 30 (header).
- [automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1][149], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 8 (header).
- [automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1][150], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 24 (header).
- [automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1][151], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 22 (header).

### Root files (3 lit files)

The group holds the files of Root files; each sits in its world-map cell and is lit by:

- [.gitattributes][152], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of
  its owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [.gitignore][153], in the cell Root files × Unlisted files: selected by [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its
  owner module's files (files.yml), which cite it at `automation/Catzc.Base.Repository/Assert-SourceTree.ps1` line 8 (header),
  `automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1` line 10 (header) and `automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1`
  line 6 (header).
- [importer.ps1][154], in the cell Root files × powershell: selected by [ADR-AUTO-BUNDLE][1]: a root file carries the citations of its owner
  module's files (files.yml), which cite it at `automation/.internal/assets/Import-Catzc.ps1` line 6 (header); selected by
  [ADR-DSGN-RUNMODE][2]: a root file carries the citations of its owner module's files (files.yml), which cite it at
  `automation/.internal/assets/Import-Catzc.ps1` line 5 (header) and `automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1` line 1
  (text).

### Repository (3 lit files)

The group holds the files of automation/Catzc.Base.Repository; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Repository/Assert-SourceTree.ps1][155], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 8 (header).
- [automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1][156], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]:
  the file cites it at line 10 (header).
- [automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1][157], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 6 (header).

### .internal (2 lit files)

The group holds the files of automation/.internal; each sits in its world-map cell and is lit by:

- [automation/.internal/assets/Import-Catzc.ps1][158], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]: the file cites
  it at line 6 (header); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 5 (header).
- [automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1][159], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 1 (text).

### Docs (2 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][160], in the cell automation × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at
  line 162 (text); selected by [ADR-DSGN-RUNMODE][2]: the file cites it at line 101 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][161], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).

### Vendor (2 lit files)

The group holds the files of automation/Catzc.Base.Vendor; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Vendor/Install-VendorModule.ps1][162], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 11 (header).
- [automation/Catzc.Base.Vendor/Remove-VendorModules.ps1][163], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 18 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][164], in the cell .github × yaml: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 48
  (body comment) (a passing mention only).

### ConfigExtensions (1 lit file)

The group holds the files of automation/Catzc.Base.ConfigExtensions; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1][165], in the cell automation × powershell: selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 12 (header).

### Contracts (1 lit file)

The group holds the files of automation/Catzc.Base.Contracts; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1][166], in the cell automation × powershell: selected by [ADR-AUTO-BUNDLE][1]:
  the file cites it at line 12 (header).

### Globs (1 lit file)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][167], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the file
  cites it at line 29 (header).

### RootConfig (1 lit file)

The group holds the files of automation/Catzc.Base.RootConfig; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.RootConfig/Build-RootConfig.ps1][168], in the cell automation × powershell: selected by [ADR-DSGN-RUNMODE][2]: the
  file cites it at line 24 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][169], in the cell docs × markdown: selected by [ADR-AUTO-BUNDLE][1]: the file cites it at line 150 (text); selected by
  [ADR-DSGN-RUNMODE][2]: the file cites it at line 94 (text).

## Keywords

- [world map][170]
- [track][171]
- [file language][172]
- [cell][173]
- [lit cell][174]
- [root file][175]
- [unlisted file][176]
- [.github][177]: a track
- [automation][177]: a track
- [docs][177]: a track
- [csharp][178]: a file language
- [markdown][178]: a file language
- [powershell][178]: a file language
- [yaml][178]: a file language

[1]: ../../adr/automation/platform-bundle.md
[2]: ../../adr/design/run-modes.md
[3]: adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
[4]: adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
[5]: adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
[6]: adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
[7]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
[8]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
[9]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
[10]: adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
[11]: adr-auto-bundle--dot-source-one-entry-script--operations.chain.md
[12]: adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
[13]: adr-auto-bundle--dot-source-one-entry-script--operations.grid.md
[14]: adr-auto-bundle--dot-source-one-entry-script--operations.tree.md
[15]: adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
[16]: adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
[17]: adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
[18]: adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
[19]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
[20]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
[21]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
[22]: adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md
[23]: adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
[24]: adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
[25]: adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
[26]: adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md
[27]: adr-auto-bundle--one-commit-one-immutable-package--meta.chain.md
[28]: adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md
[29]: adr-auto-bundle--one-commit-one-immutable-package--meta.grid.md
[30]: adr-auto-bundle--one-commit-one-immutable-package--meta.tree.md
[31]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
[32]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
[33]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
[34]: adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
[35]: adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
[36]: adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
[37]: adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
[38]: adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
[39]: adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
[40]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[41]: adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
[42]: adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
[43]: adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
[44]: adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
[45]: adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
[46]: adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
[47]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
[48]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
[49]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
[50]: adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
[51]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
[52]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
[53]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
[54]: adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
[55]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
[56]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
[57]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
[58]: adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
[59]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md
[60]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
[61]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md
[62]: adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md
[63]: ../../explanation/automation/build-then-place-with-one-command.md
[64]: ../../explanation/automation/build-verify-then-copy-the-folder.md
[65]: ../../explanation/automation/dot-source-one-entry-script.md
[66]: ../../explanation/automation/every-code-root-is-a-copy.md
[67]: ../../explanation/automation/every-entry-runs-one-load-sequence.md
[68]: ../../explanation/automation/invoke-importer-in-code-order.md
[69]: ../../explanation/automation/one-commit-one-immutable-package.md
[70]: ../../explanation/automation/rule-and-gate-per-load-stage.md
[71]: ../../explanation/automation/two-entries-feed-one-importer.md
[72]: ../../explanation/automation/what-gates-each-bundle-stage.md
[73]: ../../explanation/design/one-entry-script-per-mode.md
[74]: ../../explanation/design/shims-set-roots-mode-read-back.md
[75]: ../../explanation/design/two-roots-one-importer-same-modules.md
[76]: ../../explanation/design/where-code-loads-from-decides-the-mode.md
[77]: ../../explanation/design/which-run-mode-rules-have-a-gate.md
[78]: ../../adr/automation/BCL/index.md
[79]: ../../adr/automation/BCL/native-csharp-types.md
[80]: ../../adr/automation/avoid-deep-nesting.md
[81]: ../../adr/automation/bash/bash-test-artifacts.md
[82]: ../../adr/automation/caching.md
[83]: ../../adr/automation/console-output-matters.md
[84]: ../../adr/automation/controlling-module-dependencies.md
[85]: ../../adr/automation/controlling-systemwide-deps.md
[86]: ../../adr/automation/cross-platform.md
[87]: ../../adr/automation/devbox-pipeline-parity.md
[88]: ../../adr/automation/dora-explains.md
[89]: ../../adr/automation/dry-run.md
[90]: ../../adr/automation/effective-in-enterprises.md
[91]: ../../adr/automation/environment-variables.md
[92]: ../../adr/automation/execution-engines.md
[93]: ../../adr/automation/fail-fast-with-asserts.md
[94]: ../../adr/automation/go/index.md
[95]: ../../adr/automation/go/test-artifacts.md
[96]: ../../adr/automation/idempotent-state-functions.md
[97]: ../../adr/automation/internal-asset-dependencies.md
[98]: ../../adr/automation/log-before-invoke.md
[99]: ../../adr/automation/managed-guids.md
[100]: ../../adr/automation/never-depend-on-pwd.md
[101]: ../../adr/automation/open-closed-architecture.md
[102]: ../../adr/automation/path-representation.md
[103]: ../../adr/automation/protected-globs.md
[104]: ../../adr/automation/python/index.md
[105]: ../../adr/automation/python/python-test-artifacts.md
[106]: ../../adr/automation/retry-as-last-resort.md
[107]: ../../adr/automation/sensible-defaults.md
[108]: ../../adr/automation/single-responsibility-functions.md
[109]: ../../adr/automation/spell-out-names.md
[110]: ../../adr/automation/test-automation.md
[111]: ../../adr/automation/tool-removal-lifecycle.md
[112]: ../../adr/automation/tracked-files-from-the-index.md
[113]: ../../adr/automation/use-proper-package-managers.md
[114]: ../../adr/automation/uv-python-handler.md
[115]: ../../adr/automation/zero-ceremony-poka-yoke.md
[116]: ../../../automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1
[117]: ../../../automation/Catzc.Base.Exporter/Build-Modules.ps1
[118]: ../../../automation/Catzc.Base.Exporter/Export-Catzc.ps1
[119]: ../../../automation/Catzc.Base.Exporter/Install-Catzc.ps1
[120]: ../../../automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1
[121]: ../../../automation/Catzc.Base.Exporter/configs/exporter.yml
[122]: ../../../automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1
[123]: ../../../automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1
[124]: ../../../automation/Catzc.Base.Exporter/types/ExporterBundle.cs
[125]: ../../../automation/Catzc.Base.Exporter/types/ExporterConfig.cs
[126]: ../../adr/design/commit-lifecycle.md
[127]: ../../adr/design/dora-explains.md
[128]: ../../adr/design/module-aspects.md
[129]: ../../adr/design/self-service.md
[130]: ../../adr/design/server-remote-integration.md
[131]: ../../adr/design/thin-platforms.md
[132]: ../../adr/design/tracks.md
[133]: ../../adr/design/visual-design.md
[134]: ../../../automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1
[135]: ../../../automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1
[136]: ../../../automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
[137]: ../../../automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
[138]: ../../../automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1
[139]: ../../../automation/Catzc.Base.ModuleSystem/New-Importer.ps1
[140]: ../../../automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
[141]: ../../../automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
[142]: ../../../automation/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
[143]: ../../../automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
[144]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[145]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1
[146]: ../../../automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1
[147]: ../../../automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1
[148]: ../../../automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
[149]: ../../../automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1
[150]: ../../../automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1
[151]: ../../../automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
[152]: ../../../.gitattributes
[153]: ../../../.gitignore
[154]: ../../../importer.ps1
[155]: ../../../automation/Catzc.Base.Repository/Assert-SourceTree.ps1
[156]: ../../../automation/Catzc.Base.Repository/Get-CatzcModuleRoot.ps1
[157]: ../../../automation/Catzc.Base.Repository/Get-CatzcRunMode.ps1
[158]: ../../../automation/.internal/assets/Import-Catzc.ps1
[159]: ../../../automation/.internal/tests/New-FakeRepositoryRoot.Tests.ps1
[160]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[161]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[162]: ../../../automation/Catzc.Base.Vendor/Install-VendorModule.ps1
[163]: ../../../automation/Catzc.Base.Vendor/Remove-VendorModules.ps1
[164]: ../../../.github/workflows/ci-automation.yml
[165]: ../../../automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
[166]: ../../../automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1
[167]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[168]: ../../../automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
[169]: ../../adr/index.md
[170]: ../../adr/glossary.md#world-map
[171]: ../../adr/glossary.md#track
[172]: ../../adr/glossary.md#file-language
[173]: ../../adr/glossary.md#cell
[174]: ../../adr/glossary.md#lit-cell
[175]: ../../adr/glossary.md#root-file
[176]: ../../adr/glossary.md#unlisted-file
[177]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[178]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
