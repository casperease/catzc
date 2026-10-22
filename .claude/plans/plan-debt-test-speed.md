---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1]
---

# Debt test speed: the slowest Pester files measured and fixed one at a time

The test-optimization role ranked the files of the last full run, `out/test-automation/20261021-032407` (a failed run, 895 files, 1373 s
summed). `Invoke-TestFile.Tests.ps1` was measured at 55.1 s and 43.4 s and stays as it is: its cost is the snapshot path it proves. Left
out: `Test-ScriptAnalyzer.Tests.ps1` and `Get-ContractCheckResults.Assets.Tests.ps1` (catzc-e9 handled them), `Test-Spelling.Tests.ps1` and
`Test-Automation.Tests.ps1` (catzc-e9 checks whether they are still red), and the `Language.Bridge.ps1` rows, which run the language test
folders. Heavy runs wait for a turn in the orchestrator's memory queue, one run per call.

## Open steps

- [ ] The next three files by cost, each measured and fixed one at a time: `Get-AdrUsage.Tests.ps1` (22.5 s; now `Get-DrsUsage.Tests.ps1`, 13.4
       s and 12.9 s, its whole-tree scan about 12 s; the drs-codes kind and comment-pages config resolved once in `Get-DrsUsage.ps1` and
       passed to `Get-DrsUsageRow`, about 1.2 s, decided by the orchestrator as delegated; the shared imprint processors' 7 s are outside
       this step, `out/catzc-e3-test-speed-2.md`; landed and kept: in-process 15.0/13.2 s -> 13.6/11.3 s, names and `Should` counts the
       same, but the file measured 16.4 to 16.8 s under five busy sessions, re-measured in a quiet window at 12.07 s and 16.56 s, 7 tests
       green, a spread larger than the fix, as `out/test-optimization-2026-10-22.md` says, catzc-e9), `Import-Catzc.Tests.ps1` (22.1 s) and
       `Invoke-Executable.Tests.ps1` (20.5 s; landed: 13.5 s -> 10.4 s, the stdin child started in a file-level BeforeAll,
       ADR-AUTO-TEST-SETUPONCE, 59 tests and 81 `Should` the same, catzc-e9). `Import-Catzc.Tests.ps1` waits on the VSCode case-only rename
       (plan-debt-full-run-failures step 2, the user's): its full-build test fails in 2 to 3 s on "Catzc.Base.VSCode has no function files"
       (catzc-a0, 2026-10-22; the reduced-build test alone is about 7 s), so the 22.1 s is measured once the build passes. Check:
       `Invoke-TestFile` twice per file, the same test names and `Should` count, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [ ] The next files the report `out/test-optimization-2026-10-22.md` names, each measured and fixed as the step above, one session per file
      (`Test-Markdownlint.Tests.ps1` measured and left as it is: 14.1 s and 17.0 s, its 6.2 to 7.6 s is the whole-tree markdownlint run
      it exists to prove, already skipped after a green run, catzc-e9, 2026-10-22):
       `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` (15.2 s; waits on the VSCode case-only rename like
       `Import-Catzc.Tests.ps1`: its full build fails in 2.8 s on "Catzc.Base.VSCode has no function files", catzc-a0, 2026-10-22,
       `out/catzc-a0-test-speed-3-parity.md`); `Import-CSharpTypes.Tests.ps1` measured and left as it is (13.8 s: about 7.3 s fixed worker
       start, 2.5 s the L2 dotnet build, 0.1 s Roslyn per case in its own namespace, catzc-54, 2026-10-22). A file measured with no safe gain is
       recorded as left as it is (taken by the orchestrator as delegated, 2026-10-22). Check: `Invoke-TestFile` twice per file, the same test names and `Should` count, and
       `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Open questions

- Does the hindsight log, `.claude/hindsight/`, get a decision record? Its line shape and validity rule live only in the `hindsight-log`
  capability, and no ADR outside `research/` names it (the user's decision).
- `docs/references/pwsh/CLAUDE.md` still prescribes `Format-Code -Language markdown -Path docs/references/pwsh`, against `catzc-run`'s
  `Format-Code -Path` on the files touched (decided in plan-agent-friction); a `CLAUDE.md` is the user's to edit.
