---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh]
  blocked_on: task-user-runs-and-commits, the final full run, whose results the ranking reads
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-speed job ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s summed).
`Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left out:
`Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Open steps

- [ ] Rank the files of the next full `Test-Automation` run by time and take the slowest one with a lever, measured and fixed one cause at a
      time; the run above is cleared from `out/`, and a full run is the user's. `Test-Formatting.Tests.ps1` is done: its remaining cost is
      git's own attribute reads (about 220 ms in each scope). Check: `Invoke-TestFile` twice, the same test names and `Should` count, an A/B
      with identical output, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Decided

- No `out/` janitor, and the track lamps' walk keeps walking `out/` (the orchestrator, 2026-10-26): the walk took 494 ms over 25,405 files,
  10,405 of them under `out/` (catzc-f4), and the one test that walks the repository walks once, so skipping `out/` saves about 0.2 s; the
  out lamp hides and counts the run output file by file, so a skip would change the lamp language for it.
- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
