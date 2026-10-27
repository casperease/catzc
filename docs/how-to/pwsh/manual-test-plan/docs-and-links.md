# Manual test plan — Docs and links

Generated READMEs and `.gitkeep` files, Markdown lint and titles, and repository links. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                          |
| --- | ---- | -------------------------------------------------------------- |
| 1   | L2   | [Build-GitKeep — managed .gitkeep files][c1]                   |
| 2   | L1   | [Build-GitKeep — shipped assets/gitkeep][c2]                   |
| 3   | L1   | [Get-CatsModules — loaded catzc modules][c3]                   |
| 4   | L1   | [Repository code links (automation comments)][c4]              |
| 5   | L1   | [Repository Markdown titles][c5]                               |
| 6   | L2   | [Repository markdown integrity][c6]                            |
| 7   | L2   | [Build-Readme — real readme.yml][c7]                           |
| 8   | L2   | [Generated READMEs are gitignored, untracked, and current][c8] |
| 9   | L2   | [Repository links (every tracked file)][c9]                    |
| 10  | L1   | [Get-CommentPage (the shipped comment-pages config)][c10]      |
| 11  | L1   | [Test-GeneratedFiles — real tree][c11]                         |
| 12  | L2   | [Repository link directions (every tracked file)][c12]         |
| 14  | L1   | [Get-NameMentionFinding (real tree)][c14]                      |
| 15  | L1   | [Test-ReferencePages — the real tree][c15]                     |

[c1]: #1-build-gitkeep--managed-gitkeep-files
[c2]: #2-build-gitkeep--shipped-assetsgitkeep
[c3]: #3-get-catsmodules--loaded-catzc-modules
[c4]: #4-repository-code-links-automation-comments
[c5]: #5-repository-markdown-titles
[c6]: #6-repository-markdown-integrity
[c7]: #7-build-readme--real-readmeyml
[c8]: #8-generated-readmes-are-gitignored-untracked-and-current
[c9]: #9-repository-links-every-tracked-file
[c10]: #10-get-commentpage-the-shipped-comment-pages-config
[c11]: #11-test-generatedfiles--real-tree
[c12]: #12-repository-link-directions-every-tracked-file
[c14]: #14-get-namementionfinding-real-tree
[c15]: #15-test-referencepages--the-real-tree

## Checks

### 1. Build-GitKeep — managed .gitkeep files

**Test file:** `pwsh/Base.Docs/tests/Build-GitKeep.Tests.ps1` (L2), block `Build-GitKeep — managed .gitkeep files`.

**Guards:** Every .gitkeep carries its source content, which is generic (`Test-GeneratedFiles -Generator Build-GitKeep` reports 0 issues),
and every .gitkeep folder is a readme-mapped target with a reference article.

### 2. Build-GitKeep — shipped assets/gitkeep

**Test file:** `pwsh/Base.Docs/tests/Build-GitKeep.Tests.ps1` (L1), block `Build-GitKeep — shipped assets/gitkeep`.

**Guards:** Build-GitKeep writes the content of the `assets/gitkeep` shipped in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 3. Get-CatsModules — loaded catzc modules

**Test file:** `pwsh/Base.Docs/tests/Get-CatsModules.Tests.ps1` (L1), block `Get-CatsModules — loaded catzc modules`.

**Guards:** Show-Cats' module list is read from the loaded modules under the code root: exact exports, no privates, no infrastructure.

### 4. Repository code links (automation comments)

**Test file:** `pwsh/Base.QualityGates/tests/Test-Links.Repository.Tests.ps1` (L1), block `Repository code links (automation comments)`.

**Guards:** Every decision-record reference in an automation comment is a canonical, resolving code link, and every docs path in an
automation string names an existing file.

### 5. Repository Markdown titles

**Test file:** `pwsh/Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1` (L1), block `Repository Markdown titles`.

**Guards:** Every in-scope tracked Markdown file opens with an H1 that is its title, not its repository path (Format-MarkdownTitle leaves
the tree unchanged).

### 6. Repository markdown integrity

**Test file:** `pwsh/Base.QualityGates/tests/Test-Markdownlint.Tests.ps1` (L2), block `Repository markdown integrity`.

**Guards:** all in-scope repository markdown is lint-clean.

**Checks:**

- Real `markdownlint-cli2` over the default content scope reports no violation.

**Prerequisite:** markdownlint-cli2.

### 7. Build-Readme — real readme.yml

**Test file:** `pwsh/Base.Docs/tests/Build-Readme.Tests.ps1` (L2), block `Build-Readme — real readme.yml`.

**Guards:** Every generated README's source exists, every README is current (`Test-GeneratedFiles -Generator Build-Readme` reports 0
issues), the pattern covers every automation module, and mapped READMEs stay gitignored.

### 8. Generated READMEs are gitignored, untracked, and current

**Test file:** `pwsh/Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1` (L2), block
`Generated READMEs are gitignored, untracked, and current`.

**Guards:** `Test-GeneratedReadmes` reports 0 issues: every generated README is gitignored, untracked in git, and current with its authored
source, links rebased to its folder (a derived artifact, never committed).

### 9. Repository links (every tracked file)

**Test file:** `pwsh/Base.QualityGates/tests/Test-Links.Repository.Tests.ps1` (L2), block `Repository links (every tracked file)`.

**Guards:** Every markdown and code link in a tracked file is aligned and resolves (fragments included), Format-Links is a no-op on the
tree, and the VS Code registries carry the code-link rule.

### 10. Get-CommentPage (the shipped comment-pages config)

**Test file:** `pwsh/Base.CodeMeta/tests/Get-CommentPage.Tests.ps1` (L1), block `Get-CommentPage (the shipped comment-pages config)`.

**Guards:** a code file's long comment resolves to a comment page that exists.

**Checks:**

- `Get-CommentPage` over the shipped `comment-pages` config maps `python/diagrams/configs/drawio.yml` to
  `docs/references/python/diagrams/configs/drawio.yml.md`, and that file exists.

### 11. Test-GeneratedFiles — real tree

**Test file:** `pwsh/Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` (L1), block `Test-GeneratedFiles — real tree`.

**Guards:** every generated file in the tree is current with its generator.

**Checks:**

- `Test-GeneratedFiles` over the whole tree reports 0 issues.

### 12. Repository link directions (every tracked file)

**Test file:** `pwsh/Base.QualityGates/tests/Test-LinkDirections.Repository.Tests.ps1` (L2), block
`Repository link directions (every tracked file)`.

**Guards:** Every relation in a tracked file points a way its first matching link-directions row allows.

### 13. Test-GeneratedFiles — shipped assets/english.txt.gz

**Test file:** `pwsh/Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1` (L1), block
`Test-GeneratedFiles — shipped assets/english.txt.gz`.

**Guards:** `Test-GeneratedFiles` finds the committed word list and its stamp in the loaded QualityGates module
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 14. Get-NameMentionFinding (real tree)

**Test file:** `pwsh/Base.Slides/tests/Get-NameMentionFinding.Tests.ps1` (L1), block `Get-NameMentionFinding (real tree)`.

**Guards:** no diagram declaration or slide names catzc or cats as a word, outside the contrasts `slides.yml` declares under `name_mentions`
(DDR-VISUAL-NONAMEINPICTURE).

**Checks:**

- `Get-NameMentionFinding` over every declared diagram and every slide reports 0 findings.

### 15. Test-ReferencePages — the real tree

**Test file:** `pwsh/Base.QualityGates/tests/Test-ReferencePages.Tests.ps1` (L1), block `Test-ReferencePages — the real tree`.

**Guards:** Every reference page maps back to exactly one source, and no two sources share a page (ADR-REPO-COMMENTS-COMMENTPAGEPLACE).
