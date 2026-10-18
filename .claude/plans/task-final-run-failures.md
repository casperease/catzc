---
task:
  status: active
  plans: [plan-test-run-budget, plan-module-model-closeout, plan-bounded-folder-enumeration, plan-file-head-immutable-edges-classes]
  value: highest
  blocked_on: nothing
  targets: [pwsh, docs/references/contracts]
---

# Task: the 13 failures of the final full run

The user's final run, `out/test-automation/20261018-205956`: 7200 passed, 44 skipped, 13 failed, 221.0 s wall clock (over the 180 s run
budget, under the 360 s roof). Rule coverage 225 of 1659, against 220 of 1645 before the code-language rename: no tagged test lost. The
plans that close on green close on the re-run after these chunks. One chunk per session; each step names its files and its check; no step
runs `Test-Automation`.

## Steps

1. Diagram-folder file kinds (3 failures). Since the diagram-folder move a slide's description is
   `<page-folder>/.assets/<name>/diagram.drawio.md` and its raster `.../diagram.drawio.png`; the shipped registries and two tests still
   expect the flat names. `Get-FileKind.Tests.ps1:40` gets `explanation` for `docs/explanation/design/gadget-spins.drawio.md` where it wants
   `asset-description`, and `FileCarrierResolver.Tests` gets `asset` for
   `docs/explanation/.assets/adr-widget-flow--gadget-spins--meta.drawio.png` where it wants `diagram`. Decide from the registries which side
   is stale (the fixtures' flat paths or the globs) and make the registry and the fixtures say the folder form, one file at a time. Check:
   `Get-FileKind.Tests`, `FileCarrierResolver.Tests` and the file-kind reachability test pass under Invoke-TestFile. **Verdict (done
   2026-10-18):** the fixtures were stale, and so were the flat registry entries (no flat diagram or description is tracked any more). The
   fixtures now use the folder form; the flat `diagram` and `reference-diagram` carriers (with their exclude list) and the flat
   `docs/references/**/*.drawio.md` glob are removed. `Get-FileKind.Tests`, `FileCarrierResolver.Tests` and
   `Test-FileKindReachability.Tests` all Passed under Invoke-TestFile.
2. Internal asset dependency (3 failures). `Get-UncoveredInternalAssetDependency.Tests` now reports `Get-Gadget` and `Get-Sprocket` as
   uncovered where the L0 expects them covered (a citation inherited from the Describe); the real tree reports `Build-AdrCodeDictionary`
   reading `configs/adrs.yml` with no It tagged `ADR-AUTO-ASSETDEP-COVEREDBYREALTEST`. Likely one cause: the tag reader still matches the
   numbered form after the code-language rename. Fix the reader, or tag the real test, whichever the rule says. Check:
   `Get-UncoveredInternalAssetDependency.Tests` and `Get-InternalAssetDependency.Integrity.Tests` pass. **Verdict (done 2026-10-18,
   catzc-c4):** the reader already matched the named code; the L0 fixture still composed the numbered form (`'ADR-AUTO-ASSETDEP' + '#3'`),
   now the named rule, and Build-AdrCodeDictionary gained an L1 integrity Describe tagged with the citation, reading the shipped
   `configs/adrs.yml`. Both test files and Build-AdrCodeDictionary.Tests Passed under Invoke-TestFile
   (`out/test-file/20261018-210821-78c51a`, `-210826-855a15`, `-210832-dff304`). The composed `' + '#3'` form escaped both the literal scan
   and the runtime-composition check.
3. `Move-Diagram.Tests` (1 failure): "Cannot find path 'docs'" at `Get-LinkScope.ps1:20`: the real move case now reaches the link engine
   through the new Format-Code call or the rebase, with its test root lacking `docs/`. Fix the test's tree or scope the call to the test
   root. Check: `Move-Diagram.Tests` passes. **Verdict (done 2026-10-18, catzc-c4):** the test, not Move-Diagram: its
   `Test-Links -Path docs` resolved against the current folder (now under the fixture root), and the fixture's `#top` anchor had no heading
   (now `#widget-described`). "[Invoke-TestFile] Passed" (`out/test-file/20261018-210943-53206f`); Format-Code 0 of 2.
4. Links and words (5 failures). `Get-ContractCheckResults.Assets.Tests.ps1:27` has a bare `ADR-AUTO-TEST-SETUPONCE` in a comment (run
   `Format-Links` on that file); `docs/references/contracts/catzc.md:324` and one more line say "the test suite" (G4; the generated contract
   reference, so fix the contract text it renders from, then regenerate); one cspell finding (find it with `Test-Spelling`). Check:
   `Test-Links.Repository.Tests`, `Test-Glossary`, `Test-Spelling` 0; `Test-GeneratedFiles` on the reference 0. **Verdict (done 2026-10-18,
   catzc-c4):** Format-Links aligned the citation; the Test-Automation and Test-CatzcBuild command contracts say "all tests" and the
   reference is regenerated; the cspell finding was an invented fixture word in Build-Glossary.Tests.ps1, now real words.
   Test-Links.Repository.Tests and Build-Glossary.Tests Passed; Test-Glossary, Test-Spelling and Test-GeneratedFiles
   (Build-ContractReference) 0.
5. Formatting (1 failure, five files): `plan-explanation-drift-gaps.md`, `plan-master.md`, `task-explanation-drift-gaps.md`,
   `task-user-runs-and-commits.md` and `value-of-plan.md` under `.claude/plans`, the orchestrator's own edits; the orchestrator formats the
   folder after its edits. Check: `Test-Formatting.Tests` passes. **Done 2026-10-18 by the orchestrator:** Format-Code over `.claude/plans`,
   "markdown: 5 of 22 file(s) changed"; Test-Plans and Test-Links 0. Proof on the user's re-run.
6. The run budget: the run took 221.05 s against `tests.run_seconds` 180 in `timeouts.yml` ("exceeded by 41.05s (fails a devbox run)"),
   while plan-test-run-budget's table names 347 s; the two numbers disagree. Read `summary.md`'s slowest tests and over-limit timings
   (`Get-AdrUsage (repository)` 19.3 s and 9.7 s at L1, roof 2 s; `Invoke-TestFile (real worker)` 25.0 s) and speed up the slowest files as
   test-optimization does, never raising a limit. Record which budget is the live one in the plan. Check: each sped-up file faster and with
   every test kept, under Invoke-TestFile.
   **Verdict (2026-10-18, catzc-c4):** the enforced budget is 180 s (`TimeoutsConfig.cs:27`); 347 s is an older baseline. Get-AdrUsage.Tests
   34 s to 15 s, 6 of 6 kept (`out/test-file/20261018-211459-238c40`); Invoke-TestFile's real-worker file left at 25 s (its cost is what it
   proves). The rest of the gap to 180 s is plan-test-run-budget's open box.
7. The user's re-run of `Test-Automation` (task-user-runs-and-commits, its last step). Check: 0 failed; then the closing sweep.

## Report

As report-fixed: per step the verdict line.
