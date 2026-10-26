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

- [ ] `Test-Formatting.Tests.ps1`: its warm path's `Get-FileMetaInputStamp` (2.0 to 2.5 s) and the file-meta step list (1.4 s), measured and
      fixed one cause at a time after catzc-2b's 4a burst lands, routed through the orchestrator. Check: `Invoke-TestFile` twice, the same
      test names and `Should` count, an A/B of each cause with identical output, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Open questions

- Should `Build-Bicep` call the bicep binary directly instead of through `Invoke-AzCli`? Each az call pays about 1.7 s of Python start
  (measured by catzc-68, 2026-10-26: `az bicep version` 1.99 s, `bicep --version` 0.31 s), once per slot plus once for main. Recommendation:
  measure first, the start cost times the slots of a real build, before deciding.
- Should a janitor keep `out/` to a retention (old `test-file/`, `burst/` journals, drone scratch)? Every test that walks the disk pays for
  it: on 2026-10-26 the track lamps' walk held 51,471 files, 36,678 under `out/` (`test-file` 8,788, `drone27-pre` 6,089, `burst` 4,979,
  `test-generated-files` 2,670, `minimaps` 2,296, `slides` 1,748), measured by catzc-2b. Undecided.

## Decided

- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
