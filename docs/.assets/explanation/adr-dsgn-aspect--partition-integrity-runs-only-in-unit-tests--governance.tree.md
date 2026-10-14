# docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md

`Tree minimap: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance`

![Tree minimap of adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance](adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.png)

The tree minimap of the slide `adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance` (governance lens). The slide
supports [ADR-DSGN-ASPECT][1], [ADR-FLOW-CD-GLOBS][2], [ADR-PWSH-MANIFEST][3], [ADR-PWSH-ONEFUNC][4] and [ADR-REPO-FOLDERS][5]; the
highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 215 files in 17 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 85 lit files
- Globs (automation/Catzc.Base.Globs): 40 lit files
- adr/pwsh (docs/adr/pwsh): 26 lit files
- adr/repo (docs/adr/repository): 15 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 6 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- Docs (automation/Catzc.Base.Docs): 4 lit files
- Variants (automation/Catzc.Base.Variants): 4 lit files
- Languages (automation/Catzc.Base.Languages): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- .claude: 1 lit file
- .github: 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file

## Why each group is lit

### docs (85 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md][6], in the cell docs × markdown: selected
  by [ADR-PWSH-MANIFEST][3]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md][7], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md][8], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md][10], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 65 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line 39 (text),
  line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text), line 66
  (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80 (text),
  line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83 (text),
  line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md][15], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text) and line 34
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md][16], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md][18], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md][19], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 25 (text), line 25 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md][21], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 29 (text), line 30 (text), line 37 (text), line
  39 (text), line 40 (text), line 41 (text), line 43 (text), line 50 (text), line 51 (text), line 59 (text), line 61 (text), line 64 (text),
  line 66 (text), line 68 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 83 (text), line 85 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text) and line 94 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md][22], in the cell docs × markdown:
  selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line
  38 (text), line 39 (text), line 41 (text), line 44 (text), line 46 (text), line 49 (text), line 56 (text), line 58 (text), line 60 (text),
  line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 79 (text), line 82 (text), line 83
  (text), line 85 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 105 (text), line 113 (text) and line 119
  (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][23], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text) and line 38
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 30 (text) and line 30 (text); selected by
  [ADR-PWSH-MANIFEST][3]: the file cites it at line 8 (text), line 46 (text) and line 46 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file
  cites it at line 8 (text), line 49 (text) and line 49 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line
  52 (text), line 52 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][24], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 66 (text) and line 75 (text); selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 66 (text) and line 76 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 66 (text) and line
  75 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 66 (text) and line 75 (text); selected by [ADR-REPO-FOLDERS][5]:
  the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][25], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 46 (text), line 61 (text), line 62 (text), line 89
  (text), line 120 (text), line 134 (text), line 148 (text), line 153 (text), line 162 (text), line 172 (text), line 182 (text), line 184
  (text), line 187 (text), line 189 (text), line 191 (text), line 218 (text), line 220 (text), line 222 (text), line 224 (text), line 225
  (text), line 227 (text), line 229 (text), line 231 (text), line 232 (text), line 247 (text), line 334 (text), line 336 (text), line 339
  (text), line 341 (text) and line 344 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 38 (text), line
  47 (text), line 48 (text), line 50 (text), line 52 (text), line 56 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text),
  line 78 (text), line 79 (text), line 81 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92
  (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 103 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 122
  (text), line 124 (text), line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 135 (text), line 137 (text), line 139
  (text), line 143 (text), line 146 (text), line 149 (text), line 151 (text), line 160 (text), line 163 (text), line 169 (text), line 191
  (text), line 196 (text), line 199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211
  (text), line 212 (text), line 215 (text), line 217 (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242
  (text), line 244 (text), line 247 (text), line 338 (text), line 342 (text), line 346 (text), line 350 (text), line 352 (text), line 354
  (text), line 356 (text), line 359 (text), line 361 (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371
  (text), line 373 (text), line 375 (text), line 384 (text), line 385 (text), line 386 (text), line 387 (text), line 388 (text) and line 389
  (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 8 (text), line 163 (text), line 180 (text), line 192 (text), line
  248 (text), line 250 (text), line 252 (text), line 254 (text), line 256 (text), line 258 (text), line 260 (text), line 262 (text), line
  264 (text), line 266 (text), line 268 (text), line 270 (text), line 272 (text), line 274 (text), line 276 (text), line 278 (text), line
  280 (text), line 282 (text), line 284 (text), line 286 (text), line 288 (text), line 290 (text), line 292 (text), line 294 (text), line
  296 (text), line 298 (text), line 300 (text), line 332 (text), line 340 (text) and line 347 (text); selected by [ADR-PWSH-ONEFUNC][4]: the
  file cites it at line 8 (text), line 31 (text), line 144 (text), line 164 (text), line 171 (text), line 193 (text), line 249 (text), line
  251 (text), line 253 (text), line 255 (text), line 257 (text), line 259 (text), line 261 (text), line 263 (text), line 265 (text), line
  267 (text), line 269 (text), line 271 (text), line 273 (text), line 275 (text), line 277 (text), line 279 (text), line 281 (text), line
  283 (text), line 285 (text), line 287 (text), line 289 (text), line 291 (text), line 293 (text), line 295 (text), line 297 (text), line
  299 (text), line 301 (text) and line 348 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line 58 (text),
  line 59 (text), line 60 (text), line 77 (text), line 141 (text), line 164 (text), line 166 (text), line 168 (text), line 193 (text), line
  196 (text), line 246 (text), line 249 (text), line 302 (text), line 304 (text), line 306 (text), line 308 (text), line 310 (text), line
  312 (text), line 314 (text), line 316 (text), line 318 (text), line 320 (text), line 322 (text), line 324 (text), line 326 (text), line
  328 (text), line 330 (text), line 335 (text), line 348 (text), line 351 (text), line 376 (text) and line 411 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][26], in the cell docs ×
  markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 8 (text), line 52 (text), line 91 (text), line 104 (text), line 113
  (text), line 135 (text), line 137 (text), line 139 (text), line 141 (text), line 143 (text), line 172 (text), line 175 (text), line 178
  (text), line 181 (text), line 185 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 365 (text), line 423 (text), line 438 (text), line 440 (text), line 442
  (text), line 444 (text) and line 463 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 40 (text), line
  42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 58 (text), line 60 (text),
  line 61 (text), line 63 (text), line 66 (text), line 67 (text), line 70 (text), line 72 (text), line 75 (text), line 76 (text), line 79
  (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 93 (text), line 95 (text), line 97 (text),
  line 99 (text), line 101 (text), line 103 (text), line 107 (text), line 108 (text), line 111 (text), line 114 (text), line 115 (text),
  line 117 (text), line 120 (text), line 124 (text), line 143 (text), line 148 (text), line 151 (text), line 153 (text), line 155 (text),
  line 157 (text), line 159 (text), line 161 (text), line 163 (text), line 165 (text), line 167 (text), line 169 (text), line 177 (text),
  line 183 (text), line 186 (text), line 190 (text), line 193 (text), line 195 (text), line 197 (text), line 200 (text), line 202 (text),
  line 204 (text), line 206 (text), line 208 (text), line 210 (text), line 212 (text), line 214 (text), line 216 (text), line 356 (text),
  line 363 (text), line 365 (text), line 368 (text), line 374 (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text),
  line 384 (text), line 391 (text), line 393 (text), line 395 (text), line 397 (text), line 399 (text), line 401 (text), line 409 (text),
  line 411 (text), line 413 (text), line 415 (text), line 417 (text), line 424 (text), line 464 (text), line 478 (text) and line 485 (text);
  selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 8 (text), line 133 (text), line 144 (text), line 170 (text), line 179
  (text), line 187 (text), line 225 (text), line 228 (text), line 230 (text), line 233 (text), line 236 (text), line 239 (text), line 241
  (text), line 244 (text), line 247 (text), line 249 (text), line 252 (text), line 254 (text), line 256 (text), line 258 (text), line 261
  (text), line 263 (text), line 265 (text), line 268 (text), line 271 (text), line 274 (text), line 277 (text), line 279 (text), line 282
  (text), line 285 (text), line 287 (text), line 290 (text), line 424 (text) and line 464 (text); selected by [ADR-PWSH-ONEFUNC][4]: the
  file cites it at line 8 (text), line 145 (text), line 188 (text), line 226 (text), line 229 (text), line 231 (text), line 234 (text), line
  237 (text), line 240 (text), line 242 (text), line 245 (text), line 248 (text), line 250 (text), line 253 (text), line 255 (text), line
  257 (text), line 259 (text), line 262 (text), line 264 (text), line 266 (text), line 269 (text), line 272 (text), line 275 (text), line
  278 (text), line 280 (text), line 283 (text), line 286 (text), line 288 (text), line 291 (text), line 358 (text), line 361 (text), line
  425 (text), line 465 (text) and line 472 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line 145 (text),
  line 148 (text), line 173 (text), line 189 (text), line 191 (text), line 218 (text), line 298 (text), line 300 (text), line 302 (text),
  line 304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 318 (text),
  line 320 (text), line 322 (text), line 324 (text), line 326 (text), line 425 (text), line 427 (text), line 429 (text), line 431 (text),
  line 451 (text), line 453 (text), line 455 (text), line 462 (text), line 465 (text), line 493 (text) and line 515 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][27], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 33 (text) and line 33 (text); selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line 73 (text), line 73 (text) and line 89 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][28], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 60 (text) and line 68 (text); selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][29], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 49 (text), line 65 (text), line 66 (text), line 68 (text),
  line 70 (text), line 74 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 123 (text), line 124 (text), line
  126 (text), line 127 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 137 (text), line
  139 (text), line 141 (text), line 142 (text), line 144 (text), line 146 (text), line 147 (text), line 148 (text), line 150 (text), line
  152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line
  168 (text), line 170 (text), line 172 (text), line 174 (text), line 176 (text), line 178 (text), line 181 (text), line 225 (text), line
  226 (text), line 230 (text), line 232 (text), line 242 (text), line 246 (text), line 251 (text), line 270 (text), line 289 (text), line
  304 (text), line 306 (text), line 308 (text), line 310 (text), line 312 (text), line 314 (text), line 316 (text), line 317 (text), line
  320 (text), line 322 (text), line 340 (text), line 342 (text), line 344 (text), line 346 (text), line 348 (text), line 350 (text), line
  356 (text), line 394 (text), line 402 (text), line 406 (text), line 413 (text), line 425 (text), line 427 (text), line 429 (text), line
  432 (text), line 434 (text), line 438 (text), line 440 (text), line 442 (text), line 446 (text), line 448 (text), line 450 (text), line
  455 (text), line 466 (text), line 467 (text), line 468 (text), line 469 (text), line 471 (text) and line 472 (text); selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line 76 (text), line 78 (text), line 80 (text), line 120 (text), line 223
  (text), line 246 (text), line 247 (text), line 249 (text), line 270 (text), line 290 (text), line 354 (text), line 356 (text), line 358
  (text), line 360 (text), line 362 (text), line 364 (text), line 366 (text), line 368 (text), line 370 (text), line 372 (text), line 374
  (text), line 376 (text), line 378 (text), line 380 (text), line 382 (text), line 384 (text), line 386 (text), line 390 (text), line 407
  (text), line 413 (text), line 456 (text) and line 496 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][30], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 41 (text), line 60 (text), line 75 (text), line 77 (text),
  line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 100
  (text), line 108 (text), line 113 (text), line 119 (text), line 132 (text), line 134 (text), line 136 (text), line 139 (text), line 141
  (text), line 145 (text), line 147 (text), line 149 (text), line 153 (text), line 155 (text), line 157 (text), line 162 (text), line 173
  (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 183 (text), line 185 (text), line 187 (text), line 190
  (text), line 192 (text), line 193 (text), line 195 (text), line 198 (text), line 200 (text), line 202 (text), line 204 (text), line 207
  (text), line 208 (text), line 211 (text), line 213 (text), line 215 (text), line 217 (text), line 219 (text), line 221 (text), line 223
  (text), line 225 (text), line 227 (text), line 229 (text), line 231 (text), line 233 (text), line 235 (text), line 236 (text), line 239
  (text), line 241 (text), line 243 (text), line 245 (text), line 248 (text), line 252 (text), line 368 (text), line 438 (text), line 443
  (text), line 447 (text), line 449 (text), line 456 (text), line 459 (text), line 461 (text), line 463 (text), line 466 (text), line 469
  (text), line 475 (text), line 477 (text), line 479 (text), line 481 (text), line 484 (text), line 485 (text), line 493 (text), line 495
  (text), line 497 (text), line 499 (text), line 501 (text), line 547 (text), line 554 (text) and line 561 (text); selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (text), line 41 (text), line 61 (text), line 96 (text), line 113 (text), line 119
  (text), line 164 (text), line 331 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 343
  (text), line 345 (text), line 347 (text), line 349 (text), line 351 (text), line 353 (text), line 355 (text), line 357 (text), line 359
  (text), line 368 (text), line 370 (text), line 372 (text), line 374 (text), line 400 (text), line 404 (text), line 408 (text), line 532
  (text), line 545 (text), line 548 (text) and line 586 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][31], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][32], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][33], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40
  (text), line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text),
  line 65 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78
  (text), line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text),
  line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line
  109 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line
  124 (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line
  152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line
  168 (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line
  182 (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line
  199 (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line
  220 (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md][34], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38
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
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][35], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][36], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][37], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md][38], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][39], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 27 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][40], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][41], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 57 (text),
  line 59 (text), line 63 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 280 (text), line 290 (text), line 292
  (text), line 294 (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 305 (text), line 309 (text), line 311
  (text), line 312 (text), line 315 (text), line 319 (text), line 320 (text), line 321 (text), line 323 (text), line 325 (text), line 327
  (text), line 330 (text), line 333 (text), line 335 (text), line 337 (text), line 339 (text), line 343 (text), line 345 (text), line 347
  (text), line 350 (text), line 351 (text), line 360 (text), line 366 (text), line 368 (text), line 371 (text), line 446 (text), line 481
  (text), line 489 (text), line 513 (text), line 777 (text), line 784 (text), line 793 (text), line 821 (text), line 825 (text), line 827
  (text), line 829 (text), line 831 (text), line 834 (text), line 836 (text), line 838 (text), line 840 (text), line 842 (text), line 845
  (text), line 847 (text), line 926 (text), line 928 (text), line 930 (text), line 932 (text), line 934 (text), line 936 (text), line 941
  (text), line 949 (text), line 951 (text), line 954 (text), line 956 (text), line 959 (text), line 961 (text), line 964 (text), line 967
  (text), line 969 (text), line 971 (text), line 975 (text), line 977 (text), line 979 (text), line 981 (text), line 986 (text), line 993
  (text), line 1003 (text), line 1004 (text), line 1005 (text), line 1006 (text), line 1007 (text) and line 1009 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][42], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 71 (text), line 126 (text), line 134 (text), line 158 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][43], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][44], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][45], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md][46], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][47], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][48], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][49], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md][50], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][51], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][52], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][53], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md][54], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][55], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][56], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][57], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 45 (text), line 55 (text), line 56 (text), line 58 (text),
  line 60 (text), line 64 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 281 (text), line 292 (text), line 294
  (text), line 296 (text), line 298 (text), line 300 (text), line 302 (text), line 304 (text), line 307 (text), line 311 (text), line 313
  (text), line 314 (text), line 317 (text), line 321 (text), line 322 (text), line 323 (text), line 325 (text), line 327 (text), line 329
  (text), line 332 (text), line 335 (text), line 337 (text), line 339 (text), line 341 (text), line 345 (text), line 347 (text), line 349
  (text), line 352 (text), line 353 (text), line 362 (text), line 368 (text), line 370 (text), line 373 (text), line 448 (text), line 483
  (text), line 491 (text), line 515 (text), line 779 (text), line 786 (text), line 796 (text), line 827 (text), line 831 (text), line 833
  (text), line 835 (text), line 837 (text), line 840 (text), line 842 (text), line 844 (text), line 846 (text), line 849 (text), line 852
  (text), line 854 (text), line 933 (text), line 935 (text), line 937 (text), line 939 (text), line 941 (text), line 943 (text), line 948
  (text), line 973 (text), line 975 (text), line 978 (text), line 980 (text), line 983 (text), line 985 (text), line 988 (text), line 991
  (text), line 993 (text), line 995 (text), line 999 (text), line 1002 (text), line 1004 (text), line 1006 (text), line 1011 (text), line
  1018 (text), line 1028 (text), line 1029 (text), line 1030 (text), line 1031 (text), line 1032 (text) and line 1034 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][58], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 72 (text), line 128 (text), line 136 (text), line 160 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][59], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][60], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][61], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
  (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65 (text),
  line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text), line 80
  (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124 (text), line
  126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152 (text), line
  154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168 (text), line
  169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182 (text), line
  184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199 (text), line
  201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220 (text), line
  221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md][62], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
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
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][63], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][64], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][65], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md][66], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][67], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][68], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][69], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
  line 42 (text), line 46 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 63 (text), line 65
  (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text), line 73 (text), line 75 (text), line 76 (text), line 78 (text),
  line 80 (text), line 81 (text), line 83 (text), line 85 (text), line 86 (text), line 87 (text), line 89 (text), line 91 (text), line 93
  (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109
  (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121 (text), line 122 (text), line 124
  (text), line 126 (text), line 134 (text), line 136 (text), line 137 (text), line 146 (text), line 148 (text), line 150 (text), line 152
  (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 163 (text), line 166 (text), line 168
  (text), line 169 (text), line 171 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181 (text), line 182
  (text), line 184 (text), line 186 (text), line 188 (text), line 190 (text), line 192 (text), line 194 (text), line 197 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 213 (text), line 220
  (text), line 221 (text), line 222 (text), line 223 (text), line 224 (text) and line 225 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md][70], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/explanation/automation/what-gates-each-bundle-stage.md][71], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: the
  file cites it at line 16 (text), line 32 (text) and line 50 (text).
- [docs/explanation/design/drop-a-file-the-import-exports-it.md][72], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 16 (text), line 46 (text) and line 48 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 52
  (text).
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][73], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 14 (text), line 42 (text), line 44 (text), line 45 (text), line 46 (text), line 51 (text), line 53 (text) and line 55
  (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 51 (text).
- [docs/explanation/design/manifest-and-aspects-from-one-folder.md][74], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 18 (text), line 53 (text), line 55 (text) and line 61 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it
  at line 59 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][75], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the
  file cites it at line 17 (text), line 51 (text), line 53 (text), line 55 (text), line 59 (text) and line 61 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 59 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][76], in the cell docs × markdown: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 17 (text), line 21 (text), line 22 (text), line 45 (text), line 46 (text), line 48 (text),
  line 59 (text), line 60 (text), line 61 (text), line 65 (text) and line 67 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 49 (text) and line 67 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 36 (text), line 42 (text), line 43
  (text), line 55 (text), line 56 (text) and line 69 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 35 (text) and line
  53 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 38 (text), line 57 (text) and line 71 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][77], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 59 (text) and line 59 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 54 (text) and line 55
  (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][78], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][79], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][80], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57
  (text), line 58 (text), line 59 (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][81], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][82], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][83], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][84], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 16 (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][85], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 13 (text), line 38 (text) and line 40 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][86], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][87], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 15 (text), line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][88], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][89], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 29 (text).
- [docs/references/automation/catzc-base-languages.md][90], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites
  it at line 47 (text) and line 77 (text).

### Globs (40 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][91], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][92], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][93], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][94], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][95], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][96], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][97], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header), line 10 (header) and line 83 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 72
  (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][98], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][99], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][100], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][101], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][102], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][103], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][104], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it
  at line 2 (header), line 7 (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body
  comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][105], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][106], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][107], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][108], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][109], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][110], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][111], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][112], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][113], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][114], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1][115], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 40 (text).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][116], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][117], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][118], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][119], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][120], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][121], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1][122], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]:
  the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][123], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][124], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][125], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text),
  line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][126], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file cites it
  at line 1 (header), line 14 (header) and line 92 (body comment); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][127], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][128], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][129], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites
  it at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][130], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### adr/pwsh (26 lit files)

The group holds the files of docs/adr/pwsh; each sits in its world-map cell and is lit by:

- [docs/adr/pwsh/announce-state-changes.md][131], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/assert-idioms.md][132], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/automatic-variable-pitfalls.md][133], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/avoid-using-semicolons.md][134], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/cross-platform-powershell.md][135], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/dora-explains.md][136], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/dynamic-module-manifests.md][3], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/environment-variable-mechanics.md][137], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/error-handling.md][138], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/hosting-csharp-types.md][139], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/identifier-names.md][140], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/index.md][141], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR domain, the
  ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/module-path-hygiene.md][142], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/one-function-per-file.md][4], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/parameter-design.md][143], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/pester-testing.md][144], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/powershell-formatting.md][145], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/prefer-dryrun-over-shouldprocess.md][146], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of
  the `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prefer-foreach-over-foreach-object.md][147], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file
  of the `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR
  domain of that code.
- [docs/adr/pwsh/prepost-extension-modules.md][148], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/pwsh-engine.md][149], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/respect-pwsh-verb-rules.md][150], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/script-scope-caching.md][151], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh`
  ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that
  code.
- [docs/adr/pwsh/use-ps1-not-psm1.md][152], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the `pwsh` ADR
  domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of that code.
- [docs/adr/pwsh/vendor-toolset-dependencies.md][153], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.
- [docs/adr/pwsh/working-directory-mechanics.md][154], in the cell docs × markdown: selected by [ADR-PWSH-MANIFEST][3]: an ADR file of the
  `pwsh` ADR domain, the ADR domain of that code; selected by [ADR-PWSH-ONEFUNC][4]: an ADR file of the `pwsh` ADR domain, the ADR domain of
  that code.

### adr/repo (15 lit files)

The group holds the files of docs/adr/repository; each sits in its world-map cell and is lit by:

- [docs/adr/repository/agent-definitions.md][155], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/api-contracts.md][156], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/controlled-vocabulary.md][157], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/conventional-folders.md][5], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dedicated-output-directory.md][158], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/documentation-examples.md][159], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/domain-language-separation.md][160], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of
  the `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/dora-explains.md][161], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-readmes.md][162], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/generated-root-configs.md][163], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/inspiration.md][164], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the `repository`
  ADR domain, the ADR domain of that code.
- [docs/adr/repository/markdown-links.md][165], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/output-formats.md][166], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/repo-variants.md][167], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.
- [docs/adr/repository/uniform-formatting.md][168], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: an ADR file of the
  `repository` ADR domain, the ADR domain of that code.

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][169], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][170], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][1], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][171], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/self-service.md][172], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][173], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][174], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][175], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/visual-design.md][176], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### QualityGates (6 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][177], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/configs/terminology.yml][178], in the cell automation × yaml: selected by [ADR-PWSH-ONEFUNC][4]: the
  file cites it at line 584 (text).
- [automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1][179], in the cell automation × powershell: selected by
  [ADR-PWSH-ONEFUNC][4]: the file cites it at line 6 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][180], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][181], in the cell automation × powershell: selected by
  [ADR-DSGN-ASPECT][1]: the file cites it at line 54 (body comment) (a passing mention only); selected by [ADR-FLOW-CD-GLOBS][2]: the file
  cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][182], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 9 (header).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][183], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][184], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][185], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][186], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][187], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][188], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][189], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][190], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][191], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][192], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line
  4 (header).
- [pipelines/ci-infrastructure.yaml][193], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][194], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][195], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][196], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][197], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][198], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 8 (header).

### Docs (4 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][199], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file cites it at
  line 102 (text); selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 122 (text); selected by [ADR-PWSH-MANIFEST][3]: the file
  cites it at line 188 (text); selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 186 (text); selected by [ADR-REPO-FOLDERS][5]:
  the file cites it at line 307 (text).
- [automation/Catzc.Base.Docs/configs/agents.yml][200], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites it
  at line 32 (body comment) and line 37 (body comment) (a passing mention only).
- [automation/Catzc.Base.Docs/configs/glossary.yml][201], in the cell automation × yaml: selected by [ADR-REPO-FOLDERS][5]: the file cites
  it at line 17 (text).
- [automation/Catzc.Base.Docs/private/Get-CatsModules.ps1][202], in the cell automation × powershell: selected by [ADR-REPO-FOLDERS][5]: the
  file cites it at line 7 (header).

### Variants (4 lit files)

The group holds the files of automation/Catzc.Base.Variants; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Variants/Get-Aspect.ps1][203], in the cell automation × powershell: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Variants/configs/variants.yml][204], in the cell automation × yaml: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 30 (body comment) (a passing mention only).
- [automation/Catzc.Base.Variants/types/VariantAspect.cs][205], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 2 (header).
- [automation/Catzc.Base.Variants/types/VariantsConfig.cs][206], in the cell automation × csharp: selected by [ADR-DSGN-ASPECT][1]: the file
  cites it at line 18 (header).

### Languages (3 lit files)

The group holds the files of automation/Catzc.Base.Languages; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Languages/types/BashConfig.cs][207], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 12 (header).
- [automation/Catzc.Base.Languages/types/GoConfig.cs][208], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).
- [automation/Catzc.Base.Languages/types/PythonConfig.cs][209], in the cell automation × csharp: selected by [ADR-REPO-FOLDERS][5]: the file
  cites it at line 15 (header).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][210], in the cell docs × markdown: selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 752 (text).
- [docs/adr/index.md][211], in the cell docs × markdown: selected by [ADR-DSGN-ASPECT][1]: the file cites it at line 95 (text); selected by
  [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 111 (text); selected by [ADR-PWSH-MANIFEST][3]: the file cites it at line 174 (text);
  selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 172 (text); selected by [ADR-REPO-FOLDERS][5]: the file cites it at line 286
  (text).

### .claude (1 lit file)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][212], in the cell .claude × markdown: selected by [ADR-PWSH-ONEFUNC][4]: the file cites it at line 45 (text).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][213], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][2]: the file cites it at line 4
  (body comment) (a passing mention only).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][214], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][2]:
  the file cites it at line 6 (header).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1][215], in the cell automation × powershell: selected by
  [ADR-REPO-FOLDERS][5]: the file cites it at line 8 (header) and line 89 (body comment).

## Keywords

- [world map][216]
- [track][217]
- [file language][218]
- [cell][219]
- [lit cell][220]
- [.claude][204]: a track
- [.github][204]: a track
- [automation][204]: a track
- [docs][204]: a track
- [pipelines][204]: a track
- [csharp][221]: a file language
- [markdown][221]: a file language
- [pipeline-yaml][221]: a file language
- [powershell][221]: a file language
- [yaml][221]: a file language

Terms the cited ADRs define:

- [domain][222], defined by [ADR-REPO-FOLDERS#5][223]

[1]: ../../adr/design/module-aspects.md
[2]: ../../adr/flow/durable-sha-globs.md
[3]: ../../adr/pwsh/dynamic-module-manifests.md
[4]: ../../adr/pwsh/one-function-per-file.md
[5]: ../../adr/repository/conventional-folders.md
[6]: adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
[7]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
[8]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md
[9]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
[10]: adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md
[11]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
[12]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md
[13]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
[14]: adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md
[15]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.chain.md
[16]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.drawio.md
[17]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.grid.md
[18]: adr-dsgn-aspect--manifest-and-aspects-from-one-folder--implementation.tree.md
[19]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.chain.md
[20]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.drawio.md
[21]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.grid.md
[22]: adr-dsgn-aspect--one-folder-two-independent-readers--architecture.tree.md
[23]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[24]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[25]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[26]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[27]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[28]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[29]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[30]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[31]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[32]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[33]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[34]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
[35]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[36]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[37]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[38]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
[39]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[40]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[41]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[42]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[43]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[44]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[45]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[46]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
[47]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[48]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[49]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[50]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
[51]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[52]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[53]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[54]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md
[55]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[56]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[57]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[58]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[59]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[60]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[61]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[62]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md
[63]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[64]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[65]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[66]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
[67]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[68]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[69]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[70]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
[71]: ../../explanation/automation/what-gates-each-bundle-stage.md
[72]: ../../explanation/design/drop-a-file-the-import-exports-it.md
[73]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[74]: ../../explanation/design/manifest-and-aspects-from-one-folder.md
[75]: ../../explanation/design/one-folder-two-independent-readers.md
[76]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[77]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[78]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[79]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[80]: ../../explanation/flow/gates-check-source-and-trigger.md
[81]: ../../explanation/flow/globs-module-owns-config-and-types.md
[82]: ../../explanation/flow/independence-check-groups-by-layer.md
[83]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[84]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[85]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[86]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[87]: ../../explanation/flow/two-declared-layers-one-derived.md
[88]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[89]: ../../references/automation/catzc-base-globs.md
[90]: ../../references/automation/catzc-base-languages.md
[91]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[92]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[93]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[94]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[95]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[96]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[97]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[98]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[99]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[100]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[101]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[102]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[103]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[104]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[105]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[106]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[107]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[108]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[109]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[110]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[111]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[112]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[113]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[114]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[115]: ../../../automation/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
[116]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[117]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[118]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[119]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[120]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[121]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[122]: ../../../automation/Catzc.Base.Globs/tests/types/Aspect.Tests.ps1
[123]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[124]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[125]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[126]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[127]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[128]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[129]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[130]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[131]: ../../adr/pwsh/announce-state-changes.md
[132]: ../../adr/pwsh/assert-idioms.md
[133]: ../../adr/pwsh/automatic-variable-pitfalls.md
[134]: ../../adr/pwsh/avoid-using-semicolons.md
[135]: ../../adr/pwsh/cross-platform-powershell.md
[136]: ../../adr/pwsh/dora-explains.md
[137]: ../../adr/pwsh/environment-variable-mechanics.md
[138]: ../../adr/pwsh/error-handling.md
[139]: ../../adr/pwsh/hosting-csharp-types.md
[140]: ../../adr/pwsh/identifier-names.md
[141]: ../../adr/pwsh/index.md
[142]: ../../adr/pwsh/module-path-hygiene.md
[143]: ../../adr/pwsh/parameter-design.md
[144]: ../../adr/pwsh/pester-testing.md
[145]: ../../adr/pwsh/powershell-formatting.md
[146]: ../../adr/pwsh/prefer-dryrun-over-shouldprocess.md
[147]: ../../adr/pwsh/prefer-foreach-over-foreach-object.md
[148]: ../../adr/pwsh/prepost-extension-modules.md
[149]: ../../adr/pwsh/pwsh-engine.md
[150]: ../../adr/pwsh/respect-pwsh-verb-rules.md
[151]: ../../adr/pwsh/script-scope-caching.md
[152]: ../../adr/pwsh/use-ps1-not-psm1.md
[153]: ../../adr/pwsh/vendor-toolset-dependencies.md
[154]: ../../adr/pwsh/working-directory-mechanics.md
[155]: ../../adr/repository/agent-definitions.md
[156]: ../../adr/repository/api-contracts.md
[157]: ../../adr/repository/controlled-vocabulary.md
[158]: ../../adr/repository/dedicated-output-directory.md
[159]: ../../adr/repository/documentation-examples.md
[160]: ../../adr/repository/domain-language-separation.md
[161]: ../../adr/repository/dora-explains.md
[162]: ../../adr/repository/generated-readmes.md
[163]: ../../adr/repository/generated-root-configs.md
[164]: ../../adr/repository/inspiration.md
[165]: ../../adr/repository/markdown-links.md
[166]: ../../adr/repository/output-formats.md
[167]: ../../adr/repository/repo-variants.md
[168]: ../../adr/repository/uniform-formatting.md
[169]: ../../adr/design/commit-lifecycle.md
[170]: ../../adr/design/dora-explains.md
[171]: ../../adr/design/run-modes.md
[172]: ../../adr/design/self-service.md
[173]: ../../adr/design/server-remote-integration.md
[174]: ../../adr/design/thin-platforms.md
[175]: ../../adr/design/tracks.md
[176]: ../../adr/design/visual-design.md
[177]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[178]: ../../../automation/Catzc.Base.QualityGates/configs/terminology.yml
[179]: ../../../automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
[180]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[181]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[182]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[183]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[184]: ../../adr/flow/dora-explains.md
[185]: ../../adr/flow/pipeline-detection.md
[186]: ../../adr/flow/pipeline-runner-pattern.md
[187]: ../../adr/flow/pipeline-types.md
[188]: ../../../pipelines/cd-apex.yaml
[189]: ../../../pipelines/cd-flux.yaml
[190]: ../../../pipelines/cd-nova.yaml
[191]: ../../../pipelines/cd-shared.yaml
[192]: ../../../pipelines/ci-automation.yaml
[193]: ../../../pipelines/ci-infrastructure.yaml
[194]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[195]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[196]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[197]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[198]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[199]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[200]: ../../../automation/Catzc.Base.Docs/configs/agents.yml
[201]: ../../../automation/Catzc.Base.Docs/configs/glossary.yml
[202]: ../../../automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
[203]: ../../../automation/Catzc.Base.Variants/Get-Aspect.ps1
[204]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[205]: ../../../automation/Catzc.Base.Variants/types/VariantAspect.cs
[206]: ../../../automation/Catzc.Base.Variants/types/VariantsConfig.cs
[207]: ../../../automation/Catzc.Base.Languages/types/BashConfig.cs
[208]: ../../../automation/Catzc.Base.Languages/types/GoConfig.cs
[209]: ../../../automation/Catzc.Base.Languages/types/PythonConfig.cs
[210]: ../../adr/glossary.md
[211]: ../../adr/index.md
[212]: ../../../.claude/CLAUDE.md
[213]: ../../../.github/workflows/ci-automation.yml
[214]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[215]: ../../../automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
[216]: ../../adr/glossary.md#world-map
[217]: ../../adr/glossary.md#track
[218]: ../../adr/glossary.md#file-language
[219]: ../../adr/glossary.md#cell
[220]: ../../adr/glossary.md#lit-cell
[221]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[222]: ../../adr/glossary.md#domain
[223]: ../../adr/repository/conventional-folders.md#rule-adr-repo-folders5
