# docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md

`Tree minimap: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta`

![Tree minimap of adr-flow-cd-globs--three-views-derived-live-from-one-program--meta](adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.png)

The tree minimap of the slide `adr-flow-cd-globs--three-views-derived-live-from-one-program--meta` (meta lens). The slide supports
[ADR-FLOW-CD-GLOBS][1]; the highlight of those ADR codes selects what is lit, and each reason below names the code that selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 127 files in 10 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 64 lit files
- Globs (automation/Catzc.Base.Globs): 38 lit files
- adr/flow (docs/adr/flow): 6 lit files
- pipelines: 6 lit files
- Az.DevOps.BuildValidation (automation/Catzc.Azure.DevOps.BuildValidation): 5 lit files
- QualityGates (automation/Catzc.Base.QualityGates): 4 lit files
- .github: 1 lit file
- Docs (automation/Catzc.Base.Docs): 1 lit file
- Exporter (automation/Catzc.Base.Exporter): 1 lit file
- adr/* (the files directly in docs/adr/): 1 lit file

## Why each group is lit

### docs (64 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md][2], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 30 (text) and line 30 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md][3], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md][4], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 38 (text), line 47 (text), line 48 (text), line 50
  (text), line 52 (text), line 56 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 78 (text), line 79 (text),
  line 81 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 90 (text), line 92 (text), line 93 (text), line 95
  (text), line 97 (text), line 98 (text), line 100 (text), line 102 (text), line 103 (text), line 104 (text), line 106 (text), line 108
  (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 122 (text), line 124 (text), line 126
  (text), line 128 (text), line 130 (text), line 132 (text), line 135 (text), line 137 (text), line 139 (text), line 143 (text), line 146
  (text), line 149 (text), line 151 (text), line 160 (text), line 163 (text), line 169 (text), line 191 (text), line 196 (text), line 199
  (text), line 201 (text), line 203 (text), line 205 (text), line 207 (text), line 209 (text), line 211 (text), line 212 (text), line 215
  (text), line 217 (text), line 234 (text), line 236 (text), line 238 (text), line 240 (text), line 242 (text), line 244 (text), line 247
  (text), line 338 (text), line 342 (text), line 346 (text), line 350 (text), line 352 (text), line 354 (text), line 356 (text), line 359
  (text), line 361 (text), line 363 (text), line 365 (text), line 367 (text), line 369 (text), line 371 (text), line 373 (text), line 375
  (text), line 384 (text), line 385 (text), line 386 (text), line 387 (text), line 388 (text) and line 389 (text).
- [docs/.assets/explanation/adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md][5], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 40 (text), line 42 (text), line 44 (text), line 46
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
  line 415 (text), line 417 (text), line 424 (text), line 464 (text), line 478 (text) and line 485 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][6], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 33 (text) and line 33 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md][7], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 60 (text) and line 68 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][8], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 49 (text), line 65 (text), line 66 (text), line 68 (text),
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
  455 (text), line 466 (text), line 467 (text), line 468 (text), line 469 (text), line 471 (text) and line 472 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][9], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 41 (text), line 60 (text), line 75 (text), line 77 (text),
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
  (text), line 497 (text), line 499 (text), line 501 (text), line 547 (text), line 554 (text) and line 561 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md][10], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md][11], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md][12], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40
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
- [docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md][13], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38
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
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md][14], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md][15], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 66 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md][16], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md][17], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md][18], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 27 (text) and line 27 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md][19], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 65 (text) and line 73 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md][20], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 44 (text), line 54 (text), line 55 (text), line 57 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md][21], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 71 (text), line 126 (text), line 134 (text), line 158 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md][22], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md][23], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md][24], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md][25], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md][26], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md][27], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md][28], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md][29], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md][30], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 25 (text) and line 25 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md][31], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md][32], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md][33], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md][34], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 36 (text) and line 36 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md][35], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 61 (text) and line 68 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md][36], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 45 (text), line 55 (text), line 56 (text), line 58 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md][37], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 72 (text), line 128 (text), line 136 (text), line 160 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md][38], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md][39], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md][40], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text), line 42
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
- [docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md][41], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line 40
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
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md][42], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md][43], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md][44], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md][45], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md][46], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 24 (text) and line 24 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md][47], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 62 (text).
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md][48], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 29 (text), line 37 (text), line 38 (text), line 40 (text),
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
- [docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md][49], in the cell docs × markdown:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
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
- [docs/explanation/design/every-file-in-exactly-one-aspect.md][50], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 51 (text).
- [docs/explanation/design/one-folder-two-independent-readers.md][51], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 59 (text).
- [docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md][52], in the cell docs × markdown: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 49 (text) and line 67 (text).
- [docs/explanation/design/unit-to-pipeline-rule-is-review-only.md][53], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 59 (text) and line 59 (text).
- [docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md][54], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 16 (text), line 47 (text), line 49 (text) and line 53 (text).
- [docs/explanation/flow/edit-globs-yml-then-read-the-output.md][55], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text), line 47 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/gates-check-source-and-trigger.md][56], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 57
  (text), line 58 (text), line 59 (text), line 59 (text), line 61 (text) and line 72 (text).
- [docs/explanation/flow/globs-module-owns-config-and-types.md][57], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 51 (text) and line 52 (text).
- [docs/explanation/flow/independence-check-groups-by-layer.md][58], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 17 (text), line 52 (text), line 54 (text), line 58 (text) and line 58 (text).
- [docs/explanation/flow/one-scan-program-feeds-three-roles.md][59], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 18 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 61 (text) and line 62 (text).
- [docs/explanation/flow/overlap-gated-for-units-and-modules.md][60], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 16 (text), line 49 (text) and line 51 (text).
- [docs/explanation/flow/peers-in-a-layer-never-overlap.md][61], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 13 (text), line 38 (text) and line 40 (text).
- [docs/explanation/flow/three-views-derived-live-from-one-program.md][62], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 14 (text), line 37 (text), line 38 (text), line 39 (text) and line 40 (text).
- [docs/explanation/flow/two-declared-layers-one-derived.md][63], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 15 (text), line 47 (text), line 49 (text), line 51 (text) and line 53 (text).
- [docs/how-to/automation/manual-test-plan/pipelines-and-globs.md][64], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 18 (text).
- [docs/references/automation/catzc-base-globs.md][65], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 29 (text).

### Globs (38 lit files)

The group holds the files of automation/Catzc.Base.Globs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1][66], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 4 (header) and line 8 (header).
- [automation/Catzc.Base.Globs/Get-GlobSet.ps1][67], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetFile.ps1][68], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 6 (header) and line 9 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetHash.ps1][69], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 4 (header) and line 10 (header).
- [automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1][70], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 4 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1][71], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1][72], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 72 (body comment), line 75 (body comment) and line 163 (body comment) (a passing mention only).
- [automation/Catzc.Base.Globs/Get-TrackedFile.ps1][73], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 6 (header).
- [automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1][74], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1][75], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1][76], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]: the
  file cites it at line 10 (header).
- [automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1][77], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 4 (header), line 13 (header), line 42 (body comment), line 50 (body comment) and line 79 (text).
- [automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1][78], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/configs/globs.yml][79], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 2 (header), line 7 (header), line 15 (header), line 17 (header), line 26 (body comment), line 61 (body comment) and line 81 (body
  comment).
- [automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1][80], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1][81], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 6 (header).
- [automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1][82], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1][83], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 11 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1][84], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1][85], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1][86], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header) and line 3 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1][87], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1][88], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1][89], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1][90], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1][91], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1 (header).
- [automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1][92], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header), line 10 (text) and line 12 (text).
- [automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1][93], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 2 (header).
- [automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1][94], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1][95], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header).
- [automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1][96], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 1 (header), line 3 (header) and line 63 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1][97], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 2 (header), line 4 (header) and line 15 (text).
- [automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1][98], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 3 (header), line 5 (header), line 13 (body comment), line 62 (text), line 75 (text),
  line 86 (text) and line 98 (text).
- [automation/Catzc.Base.Globs/types/Aspect.cs][99], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 9 (header).
- [automation/Catzc.Base.Globs/types/DurableHash.cs][100], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 1 (header) and line 7 (header).
- [automation/Catzc.Base.Globs/types/GlobPattern.cs][101], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 7 (header), line 8 (header), line 9 (header), line 33 (text), line 37 (text), line 41 (text), line 53 (text), line 57
  (text) and line 66 (text).
- [automation/Catzc.Base.Globs/types/GlobSet.cs][102], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites
  it at line 3 (header), line 5 (header), line 6 (header), line 12 (header), line 15 (header), line 17 (header), line 20 (header), line 32
  (body comment), line 41 (body comment), line 63 (body comment), line 89 (text), line 122 (body comment), line 135 (body comment), line 158
  (body comment) and line 180 (body comment).
- [automation/Catzc.Base.Globs/types/GlobsConfig.cs][103], in the cell automation × csharp: selected by [ADR-FLOW-CD-GLOBS][1]: the file
  cites it at line 3 (header), line 7 (header), line 10 (header), line 88 (text), line 143 (body comment), line 154 (text), line 158 (text)
  and line 172 (text).

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][104], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of
  the `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][105], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][1], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][106], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][107], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][108], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.

### pipelines (6 lit files)

The group holds the files of pipelines; each sits in its world-map cell and is lit by:

- [pipelines/cd-apex.yaml][109], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 15
  (header).
- [pipelines/cd-flux.yaml][110], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-nova.yaml][111], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 14
  (header).
- [pipelines/cd-shared.yaml][112], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 29
  (header).
- [pipelines/ci-automation.yaml][113], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line
  4 (header).
- [pipelines/ci-infrastructure.yaml][114], in the cell pipelines × pipeline-yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at
  line 17 (header).

### Az.DevOps.BuildValidation (5 lit files)

The group holds the files of automation/Catzc.Azure.DevOps.BuildValidation; each sits in its world-map cell and is lit by:

- [automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1][115], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 10 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1][116], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header) and line 98 (body comment).
- [automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1][117], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 6 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml][118], in the cell automation × yaml: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 5 (header).
- [automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1][119], in the cell automation × powershell:
  selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 8 (header).

### QualityGates (4 lit files)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/Test-Automation.ps1][120], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 72 (header).
- [automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1][121], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 7 (header).
- [automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1][122], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 143 (body comment) (a passing mention only).
- [automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1][123], in the cell automation × powershell: selected by
  [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 9 (header).

### .github (1 lit file)

The group holds the files of .github; each sits in its world-map cell and is lit by:

- [.github/workflows/ci-automation.yml][124], in the cell .github × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 4
  (body comment) (a passing mention only).

### Docs (1 lit file)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][125], in the cell automation × yaml: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it
  at line 122 (text).

### Exporter (1 lit file)

The group holds the files of automation/Catzc.Base.Exporter; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1][126], in the cell automation × powershell: selected by [ADR-FLOW-CD-GLOBS][1]:
  the file cites it at line 6 (header).

### adr/* (1 lit file)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/index.md][127], in the cell docs × markdown: selected by [ADR-FLOW-CD-GLOBS][1]: the file cites it at line 111 (text).

## Keywords

- [world map][128]
- [track][129]
- [file language][130]
- [cell][131]
- [lit cell][132]
- [.github][133]: a track
- [automation][133]: a track
- [docs][133]: a track
- [pipelines][133]: a track
- [csharp][134]: a file language
- [markdown][134]: a file language
- [pipeline-yaml][134]: a file language
- [powershell][134]: a file language
- [yaml][134]: a file language

[1]: ../../adr/flow/durable-sha-globs.md
[2]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.chain.md
[3]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.drawio.md
[4]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.grid.md
[5]: adr-dsgn-aspect--partition-integrity-runs-only-in-unit-tests--governance.tree.md
[6]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[7]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
[8]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[9]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[10]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
[11]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
[12]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
[13]: adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
[14]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
[15]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
[16]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
[17]: adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
[18]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
[19]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
[20]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
[21]: adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
[22]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
[23]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
[24]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
[25]: adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
[26]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
[27]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md
[28]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
[29]: adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
[30]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.chain.md
[31]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.drawio.md
[32]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.grid.md
[33]: adr-flow-cd-globs--one-scan-program-feeds-three-roles--implementation.tree.md
[34]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
[35]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
[36]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
[37]: adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
[38]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md
[39]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
[40]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md
[41]: adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md
[42]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
[43]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
[44]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
[45]: adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
[46]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
[47]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
[48]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
[49]: adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
[50]: ../../explanation/design/every-file-in-exactly-one-aspect.md
[51]: ../../explanation/design/one-folder-two-independent-readers.md
[52]: ../../explanation/design/partition-integrity-runs-only-in-unit-tests.md
[53]: ../../explanation/design/unit-to-pipeline-rule-is-review-only.md
[54]: ../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md
[55]: ../../explanation/flow/edit-globs-yml-then-read-the-output.md
[56]: ../../explanation/flow/gates-check-source-and-trigger.md
[57]: ../../explanation/flow/globs-module-owns-config-and-types.md
[58]: ../../explanation/flow/independence-check-groups-by-layer.md
[59]: ../../explanation/flow/one-scan-program-feeds-three-roles.md
[60]: ../../explanation/flow/overlap-gated-for-units-and-modules.md
[61]: ../../explanation/flow/peers-in-a-layer-never-overlap.md
[62]: ../../explanation/flow/three-views-derived-live-from-one-program.md
[63]: ../../explanation/flow/two-declared-layers-one-derived.md
[64]: ../../how-to/automation/manual-test-plan/pipelines-and-globs.md
[65]: ../../references/automation/catzc-base-globs.md
[66]: ../../../automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1
[67]: ../../../automation/Catzc.Base.Globs/Get-GlobSet.ps1
[68]: ../../../automation/Catzc.Base.Globs/Get-GlobSetFile.ps1
[69]: ../../../automation/Catzc.Base.Globs/Get-GlobSetHash.ps1
[70]: ../../../automation/Catzc.Base.Globs/Get-GlobSetTrigger.ps1
[71]: ../../../automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
[72]: ../../../automation/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
[73]: ../../../automation/Catzc.Base.Globs/Get-TrackedFile.ps1
[74]: ../../../automation/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
[75]: ../../../automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
[76]: ../../../automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
[77]: ../../../automation/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
[78]: ../../../automation/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
[79]: ../../../automation/Catzc.Base.Globs/configs/globs.yml
[80]: ../../../automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1
[81]: ../../../automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1
[82]: ../../../automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
[83]: ../../../automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1
[84]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1
[85]: ../../../automation/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
[86]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1
[87]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1
[88]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1
[89]: ../../../automation/Catzc.Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1
[90]: ../../../automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1
[91]: ../../../automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
[92]: ../../../automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
[93]: ../../../automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
[94]: ../../../automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1
[95]: ../../../automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
[96]: ../../../automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1
[97]: ../../../automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
[98]: ../../../automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
[99]: ../../../automation/Catzc.Base.Globs/types/Aspect.cs
[100]: ../../../automation/Catzc.Base.Globs/types/DurableHash.cs
[101]: ../../../automation/Catzc.Base.Globs/types/GlobPattern.cs
[102]: ../../../automation/Catzc.Base.Globs/types/GlobSet.cs
[103]: ../../../automation/Catzc.Base.Globs/types/GlobsConfig.cs
[104]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[105]: ../../adr/flow/dora-explains.md
[106]: ../../adr/flow/pipeline-detection.md
[107]: ../../adr/flow/pipeline-runner-pattern.md
[108]: ../../adr/flow/pipeline-types.md
[109]: ../../../pipelines/cd-apex.yaml
[110]: ../../../pipelines/cd-flux.yaml
[111]: ../../../pipelines/cd-nova.yaml
[112]: ../../../pipelines/cd-shared.yaml
[113]: ../../../pipelines/ci-automation.yaml
[114]: ../../../pipelines/ci-infrastructure.yaml
[115]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
[116]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
[117]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
[118]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
[119]: ../../../automation/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
[120]: ../../../automation/Catzc.Base.QualityGates/Test-Automation.ps1
[121]: ../../../automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1
[122]: ../../../automation/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
[123]: ../../../automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
[124]: ../../../.github/workflows/ci-automation.yml
[125]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[126]: ../../../automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
[127]: ../../adr/index.md
[128]: ../../adr/glossary.md#world-map
[129]: ../../adr/glossary.md#track
[130]: ../../adr/glossary.md#file-language
[131]: ../../adr/glossary.md#cell
[132]: ../../adr/glossary.md#lit-cell
[133]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[134]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
