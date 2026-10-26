---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1]
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-optimization role ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s
summed). `Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left
out: `Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Open steps

- [ ] `Import-Catzc.Tests.ps1` (22.1 s), measured and fixed one cause at a time once it can pass: it waits on the VSCode case-only rename
      (plan-debt-full-run-failures, the `Get-DynamicManifestContent` step, the user's), its full-build test failing in 2 to 3 s on
      "Catzc.Base.VSCode has no function files" (the reduced-build test alone is about 7 s). Check: `Invoke-TestFile` twice, the same test
      names and `Should` count, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [ ] The ten slowest test files, each measured alone and fixed one cause at a time, slowest first (ranked 2026-10-26 by catzc-2f from the
      2026-10-25 sharded run's `durations.json`, its top 16 re-timed alone; `Import-Catzc.Tests.ps1` and `Test-CatzcBuild.Parity.Tests.ps1`
      wait on the VSCode case-only rename, the step above): `Invoke-TestFile.Tests.ps1` (77.4 s), `Test-Formatting.Tests.ps1` (catzc-68 has
      it: its repository test runs `Format-Code -DryRun` over the tree, profiled on 2026-10-26 at 132.7 s and 124.7 s cold, of it
      psscriptanalyzer about 50 s on 1,997 files and prettier about 41 s on 3,049, the cold engines being the open fan-out question's; and
      17.5 s and 14.9 s warm, of it about 12 s fixed overhead with nothing pending: the scope and cache load before the first engine, 5.6 to
      7.4 s, and the imprint steps' planning and stamping. In memory the warm path's about 12 s is the scope walk 3.0 to 3.6 s, the imprint
      steps' own file lists 2.7 to 3.1 s, `Get-FileMetaInputStamp` 2.0 to 2.5 s and the cache splits 2.4 to 2.6 s. Next, catzc-68's:
      `Get-FormatScope`'s existence filter as a loop with `File.Exists` and an ordinal set (A/B 1.93 s to 0.45 s, identical list), then the
      step lists reusing the scope walk; `Get-FileMetaInputStamp` only after catzc-2b's 4a burst lands, routed through the orchestrator.
      Known red until the user's edit and item 32's untracking: `.claude/CLAUDE.md` unformatted and the tracked build outputs) and
      `Get-RepositoryFilter.Tests.ps1` (16.1 s). `Test-Automation.Tests.ps1` (15.6 s) is left as it is: its cost is one
      `Test-SourceConventions` run over the tree (catzc-68, 2026-10-26). `Test-Spelling.Tests.ps1` (18.5 s) is left as it is: its cost is
      one cspell process over 5,669 files (19.3 s measured); a 4-way extension shard measured 10.1 s, but parallel cspell needs a fan-out
      seam in Base.Execution that the L0 mocks can reach, the open question below (catzc-68, 2026-10-26). A red file is made green by its
      owner before its speed is touched, and a file measured with no safe gain is recorded as left as it is. Check: `Invoke-TestFile` twice
      per file, the same test names and `Should` count, an A/B of each cause with identical output, and `Test-ScriptAnalyzer -Path` at 0 on
      each changed file.

## Open questions

- Should `Build-Bicep` call the bicep binary directly instead of through `Invoke-AzCli`? Each az call pays about 1.7 s of Python start
  (measured by catzc-68, 2026-10-26: `az bicep version` 1.99 s, `bicep --version` 0.31 s), once per slot plus once for main. Recommendation:
  measure first, the start cost times the slots of a real build, before deciding.
- Should a janitor keep `out/` to a retention (old `test-file/`, `burst/` journals, drone scratch)? Every test that walks the disk pays for
  it: on 2026-10-26 the track lamps' walk held 51,471 files, 36,678 under `out/` (`test-file` 8,788, `drone27-pre` 6,089, `burst` 4,979,
  `test-generated-files` 2,670, `minimaps` 2,296, `slides` 1,748), measured by catzc-2b. Undecided.
- Should Base.Execution offer a parallel fan-out seam (`Invoke-ExecutableParallel -Command [string[]] -ThrottleLimit`), starting the
  processes itself, each bounded by `Get-TimeoutSeconds` for its executable, and returning `Invoke-Executable`-shaped results in order, so a
  gate can run independent tool calls side by side while its L0 tests mock one seam? First caller: `Test-Spelling`'s default globs, sharded
  by extension (coverage identical by construction, `.accosted.yml` excluded from the `*.yml` shard), measured by catzc-68 on 2026-10-26 at
  19.3 s in one cspell process and 10.1 s in four. Second caller: `Format-Code`'s cold engines, measured by catzc-68 on 2026-10-26 at about
  50 s for psscriptanalyzer over 1,997 files (it already shards into jobs at 50 or more pending) and about 41 s for prettier over 3,049
  files in one process. Undecided: judge it with both callers in view.

## Decided

- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
