---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [docs/adr/automation, docs/adr/pwsh, docs/adr/index.md, pwsh/Catzc.Base.Docs/configs/adrs.yml]
---

# Separate generalized automation ADRs from the pwsh ones

`docs/adr/automation/` holds the generalized automation ADRs (no PowerShell language). `docs/adr/automation/pwsh/` holds the
PowerShell-specific ones, beside the `BCL/`, `bash/`, `go/` and `python/` folders that already sit there. `docs/references/pwsh/` holds the
reference docs for the pwsh modules in the root `pwsh/` folder.

## Why its value is medium

The flat automation folder mixes language-agnostic rules with PowerShell examples and mechanics, and the top-level `docs/adr/pwsh/`
duplicates the home the pwsh rules should have under `automation/`.

## Decided (2026-10-19, from the user)

- Layout: `automation/` general, `automation/<language>/` language-specific, `docs/references/pwsh/` module references. `BCL/`, `bash/`,
  `go/` and `python/` already follow it; `docs/adr/pwsh/` folds into `automation/pwsh/` (one living version).
- The `ADR-PWSH-*` codes stay as they are: a code is a selector, not a path (ADR-REPO-ADRCODE), and every citation stays valid; only the
  files move.
- Some automation ADRs are really PowerShell ADRs (the user, 2026-10-19). The split is per rule and per example, not per file: an agnostic
  rule stays in `automation/` reworded engine-neutral, and its PowerShell mechanics and code samples move to the `automation/pwsh/` twin.

## Open steps

- [ ] Create `docs/adr/automation/pwsh/` and move the 29 files of `docs/adr/pwsh/` into it (27 ADR pages, the `index.md`, and
      `powershell-formatting.pdf` with its page); the `git mv` lines are the user's (task-user-runs-and-commits), prepared in
      `out/run-user-git.ps1`; then `Update-AdrCitation` re-points the links in the 287 citing files outside the folder (59 under `pwsh/`,
      224 under `docs/` of which 181 are generated `docs/references/pwsh` pages that `Build-Readme` regenerates instead, 4 under `.claude/`)
      and the `relatives:` heads, one file at a time (check: Test-Adr and Test-Links clean after each file; `docs/adr/pwsh/` is empty and
      gone at the end).
- [ ] Sort the flat files in `docs/adr/automation/` by the table below, one file at a time: the PowerShell rules and examples go to the
      named twin (a new twin where the table says so), the agnostic rules are reworded engine-neutral, and a rule that only names a catzc
      command is reworded to the command's role (check: Test-Adr, Test-Links and Test-AdrEngineNeutrality clean after each file;
      `Test-AdrEngineNeutrality` is the one judge of what counts as pwsh text, so a row it disagrees with is re-cut, not argued).
- [ ] Update the index's sources, `pwsh/Catzc.Base.Docs/configs/adrs.yml` (the paths) and `adr-index.yml` (the authoring conventions), and
      regenerate `docs/adr/index.md` with `Build-AdrIndex`; the index is a locked generated file, never edited by hand. The convention
      states the layout as a rule: `automation/` holds engine-neutral rules, `automation/<language>/` the language's, and the codes stay
      (ADR-REPO-PLANS-DECISIONSBECOMERULES) (check: Test-Adr clean; the regenerated index lists every code once and the convention names the
      four language folders).

## Where each flat automation ADR goes

Counted 2026-10-19: PowerShell-specific lines (`$var`, `.ps1`, Pester, `[switch]`, cmdlet names) against rule count. The sort step rewrites
this table as it moves; a row is "stays" when the subject itself is the engine or the automation, whatever its examples use.

| File                                               | Lines / rules | First cut                                                                                                                               |
| -------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| execution-engines.md                               | 36 / 7        | stays: the engines are its subject                                                                                                      |
| test-automation.md                                 | 30 / 38       | split: the runner and tier rules stay; Pester mechanics to `pester-testing.md`                                                          |
| single-responsibility-functions.md                 | 29 / 6        | split: rules stay; the poetry samples rewritten neutral or moved to a new pwsh twin                                                     |
| avoid-deep-nesting.md                              | 25 / 5        | split: rules stay; the pipeline and `Where()` samples to a new pwsh twin                                                                |
| open-closed-architecture.md                        | 20 / 4        | split: ADR-AUTO-EXTEND-MANDATORYCONVENTIONS and samples to `prepost-extension-modules.md`                                               |
| caching.md                                         | 18 / 9        | split: IMPORTERINVALIDATES, LAZYBYDEFAULT and the session cache to `script-scope-caching.md`                                            |
| idempotent-state-functions.md                      | 16 / 5        | split: samples to `idempotent-state-mechanics.md`                                                                                       |
| controlling-module-dependencies.md                 | 15 / 10       | stays: 8 of 10 rules agnostic; UNIFIEDGRAPH and GROUPAWAREINTEGRITY name `Test-ModuleDependency` only (reword to "the dependency gate") |
| path-representation.md                             | 14 / 11       | stays: 4 rules agnostic, 7 name a catzc converter (`Resolve-RepoPath`, `ConvertTo-RepoRelativePath`) by name only; reword to the role   |
| console-output-matters.md                          | 10 / 11       | split: ANNOUNCE\* and SILENTTRANSIENTCHANGES to `announce-state-changes.md` (no such twin code yet; a new rule there)                   |
| environment-variables.md                           | 11 / 7        | split: mechanics to `environment-variable-mechanics.md`                                                                                 |
| never-depend-on-pwd.md                             | 9 / 3         | split: ONEROOTACCESSOR merges into the twin's ROOTTHROUGHACCESSOR (`working-directory-mechanics.md`), which already states it           |
| cross-platform.md                                  | 6 / 4         | split: mechanics to `cross-platform-powershell.md`                                                                                      |
| platform-bundle.md                                 | 12 / 7        | moves whole: 6 of 7 rules are module-manifest and `Build-Modules`/`Export-Catzc` mechanics; BUNDLEISSESSION goes with them              |
| retry, fail-fast, log-before-invoke, tracked-files | 2 to 8        | stay: six rule paragraphs name `Invoke-Executable`, `Invoke-WithRetry`, `Invoke-WithTimeout` or `-Silent`; reword to the role           |
| the other 18 flat files                            | under 14      | stay: hits only in Context and Decision prose or fenced samples; reworded where Test-AdrEngineNeutrality names them                     |

## Refs

- docs/adr/index.md; memory: adr-pwsh-split (the earlier ADR-PWSH split this builds on).
- `plan-layers-vocabulary-rename-contracts` moves twelve named stray rules after this plan's first step, so each twin has its final home.
