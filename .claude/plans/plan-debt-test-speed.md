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

- [ ] `Import-Catzc.Tests.ps1` (22.1 s), measured and fixed one cause at a time once it can pass: it waits on the VSCode case-only rename
      (plan-debt-full-run-failures, the `Get-DynamicManifestContent` step, the user's), its full-build test failing in 2 to 3 s on
      "Catzc.Base.VSCode has no function files" (the reduced-build test alone is about 7 s). A compiled helper for `Get-DrsUsage`'s per-file
      loop (about 10 s left, the PowerShell call overhead of the citation and state processors over 5,374 files) is the next lever there,
      measured against PowerShell before it is kept. Check: `Invoke-TestFile` twice, the same test names and `Should` count, and
      `Test-ScriptAnalyzer -Path` at 0 on each changed file.
- [ ] The next files the report `out/test-optimization-2026-10-22.md` names, each measured and fixed as the step above, one session per file
      (`Test-Markdownlint.Tests.ps1` measured and left as it is: 14.1 s and 17.0 s, its 6.2 to 7.6 s is the whole-tree markdownlint run it
      exists to prove, already skipped after a green run, catzc-e9, 2026-10-22):
      `pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1` (15.2 s; waits on the VSCode case-only rename like
      `Import-Catzc.Tests.ps1`: its full build fails in 2.8 s on "Catzc.Base.VSCode has no function files", catzc-a0, 2026-10-22,
      `out/catzc-a0-test-speed-3-parity.md`); `Import-CSharpTypes.Tests.ps1` measured and left as it is (13.8 s: about 7.3 s fixed worker
      start, 2.5 s the L2 dotnet build, 0.1 s Roslyn per case in its own namespace, catzc-54, 2026-10-22). A file measured with no safe gain
      is recorded as left as it is (taken by the orchestrator as delegated, 2026-10-22). Check: `Invoke-TestFile` twice per file, the same
      test names and `Should` count, and `Test-ScriptAnalyzer -Path` at 0 on each changed file.

## Decided

- The hindsight log gets no decision record (the orchestrator as delegated, 2026-10-23): the `hindsight-log` capability is its one home
  (PDR-ONELIVE), and a record follows only when a second reader needs its rule.
- `docs/references/pwsh/CLAUDE.md` changes to `Format-Code -Path` (the user, 2026-10-25); the edit is the user's, task-user-runs-and-commits
  step 20.
