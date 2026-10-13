# docs/how-to/automation/manual-test-plan/docs-and-links.md

`Manual test plan — Docs and links`

Generated READMEs and `.gitkeep` files, Markdown lint and titles, and repository links. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                        | FullNameFilter                                           | Guards                                                                                                                                                                                                            |
| --- | ---- | -------------------------------------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1                         | Build-GitKeep — managed .gitkeep files                   | Every .gitkeep carries the generic source content (`Test-GeneratedFiles -Generator Build-GitKeep` reports 0 issues), and every .gitkeep folder is a readme-mapped target with a reference article.                |
| 2   | L1   | automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1                         | Build-GitKeep — shipped assets/gitkeep                   | Build-GitKeep writes the content of the `assets/gitkeep` shipped in the loaded module (ADR-AUTO-ASSETDEP#3).                                                                                                      |
| 3   | L1   | automation/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1                       | Get-CatsModules — loaded catzc modules                   | Show-Cats' module list is read from the loaded modules under the code root: exact exports, no privates, no infrastructure.                                                                                        |
| 4   | L1   | automation/Catzc.Base.QualityGates/tests/Test-Links.Repository.Tests.ps1         | Repository code links (automation comments)              | Every ADR reference in an automation comment is a canonical, resolving code link, and every docs path in an automation string names an existing file.                                                             |
| 5   | L1   | automation/Catzc.Base.QualityGates/tests/Test-MarkdownTitle.Repository.Tests.ps1 | Repository Markdown titles                               | Every in-scope tracked Markdown file opens with `# <repository path>` as its title (Format-MarkdownTitle leaves the tree unchanged).                                                                              |
| 6   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1             | Repository markdown integrity                            | All in-scope repository markdown passes markdownlint.                                                                                                                                                             |
| 7   | L2   | automation/Catzc.Base.Docs/tests/Build-Readme.Tests.ps1                          | Build-Readme — real readme.yml                           | Every generated README's source exists, every README is current (`Test-GeneratedFiles -Generator Build-Readme` reports 0 issues), the pattern covers every automation module, and mapped READMEs stay gitignored. |
| 8   | L2   | automation/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1                 | Generated READMEs are gitignored, untracked, and current | `Test-GeneratedReadmes` reports 0 issues: every generated README is gitignored, untracked in git, and current with its authored source, links rebased to its folder (a derived artifact, never committed).        |
| 9   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Links.Repository.Tests.ps1         | Repository links (every tracked file)                    | Every markdown and code link in a tracked file is aligned and resolves (fragments included), Format-Links is a no-op on the tree, and the VS Code registries carry the code-link rule.                            |

## Checks

### 6. Repository markdown integrity

**Guards:** all in-scope repository markdown is lint-clean.

**Checks:**

- Real `markdownlint-cli2` over the default content scope reports no violation.

**Prerequisite:** markdownlint-cli2.
