# docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md

`Tree minimap: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations`

![Tree minimap of adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.png)

The tree minimap of the slide `adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations` (operations lens). The slide supports
[ADR-DSGN-LIFE][1] and [ADR-FLOW-CD][2]; the highlight of those ADR codes selects what is lit, and each reason below names the code that
selects it.

## What the minimap shows

The tree draws every file of the world map as a tile, grouped by top-level folder (under `automation/` by module, under `docs/adr/` by ADR
domain), and lights 131 files in 9 groups, filled in ink. A lit ADR file has a white rim; a file lit only by passing mentions is a lighter
ink. Every other tile is idle, a grey box: a file the slide's ADR codes do not select.

- docs (docs/ outside docs/adr/): 103 lit files
- adr/dsgn (docs/adr/design): 9 lit files
- adr/flow (docs/adr/flow): 6 lit files
- .claude: 3 lit files
- Docs (automation/Catzc.Base.Docs): 3 lit files
- Maps (automation/Catzc.Base.Maps): 3 lit files
- adr/* (the files directly in docs/adr/): 2 lit files
- ModuleSystem (automation/Catzc.Base.ModuleSystem): 1 lit file
- QualityGates (automation/Catzc.Base.QualityGates): 1 lit file

## Why each group is lit

### docs (103 lit files)

The group holds the files of docs/ outside docs/adr/; each sits in its world-map cell and is lit by:

- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md][3], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line
  42 (text), line 42 (text) and line 56 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md][4], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md][5], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line
  44 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text),
  line 61 (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77
  (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text),
  line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line
  107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md][6], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line
  37 (text), line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text),
  line 55 (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70
  (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text),
  line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line
  111 (text), line 118 (text), line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md][7], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38
  (text), line 49 (text), line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md][8], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md][9], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line
  51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md][10], in the cell docs ×
  markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37
  (text), line 39 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text),
  line 57 (text), line 60 (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77
  (text), line 79 (text), line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text),
  line 100 (text), line 108 (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text),
  line 128 (text), line 130 (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md][11], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text),
  line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md][12], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 68 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md][13], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68
  (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102
  (text), line 104 (text), line 107 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md][14], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59
  (text), line 61 (text), line 64 (text), line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text),
  line 80 (text), line 82 (text), line 85 (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107
  (text), line 110 (text), line 113 (text), line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129
  (text), line 139 (text), line 148 (text), line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md][15], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28
  (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md][16], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md][17], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48
  (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text),
  line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line
  127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line
  151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line
  181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md][18], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line
  65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104
  (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151
  (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177
  (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213
  (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md][19], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line
  49 (text), line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md][20], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 75 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md][21], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line
  51 (text), line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text),
  line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text),
  line 103 (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text),
  line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md][22], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line
  39 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text),
  line 60 (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79
  (text), line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text),
  line 108 (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text),
  line 130 (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md][23], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28
  (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md][24], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 71 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md][25], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48
  (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text),
  line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line
  127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line
  151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line
  181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md][26], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line
  65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104
  (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151
  (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177
  (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213
  (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md][27], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line
  58 (text), line 58 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28
  (text), line 39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md][28], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md][29], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line
  72 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text),
  line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line
  115 (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line
  138 (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line
  155 (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text);
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48
  (text), line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text),
  line 92 (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line
  127 (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line
  151 (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line
  181 (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md][30], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text),
  line 61 (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86
  (text), line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text),
  line 126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text),
  line 142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line
  65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104
  (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151
  (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177
  (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213
  (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md][31], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md][32], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md][33], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md][34], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.chain.md][35], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 26 (text), line 37 (text), line 37 (text), line 48 (text),
  line 48 (text) and line 65 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md][36], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 69 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.grid.md][37], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 27 (text), line 36 (text), line 40 (text), line 47 (text), line 50 (text),
  line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63 (text), line 65 (text), line 68
  (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 102
  (text), line 104 (text), line 107 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 118 (text), line 120
  (text), line 122 (text), line 125 (text), line 128 (text), line 130 (text), line 133 (text) and line 152 (text).
- [docs/.assets/explanation/adr-dsgn-life--one-way-climb-three-endings--meta.tree.md][38], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 34 (text), line 36 (text), line 38 (text),
  line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 52 (text), line 54 (text), line 56 (text), line 59
  (text), line 61 (text), line 64 (text), line 66 (text), line 68 (text), line 71 (text), line 74 (text), line 76 (text), line 78 (text),
  line 80 (text), line 82 (text), line 85 (text), line 87 (text), line 90 (text), line 94 (text), line 96 (text), line 99 (text), line 107
  (text), line 110 (text), line 113 (text), line 116 (text), line 118 (text), line 121 (text), line 124 (text), line 127 (text), line 129
  (text), line 139 (text), line 148 (text), line 157 (text), line 158 (text), line 165 (text) and line 183 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md][39], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 38 (text), line 38 (text), line 49 (text),
  line 49 (text) and line 66 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md][40], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 64 (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md][41], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 28 (text), line 37 (text), line 41 (text), line 48 (text), line 51 (text),
  line 52 (text), line 54 (text), line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 69
  (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 88 (text), line 90 (text), line 92 (text), line 94 (text), line 96 (text), line 98 (text), line 99 (text), line 101 (text), line 103
  (text), line 105 (text), line 108 (text), line 111 (text), line 113 (text), line 115 (text), line 117 (text), line 119 (text), line 121
  (text), line 123 (text), line 126 (text), line 129 (text), line 131 (text), line 134 (text) and line 153 (text).
- [docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md][42], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 35 (text), line 37 (text), line 39 (text),
  line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 57 (text), line 60
  (text), line 62 (text), line 65 (text), line 67 (text), line 69 (text), line 72 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 86 (text), line 88 (text), line 91 (text), line 95 (text), line 97 (text), line 100 (text), line 108
  (text), line 111 (text), line 114 (text), line 117 (text), line 119 (text), line 122 (text), line 125 (text), line 128 (text), line 130
  (text), line 140 (text), line 149 (text), line 158 (text), line 159 (text), line 166 (text) and line 184 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md][43], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 26 (text), line 26 (text), line 34 (text), line 34 (text), line 42 (text),
  line 42 (text) and line 56 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md][44], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 63 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md][45], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 26 (text), line 33 (text), line 34 (text), line 41 (text), line 44 (text),
  line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61
  (text), line 63 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text),
  line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 85 (text), line 87 (text), line 88 (text), line 89 (text), line 91
  (text), line 93 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107
  (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 118 (text) and line 136 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md][46], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 7 (text), line 29 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text),
  line 39 (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55
  (text), line 57 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 87 (text), line 95
  (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text), line 107 (text), line 109 (text), line 111
  (text), line 118 (text), line 119 (text), line 125 (text), line 132 (text), line 139 (text) and line 157 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md][47], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 58 (text),
  line 58 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line
  39 (text), line 39 (text), line 50 (text), line 50 (text), line 61 (text), line 61 (text), line 75 (text) and line 77 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md][48], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 65 (text) and line 74 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 65
  (text) and line 74 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md][49], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 58 (text), line 60 (text), line 69 (text), line 72 (text),
  line 73 (text), line 75 (text), line 77 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 109 (text), line 111 (text), line 113 (text), line 115
  (text), line 116 (text), line 118 (text), line 120 (text), line 122 (text), line 123 (text), line 134 (text), line 136 (text), line 138
  (text), line 140 (text), line 142 (text), line 144 (text), line 146 (text), line 148 (text), line 150 (text), line 153 (text), line 155
  (text), line 158 (text), line 160 (text), line 162 (text), line 164 (text), line 166 (text), line 170 (text) and line 202 (text); selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 31 (text), line 38 (text), line 40 (text), line 48 (text),
  line 49 (text), line 50 (text), line 59 (text), line 61 (text), line 62 (text), line 76 (text), line 80 (text), line 82 (text), line 92
  (text), line 94 (text), line 99 (text), line 102 (text), line 103 (text), line 105 (text), line 107 (text), line 125 (text), line 127
  (text), line 128 (text), line 129 (text), line 131 (text), line 133 (text), line 134 (text), line 136 (text), line 147 (text), line 151
  (text), line 156 (text), line 168 (text), line 172 (text), line 173 (text), line 175 (text), line 177 (text), line 179 (text), line 181
  (text), line 201 (text) and line 203 (text).
- [docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md][50], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line 41 (text),
  line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 58 (text), line 61
  (text), line 63 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text),
  line 89 (text), line 91 (text), line 94 (text), line 96 (text), line 98 (text), line 100 (text), line 102 (text), line 107 (text), line
  126 (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 136 (text), line 138 (text), line 140 (text), line
  142 (text), line 167 (text), line 175 (text), line 197 (text), line 199 (text), line 206 (text) and line 234 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 39 (text), line 43 (text), line 45 (text), line 55 (text), line 58 (text), line
  65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 83 (text), line 87 (text), line 92 (text), line 104
  (text), line 109 (text), line 110 (text), line 112 (text), line 114 (text), line 117 (text), line 119 (text), line 149 (text), line 151
  (text), line 153 (text), line 155 (text), line 157 (text), line 159 (text), line 166 (text), line 169 (text), line 176 (text), line 177
  (text), line 179 (text), line 186 (text), line 188 (text), line 190 (text), line 198 (text), line 200 (text), line 207 (text), line 213
  (text), line 233 (text) and line 235 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md][51], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 51 (text), line 51 (text), line 65 (text),
  line 65 (text) and line 97 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 29 (text), line 29 (text), line
  43 (text), line 43 (text), line 57 (text), line 57 (text), line 71 (text), line 71 (text), line 96 (text) and line 100 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md][52], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 67 (text) and line 76 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 67
  (text) and line 76 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md][53], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 39 (text), line 687 (text), line 699 (text), line 723 (text), line 726
  (text), line 727 (text), line 730 (text), line 731 (text), line 733 (text), line 735 (text), line 737 (text), line 739 (text), line 741
  (text), line 744 (text), line 746 (text), line 749 (text), line 752 (text), line 754 (text), line 849 (text), line 851 (text), line 853
  (text), line 855 (text), line 857 (text), line 859 (text), line 861 (text), line 863 (text), line 865 (text), line 879 (text), line 881
  (text), line 890 (text), line 892 (text), line 894 (text), line 897 (text), line 900 (text), line 902 (text), line 904 (text), line 907
  (text), line 909 (text), line 912 (text), line 914 (text), line 918 (text), line 921 (text), line 923 (text), line 928 (text) and line
  1013 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 42 (text), line 49 (text), line 52
  (text), line 309 (text), line 310 (text), line 316 (text), line 688 (text), line 700 (text), line 705 (text), line 730 (text), line 734
  (text), line 736 (text), line 747 (text), line 750 (text), line 756 (text), line 759 (text), line 760 (text), line 762 (text), line 764
  (text), line 867 (text), line 869 (text), line 870 (text), line 872 (text), line 874 (text), line 876 (text), line 879 (text), line 882
  (text), line 901 (text), line 905 (text), line 911 (text), line 925 (text), line 930 (text), line 931 (text), line 933 (text), line 935
  (text), line 939 (text), line 943 (text), line 1012 (text) and line 1016 (text).
- [docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md][54], in the cell docs × markdown: selected by
  [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 336 (text), line 338 (text), line 341 (text), line 343 (text), line 345
  (text), line 348 (text), line 350 (text), line 352 (text), line 355 (text), line 357 (text), line 360 (text), line 362 (text), line 365
  (text), line 369 (text), line 371 (text), line 394 (text), line 396 (text), line 398 (text), line 401 (text), line 404 (text), line 406
  (text), line 408 (text), line 411 (text), line 413 (text), line 416 (text), line 418 (text), line 422 (text), line 425 (text), line 427
  (text), line 433 (text), line 567 (text), line 729 (text), line 925 (text), line 928 (text), line 931 (text), line 934 (text), line 936
  (text), line 939 (text), line 942 (text), line 945 (text), line 947 (text), line 1024 (text), line 1210 (text), line 1213 (text) and line
  1297 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 114 (text), line 343 (text), line 348 (text), line 350
  (text), line 362 (text), line 366 (text), line 373 (text), line 375 (text), line 377 (text), line 379 (text), line 381 (text), line 405
  (text), line 409 (text), line 415 (text), line 429 (text), line 435 (text), line 437 (text), line 439 (text), line 441 (text), line 446
  (text), line 450 (text), line 568 (text), line 632 (text), line 635 (text), line 730 (text), line 846 (text), line 847 (text), line 858
  (text), line 1016 (text), line 1027 (text), line 1033 (text), line 1035 (text), line 1037 (text), line 1039 (text), line 1041 (text), line
  1043 (text), line 1211 (text), line 1214 (text), line 1296 (text) and line 1300 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md][55], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 36 (text), line 36 (text), line 47 (text), line 47 (text), line 55 (text),
  line 55 (text) and line 69 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md][56], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 70 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md][57], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 27 (text), line 34 (text), line 36 (text), line 43 (text), line 46 (text),
  line 47 (text), line 49 (text), line 51 (text), line 53 (text), line 55 (text), line 57 (text), line 59 (text), line 61 (text), line 63
  (text), line 65 (text), line 67 (text), line 69 (text), line 73 (text), line 79 (text), line 81 (text), line 83 (text), line 85 (text),
  line 87 (text), line 89 (text), line 91 (text), line 93 (text), line 95 (text), line 97 (text), line 98 (text), line 100 (text), line 103
  (text), line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 117 (text), line 120 (text), line 124
  (text), line 128 (text), line 130 (text), line 132 (text), line 134 (text), line 137 (text) and line 155 (text).
- [docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md][58], in the cell docs × markdown: selected
  by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 30 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text),
  line 40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56
  (text), line 61 (text), line 67 (text), line 70 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text),
  line 84 (text), line 87 (text), line 91 (text), line 95 (text), line 97 (text), line 99 (text), line 101 (text), line 104 (text), line 112
  (text), line 115 (text), line 118 (text), line 121 (text), line 123 (text), line 126 (text), line 129 (text), line 132 (text), line 134
  (text), line 142 (text), line 143 (text), line 150 (text), line 157 (text), line 164 (text) and line 182 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md][59], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 37 (text), line 37 (text), line 48 (text), line 48 (text), line
  56 (text), line 56 (text) and line 78 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md][60], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 73 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md][61], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 29 (text), line 51 (text), line 53 (text), line 61 (text), line
  64 (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 75 (text), line 77 (text), line 79 (text),
  line 81 (text), line 83 (text), line 85 (text), line 87 (text), line 91 (text), line 98 (text), line 100 (text), line 102 (text), line 104
  (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 116 (text), line 117 (text), line 149
  (text), line 152 (text), line 154 (text), line 156 (text), line 158 (text), line 160 (text), line 162 (text), line 166 (text), line 170
  (text), line 174 (text), line 178 (text), line 180 (text), line 182 (text), line 184 (text), line 187 (text) and line 207 (text).
- [docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md][62], in the cell docs × markdown:
  selected by [ADR-DSGN-LIFE][1]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 36 (text), line 38 (text), line
  40 (text), line 42 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 63 (text), line 69 (text), line 72 (text), line 74 (text), line 76 (text), line 78 (text), line 80 (text), line 82
  (text), line 87 (text), line 91 (text), line 96 (text), line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 109
  (text), line 152 (text), line 155 (text), line 158 (text), line 161 (text), line 163 (text), line 166 (text), line 169 (text), line 172
  (text), line 174 (text), line 184 (text), line 200 (text), line 201 (text), line 208 (text), line 215 (text) and line 236 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md][63], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 41 (text), line 41 (text), line 49 (text), line 49 (text), line 57
  (text), line 57 (text), line 65 (text), line 65 (text), line 91 (text) and line 93 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md][64], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 32 (text), line 34 (text), line 61 (text), line 63 (text), line 189
  (text), line 195 (text), line 209 (text), line 245 (text), line 259 (text), line 260 (text), line 272 (text), line 274 (text), line 276
  (text), line 278 (text), line 280 (text), line 293 (text), line 296 (text), line 297 (text), line 299 (text), line 301 (text), line 339
  (text), line 341 (text), line 343 (text), line 345 (text), line 347 (text), line 349 (text), line 353 (text), line 355 (text), line 392
  (text), line 396 (text), line 400 (text), line 409 (text), line 417 (text), line 419 (text), line 421 (text), line 423 (text), line 436
  (text), line 444 (text), line 498 (text) and line 500 (text).
- [docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md][65], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 44 (text), line 46 (text), line 48 (text), line 50 (text), line 52
  (text), line 65 (text), line 67 (text), line 69 (text), line 71 (text), line 73 (text), line 98 (text), line 102 (text), line 106 (text),
  line 115 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 143 (text), line 151 (text), line 263 (text),
  line 270 (text), line 288 (text), line 367 (text), line 383 (text), line 385 (text), line 440 (text), line 455 (text), line 458 (text),
  line 460 (text), line 462 (text), line 465 (text), line 468 (text), line 520 (text), line 522 (text), line 535 (text), line 544 (text),
  line 547 (text), line 588 (text) and line 590 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md][66], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md][67], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 72 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md][68], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line
  47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89
  (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and
  line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md][69], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text),
  line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and
  line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md][70], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43
  (text), line 43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md][71], in the cell docs ×
  markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 67 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md][72], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46
  (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text),
  line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md][73], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78
  (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text),
  line 106 (text), line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text),
  line 157 (text) and line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md][74], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 28 (text), line 39 (text), line 39 (text), line 50 (text),
  line 50 (text), line 61 (text), line 61 (text), line 78 (text) and line 79 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md][75], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text) and line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md][76], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 30 (text), line 31 (text), line 42 (text), line 44 (text), line 61 (text),
  line 62 (text), line 63 (text), line 73 (text), line 75 (text), line 76 (text), line 83 (text), line 85 (text), line 87 (text), line 89
  (text), line 91 (text), line 93 (text), line 96 (text), line 97 (text), line 99 (text), line 101 (text), line 103 (text), line 105 (text),
  line 107 (text), line 109 (text), line 111 (text), line 113 (text), line 115 (text), line 116 (text), line 118 (text), line 119 (text),
  line 121 (text), line 123 (text), line 125 (text), line 127 (text), line 129 (text), line 131 (text), line 134 (text), line 136 (text),
  line 166 (text) and line 167 (text).
- [docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md][77], in the cell docs × markdown: selected
  by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 36 (text), line 38 (text), line 40 (text), line 42 (text), line 44 (text),
  line 46 (text), line 48 (text), line 50 (text), line 53 (text), line 55 (text), line 56 (text), line 58 (text), line 60 (text), line 62
  (text), line 64 (text), line 66 (text), line 68 (text), line 70 (text), line 74 (text), line 76 (text), line 100 (text), line 103 (text),
  line 105 (text), line 107 (text), line 109 (text), line 111 (text), line 118 (text), line 120 (text), line 122 (text), line 129 (text),
  line 131 (text), line 133 (text), line 140 (text), line 141 (text), line 147 (text), line 149 (text), line 179 (text), line 186 (text),
  line 208 (text) and line 209 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md][78], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43 (text), line
  43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md][79], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 71 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md][80], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46 (text), line
  47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text), line 72 (text),
  line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88 (text), line 89
  (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text), line 100 (text),
  line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text), line 134 (text) and
  line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md][81], in the cell docs × markdown: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 7 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39 (text), line
  41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text), line 56 (text),
  line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78 (text), line 80
  (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text), line 106 (text),
  line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text), line 157 (text) and
  line 158 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md][82], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 27 (text), line 27 (text), line 35 (text), line 35 (text), line 43
  (text), line 43 (text), line 51 (text), line 51 (text), line 65 (text) and line 66 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md][83], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 74 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md][84], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 28 (text), line 29 (text), line 36 (text), line 38 (text), line 46
  (text), line 47 (text), line 48 (text), line 56 (text), line 58 (text), line 59 (text), line 66 (text), line 68 (text), line 70 (text),
  line 72 (text), line 74 (text), line 76 (text), line 79 (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 88
  (text), line 89 (text), line 90 (text), line 92 (text), line 94 (text), line 95 (text), line 96 (text), line 97 (text), line 98 (text),
  line 100 (text), line 102 (text), line 104 (text), line 106 (text), line 108 (text), line 110 (text), line 112 (text), line 114 (text),
  line 134 (text) and line 135 (text).
- [docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md][85], in the cell docs × markdown:
  selected by [ADR-FLOW-CD][2]: the file cites it at line 8 (text), line 31 (text), line 33 (text), line 35 (text), line 37 (text), line 39
  (text), line 41 (text), line 43 (text), line 45 (text), line 47 (text), line 49 (text), line 50 (text), line 52 (text), line 54 (text),
  line 56 (text), line 58 (text), line 60 (text), line 62 (text), line 64 (text), line 67 (text), line 69 (text), line 76 (text), line 78
  (text), line 80 (text), line 82 (text), line 84 (text), line 86 (text), line 93 (text), line 95 (text), line 97 (text), line 104 (text),
  line 106 (text), line 108 (text), line 115 (text), line 116 (text), line 122 (text), line 124 (text), line 130 (text), line 137 (text),
  line 157 (text) and line 158 (text).
- [docs/explanation/design/clients-bridge-to-one-server.md][86], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 15 (text), line 49 (text) and line 50 (text).
- [docs/explanation/design/code-wires-only-the-first-rungs.md][87], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text) and line 54 (text).
- [docs/explanation/design/deploy-and-integrate-share-only-the-topic.md][88], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]:
  the file cites it at line 15 (text), line 46 (text), line 48 (text) and line 55 (text).
- [docs/explanation/design/deploying-is-not-integrating.md][89], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 14 (text), line 43 (text), line 44 (text) and line 51 (text).
- [docs/explanation/design/engineer-merges-pipelines-do-the-rest.md][90], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 17 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 55 (text).
- [docs/explanation/design/every-deploy-stage-is-main-only.md][91], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 11 (text), line 16 (text), line 19 (text), line 36 (text), line 50 (text), line 55 (text) and line 57 (text).
- [docs/explanation/design/four-domains-promote-one-artifact.md][92], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 48 (text), line 50 (text), line 52 (text) and line 53 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 54 (text) and line 55 (text).
- [docs/explanation/design/ingress-gated-the-rest-by-review.md][93], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 16 (text), line 22 (text) and line 51 (text).
- [docs/explanation/design/integrators-depend-on-an-occupant.md][94], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 46 (text), line 47 (text), line 48 (text) and line 49 (text); selected by [ADR-FLOW-CD][2]: the file
  cites it at line 15 (text), line 50 (text) and line 51 (text).
- [docs/explanation/design/merging-to-main-is-what-deploys.md][95], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 15 (text), line 20 (text), line 44 (text) and line 49 (text).
- [docs/explanation/design/one-way-climb-three-endings.md][96], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites
  it at line 13 (text), line 41 (text), line 42 (text), line 43 (text), line 44 (text) and line 45 (text).
- [docs/explanation/design/out-of-band-deploy-is-adr-only.md][97], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 6 (text), line 15 (text), line 18 (text), line 23 (text), line 45 (text), line 46 (text) and line 54 (text).
- [docs/explanation/design/sync-from-the-last-certified-commit.md][98], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the
  file cites it at line 12 (text), line 34 (text), line 35 (text) and line 36 (text).
- [docs/explanation/design/sync-point-rules-are-adr-only.md][99], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 31 (text), line 31 (text), line 33 (text), line 37 (text), line 43 (text), line 44 (text), line 45
  (text), line 49 (text), line 50 (text), line 52 (text), line 52 (text), line 53 (text) and line 61 (text); selected by [ADR-FLOW-CD][2]:
  the file cites it at line 17 (text), line 34 (text), line 36 (text), line 38 (text), line 40 (text), line 54 (text), line 54 (text) and
  line 55 (text).
- [docs/explanation/design/which-rung-gates-exist-in-code.md][100], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 17 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 56 (text), line 57 (text), line 58 (text)
  and line 59 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 60 (text), line 60 (text), line 60 (text) and line 61 (text).
- [docs/explanation/flow/a-merge-runs-cd-to-prod.md][101], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 16 (text), line 48 (text), line 49 (text) and line 50 (text).
- [docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md][102], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the
  file cites it at line 15 (text), line 48 (text), line 49 (text), line 50 (text) and line 51 (text).
- [docs/explanation/flow/ci-budget-is-the-only-quality-gate.md][103], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 47 (text), line 51 (text), line 52 (text), line 53 (text), line 54 (text), line 55 (text), line 57 (text)
  and line 58 (text).
- [docs/explanation/flow/one-artifact-climbs-unchanged.md][104], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 15 (text), line 43 (text), line 44 (text), line 45 (text), line 46 (text), line 47 (text) and line 47 (text).
- [docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md][105], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 17 (text), line 54 (text), line 55 (text), line 57 (text), line 58 (text), line 60 (text) and line 62 (text).

### adr/dsgn (9 lit files)

The group holds the files of docs/adr/design; each sits in its world-map cell and is lit by:

- [docs/adr/design/commit-lifecycle.md][1], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/dora-explains.md][106], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/module-aspects.md][107], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/run-modes.md][108], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain,
  the ADR domain of that code.
- [docs/adr/design/self-service.md][109], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/server-remote-integration.md][110], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the
  `design` ADR domain, the ADR domain of that code.
- [docs/adr/design/thin-platforms.md][111], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.
- [docs/adr/design/tracks.md][112], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR domain, the
  ADR domain of that code.
- [docs/adr/design/visual-design.md][113], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: an ADR file of the `design` ADR
  domain, the ADR domain of that code.

### adr/flow (6 lit files)

The group holds the files of docs/adr/flow; each sits in its world-map cell and is lit by:

- [docs/adr/flow/cd-discipline-and-promotion-flow.md][2], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the
  `flow` ADR domain, the ADR domain of that code.
- [docs/adr/flow/dora-explains.md][114], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.
- [docs/adr/flow/durable-sha-globs.md][115], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-detection.md][116], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-runner-pattern.md][117], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR
  domain, the ADR domain of that code.
- [docs/adr/flow/pipeline-types.md][118], in the cell docs × markdown: selected by [ADR-FLOW-CD][2]: an ADR file of the `flow` ADR domain,
  the ADR domain of that code.

### .claude (3 lit files)

The group holds the files of .claude; each sits in its world-map cell and is lit by:

- [.claude/CLAUDE.md][119], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 51 (text).
- [.claude/agents/write-drawio-files.md][120], in the cell .claude × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 43
  (text).
- [.claude/drawio/STYLE.md][121], in the cell .claude × markdown: selected by [ADR-FLOW-CD][2]: the file cites it at line 28 (text).

### Docs (3 lit files)

The group holds the files of automation/Catzc.Base.Docs; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Docs/configs/adrs.yml][122], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file cites it at
  line 99 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 105 (body comment) and line 118 (text).
- [automation/Catzc.Base.Docs/types/AdrsConfig.cs][123], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites it at
  line 17 (header), line 18 (header), line 194 (body comment) and line 195 (body comment).
- [automation/Catzc.Base.Docs/types/GlossaryConcept.cs][124], in the cell automation × csharp: selected by [ADR-FLOW-CD][2]: the file cites
  it at line 41 (body comment) (a passing mention only).

### Maps (3 lit files)

The group holds the files of automation/Catzc.Base.Maps; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1][125], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 20 (header).
- [automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1][126], in the cell automation × powershell: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 31 (header).
- [automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1][127], in the cell automation × powershell: selected by
  [ADR-FLOW-CD][2]: the file cites it at line 70 (text) and line 71 (text).

### adr/* (2 lit files)

The group holds the files of the files directly in docs/adr/; each sits in its world-map cell and is lit by:

- [docs/adr/glossary.md][128], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 149 (text); selected
  by [ADR-FLOW-CD][2]: the file cites it at line 292 (text) and line 305 (text).
- [docs/adr/index.md][129], in the cell docs × markdown: selected by [ADR-DSGN-LIFE][1]: the file cites it at line 92 (text); selected by
  [ADR-FLOW-CD][2]: the file cites it at line 107 (text).

### ModuleSystem (1 lit file)

The group holds the files of automation/Catzc.Base.ModuleSystem; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.ModuleSystem/configs/glossary.yml][130], in the cell automation × yaml: selected by [ADR-DSGN-LIFE][1]: the file
  cites it at line 52 (text); selected by [ADR-FLOW-CD][2]: the file cites it at line 21 (text).

### QualityGates (1 lit file)

The group holds the files of automation/Catzc.Base.QualityGates; each sits in its world-map cell and is lit by:

- [automation/Catzc.Base.QualityGates/configs/glossary.yml][131], in the cell automation × yaml: selected by [ADR-FLOW-CD][2]: the file
  cites it at line 62 (text).

## Keywords

- [world map][132]
- [track][133]
- [file language][134]
- [cell][135]
- [lit cell][136]
- [.claude][137]: a track
- [automation][137]: a track
- [docs][137]: a track
- [csharp][138]: a file language
- [markdown][138]: a file language
- [powershell][138]: a file language
- [yaml][138]: a file language

Terms the cited ADRs define:

- [gate][139], defined by [ADR-FLOW-CD#13][140]
- [occupant][141], defined by [ADR-DSGN-LIFE#5][142]
- [release candidate][143], defined by [ADR-FLOW-CD#14][144]

[1]: ../../adr/design/commit-lifecycle.md
[2]: ../../adr/flow/cd-discipline-and-promotion-flow.md
[3]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
[4]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
[5]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
[6]: adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md
[7]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.chain.md
[8]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md
[9]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.grid.md
[10]: adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.tree.md
[11]: adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
[12]: adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
[13]: adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
[14]: adr-dsgn-life--deploying-is-not-integrating--meta.tree.md
[15]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
[16]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
[17]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
[18]: adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
[19]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
[20]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
[21]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
[22]: adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md
[23]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
[24]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
[25]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
[26]: adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
[27]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md
[28]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md
[29]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md
[30]: adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md
[31]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
[32]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
[33]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
[34]: adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md
[35]: adr-dsgn-life--one-way-climb-three-endings--meta.chain.md
[36]: adr-dsgn-life--one-way-climb-three-endings--meta.drawio.md
[37]: adr-dsgn-life--one-way-climb-three-endings--meta.grid.md
[38]: adr-dsgn-life--one-way-climb-three-endings--meta.tree.md
[39]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md
[40]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
[41]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md
[42]: adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md
[43]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
[44]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
[45]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
[46]: adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md
[47]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.chain.md
[48]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md
[49]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.grid.md
[50]: adr-dsgn-life--sync-point-rules-are-adr-only--governance.tree.md
[51]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
[52]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
[53]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
[54]: adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
[55]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md
[56]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md
[57]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md
[58]: adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md
[59]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
[60]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
[61]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
[62]: adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
[63]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
[64]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
[65]: adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
[66]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md
[67]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
[68]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md
[69]: adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md
[70]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
[71]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
[72]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
[73]: adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
[74]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md
[75]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md
[76]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md
[77]: adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md
[78]: adr-flow-cd--one-artifact-climbs-unchanged--meta.chain.md
[79]: adr-flow-cd--one-artifact-climbs-unchanged--meta.drawio.md
[80]: adr-flow-cd--one-artifact-climbs-unchanged--meta.grid.md
[81]: adr-flow-cd--one-artifact-climbs-unchanged--meta.tree.md
[82]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
[83]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md
[84]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
[85]: adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
[86]: ../../explanation/design/clients-bridge-to-one-server.md
[87]: ../../explanation/design/code-wires-only-the-first-rungs.md
[88]: ../../explanation/design/deploy-and-integrate-share-only-the-topic.md
[89]: ../../explanation/design/deploying-is-not-integrating.md
[90]: ../../explanation/design/engineer-merges-pipelines-do-the-rest.md
[91]: ../../explanation/design/every-deploy-stage-is-main-only.md
[92]: ../../explanation/design/four-domains-promote-one-artifact.md
[93]: ../../explanation/design/ingress-gated-the-rest-by-review.md
[94]: ../../explanation/design/integrators-depend-on-an-occupant.md
[95]: ../../explanation/design/merging-to-main-is-what-deploys.md
[96]: ../../explanation/design/one-way-climb-three-endings.md
[97]: ../../explanation/design/out-of-band-deploy-is-adr-only.md
[98]: ../../explanation/design/sync-from-the-last-certified-commit.md
[99]: ../../explanation/design/sync-point-rules-are-adr-only.md
[100]: ../../explanation/design/which-rung-gates-exist-in-code.md
[101]: ../../explanation/flow/a-merge-runs-cd-to-prod.md
[102]: ../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md
[103]: ../../explanation/flow/ci-budget-is-the-only-quality-gate.md
[104]: ../../explanation/flow/one-artifact-climbs-unchanged.md
[105]: ../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
[106]: ../../adr/design/dora-explains.md
[107]: ../../adr/design/module-aspects.md
[108]: ../../adr/design/run-modes.md
[109]: ../../adr/design/self-service.md
[110]: ../../adr/design/server-remote-integration.md
[111]: ../../adr/design/thin-platforms.md
[112]: ../../adr/design/tracks.md
[113]: ../../adr/design/visual-design.md
[114]: ../../adr/flow/dora-explains.md
[115]: ../../adr/flow/durable-sha-globs.md
[116]: ../../adr/flow/pipeline-detection.md
[117]: ../../adr/flow/pipeline-runner-pattern.md
[118]: ../../adr/flow/pipeline-types.md
[119]: ../../../.claude/CLAUDE.md
[120]: ../../../.claude/agents/write-drawio-files.md
[121]: ../../../.claude/drawio/STYLE.md
[122]: ../../../automation/Catzc.Base.Docs/configs/adrs.yml
[123]: ../../../automation/Catzc.Base.Docs/types/AdrsConfig.cs
[124]: ../../../automation/Catzc.Base.Docs/types/GlossaryConcept.cs
[125]: ../../../automation/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
[126]: ../../../automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
[127]: ../../../automation/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
[128]: ../../adr/glossary.md
[129]: ../../adr/index.md
[130]: ../../../automation/Catzc.Base.ModuleSystem/configs/glossary.yml
[131]: ../../../automation/Catzc.Base.QualityGates/configs/glossary.yml
[132]: ../../adr/glossary.md#world-map
[133]: ../../adr/glossary.md#track
[134]: ../../adr/glossary.md#file-language
[135]: ../../adr/glossary.md#cell
[136]: ../../adr/glossary.md#lit-cell
[137]: ../../../automation/Catzc.Base.Variants/configs/variants.yml
[138]: ../../../automation/Catzc.Base.Languages/configs/languages.yml
[139]: ../../adr/glossary.md#gate
[140]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13
[141]: ../../adr/glossary.md#occupant
[142]: ../../adr/design/commit-lifecycle.md#rule-adr-dsgn-life5
[143]: ../../adr/glossary.md#release-candidate
[144]: ../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14
