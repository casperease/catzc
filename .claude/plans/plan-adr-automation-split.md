---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [docs/adr/automation, docs/adr/automation/pwsh, docs/adr/index.md, pwsh/Catzc.Base.Docs/configs/adrs.yml]
---

# Separate generalized automation ADRs from the pwsh ones

`docs/adr/automation/` holds the generalized automation ADRs (no PowerShell language). `docs/adr/automation/pwsh/` holds the
PowerShell-specific ones, beside the `BCL/`, `bash/`, `go/` and `python/` folders that already sit there. `docs/references/pwsh/` holds the
reference docs for the pwsh modules in the root `pwsh/` folder.

## Why its value is medium

The flat automation folder mixes language-agnostic rules with PowerShell examples and mechanics, and the top-level
`docs/adr/automation/pwsh/` duplicates the home the pwsh rules should have under `automation/`.

## Decided (2026-10-19, from the user)

- Layout: `automation/` general, `automation/<language>/` language-specific, `docs/references/pwsh/` module references. `BCL/`, `bash/`,
  `go/` and `python/` already follow it; `docs/adr/automation/pwsh/` folds into `automation/pwsh/` (one living version).
- The `ADR-PWSH-*` codes stay as they are: a code is a selector, not a path (ADR-REPO-ADRCODE), and every citation stays valid; only the
  files move.
- Some automation ADRs are really PowerShell ADRs (the user, 2026-10-19). The split is per rule and per example, not per file: an agnostic
  rule stays in `automation/` reworded engine-neutral, and its PowerShell mechanics and code samples move to the `automation/pwsh/` twin.

- A domain names its folder under `docs/adr/` with an optional `folder` in `adrs.yml`, defaulting to the domain's name (declared once,
  `AdrsConfig.DefaultFolder`); the file index keys each page by the longest domain folder that holds it, so `automation/pwsh/` stays the
  `pwsh` domain's (decided by the orchestrator on the user's delegation, 2026-10-19). Landed 2026-10-19 before the move: `AdrsConfig`,
  `AdrDomain`, `AdrRuleSet`, `Get-AdrFileIndex`, `Build-AdrIndex`, `Test-AdrRegistry` and `Get-AdrDoraCoverageViolations`; a fresh import
  loads, the Docs and Maps tests pass (67 tests), Test-AdrRegistry clean, and the regenerated index body is unchanged. Step 3's convention
  states it as a rule: `automation/<language>/` is a domain folder, declared in `adrs.yml`.

- The sort keeps every rule in `automation/`: Test-AdrEngineNeutrality, the one judge, reports 0 issues over the automation rule summaries
  (2026-10-19), so the table's rule moves are re-cut, no code changes and no Update-AdrCitation runs. The PowerShell mechanics and samples
  of the Context and Decision prose move to the pwsh twin as Decision prose where a twin exists, and are rewritten engine-neutral in place
  where none does; no new twin ADR. The twelve stray rules of plan-layers-vocabulary-rename-contracts are sorted the same way inside the
  sort step, and that plan's step closes as superseded when the last lands (decided by the orchestrator on the user's delegation,
  2026-10-19).

## Open steps

- [x] Move the 29 files of `docs/adr/pwsh/` to `docs/adr/automation/pwsh/` and re-point every citation: verdict 2026-10-19, set 8 of
      `out/run-user-git.ps1` moved them, `adrs.yml` gives the `pwsh` domain `folder: automation/pwsh`, a fresh import loads, Test-Links
      clean over the 259 touched files, Test-AdrRegistry clean, the Docs tests pass (66). The first re-cite used `folder` rows and rewrote
      the module root `pwsh/` to `automation/pwsh/` in 180 files; repaired by a reverse pass, a forward pass with path rows only, and a
      restore plus link re-base of the 28 moved pages from the move commit. `Test-AdrRegistry` and `Get-AdrCitationGraphViolations` read the
      domain folder too.
- [x] `AdrCitationRewriter` matches a moved folder's path form only when it resolves under `docs/adr` from the citing file, so a module path
      that shares the folder's name is never rewritten (decided by the orchestrator on the user's delegation, 2026-10-19, from catzc-2f's
      suggestion) — verdict: a fresh full import loads (10.1 s); `Update-AdrCitation.Tests.ps1` Passed, including the new test (prose
      `pwsh/Catzc.Widget/x.ps1` in `docs/references/` comes out unchanged) and catzc-2f's bare-word test. A match that resolves under
      `docs/adr` still rewrites in the ADR-root form.
- [x] Tightened (decided by the orchestrator on the user's delegation, 2026-10-19, since docs/adr pages name module paths often): a bare
      moved-folder path is rewritten only when it also names the folder itself or a file or folder of it in the tree, at its old or its new
      place; `Update-AdrCitation` hands the rewriter the files under `docs/adr` (`Get-ChildPath`) — verdict: a fresh full import loads (8.5
      s); `Update-AdrCitation.Tests.ps1` Passed, including the new case (a `docs/adr` page naming `pwsh/Catzc.Widget/x.ps1` and the real
      moved `pwsh/widget-rules.md`: only the page becomes `automation/pwsh/widget-rules.md`) and catzc-2f's bare-word test, whose moved page
      is now in the fixture tree.
- [ ] Pointer for plan-diagram-engine (the diagram track):
      `docs/explanation/automation/.assets/what-gates-each-bundle-stage/{chain,grid,tree}.md` still name `docs/adr/pwsh`; they are
      regenerated with their slide, never edited (check: the three files name `docs/adr/automation/pwsh`).
- [x] Five pages named `automation/pwsh/<Module>` for the module root — verdict: `design/run-modes.md`,
      `partition-integrity-runs-only-in-unit-tests.md` and the `NoScriptRootAnchor` and `ParameterDesign` analyzer pages say `pwsh/` again
      (catzc-08, by hand; the analyzer pages' path titles too), and `internal-asset-dependencies.md` is fixed by catzc-64 in its sort; their
      `docs/adr/automation/pwsh` links are kept. Test-Links found no issues on the four; `git grep 'automation/pwsh/<Module>'` finds
      nothing.
- [x] Sort the flat files in `docs/adr/automation/`: verdict 2026-10-19, every rule stays (the gate reports 0 over the rule summaries), and
      the PowerShell samples and mechanics of the Context and Decision prose are rewritten engine-neutral in 15 files, one file per step
      with Test-AdrRegistry, Test-Links, Test-AdrEngineNeutrality and markdownlint at 0 after each; their pwsh forms stay cited to the
      twins. `execution-engines.md` keeps its engine table (the engines are its subject), and enforcement lists, real file names and twin
      pointers keep their names. The twelve stray rules stay in AUTO, unchanged.
- [x] Update the index's sources and regenerate the index: verdict 2026-10-19, `adrs.yml` gives the `pwsh` domain `folder: automation/pwsh`,
      `adr-index.yml` states the layout as an authoring convention (`automation/` engine-neutral, a language's ADRs in
      `automation/<language>/`, a language with its own code prefix a domain whose `folder` points there, a code naming the rule and never
      the path), `Build-AdrIndex` regenerated `docs/adr/index.md`: 190 codes, each once, Test-AdrRegistry, Test-Links and markdownlint at 0.

## Refs

- docs/adr/index.md; memory: adr-pwsh-split (the earlier ADR-PWSH split this builds on).
