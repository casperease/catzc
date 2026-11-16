---
plan:
  status: active
  value: high
  reviewed: 2026-11-16
  class: feature
  targets: [pwsh/Base.Exporter/tests, pwsh/.internal/tests, pwsh/Base.QualityGates, docs/drs/automation/test-automation.md]
---

# The cold source run within its 240 s budget

The warm source run closed plan-test-run-budget at 227.6 s and 204.8 s (2026-11-09). The first source run after a Defender signature update
reads over the roof: 242.4 s on 2026-11-16 (`20261116-132816`, 0 failed), against 204.8 s on the same tree plus one five-file commit. The
import ledger shows the cause: the console import of 12:22 that day was the first after the signature changed (8.1 s of wall for 4.3 s of
CPU, the 20-file probe 63 ms against 9), so every worker read rescanned files. The growth is spread: 318 file-seconds over a dozen I/O-heavy
files at 5 to 8 s each, and 50 s in the snapshot case of `Invoke-TestFile.Tests.ps1`. The user's rule stands: a run past its roof means
faster tests, never a raised roof, and duplicate proof goes before per-file tuning.

## Why its value

The BVT is run by hand after days away, which is exactly when the signatures have changed; a cold run that fails on time alone costs a
diagnosis each time and hides a real regression behind a known one.

## Decided

- The cut is the user's own split, not tuning: a test whose subject is a built bundle belongs to the post-build run
  (ADR-AUTO-TEST-POSTBUILDTAG), whatever its history. Two source-run files qualify and together hold 112 file-seconds of the cold run:
  `Build-Modules.Languages.Tests.ps1` (61 s: the full bundle's language packaging and two installs) and `Import-Catzc.Tests.ps1` (51 s: two
  `Test-BuildArtifact` loads of a full and a reduced build). The post-build pool is not packed (6 files over 14 slots, 132.8 s), so they add
  little wall there, and against the store their builds are reuses.
- `Invoke-LanguageBridge.SetupError.Tests.ps1` spawns one fresh session per input (46 s pooled for two); one child answering both inputs is
  the collapse ADR-AUTO-TEST-COLLAPSEINPUTCLUSTERS asks for, and the proof stays: the plain folder yields two rows, the proof folder two per
  engine.
- Left as they are: the snapshot case of `Invoke-TestFile.Tests.ps1` (the one proof of a snapshot run, kept by the decision of 2026-11-03)
  and the two lamp sweeps of `TrackLamps.Tests.ps1` (two engines, a stub editor and the module, each measured once).
- A run over the budget names a cold run as the import line does: when the antivirus signature of the ledger's last line before the run
  differs from the one at the run's end, the budget verdict says it is the first run since a signature update, so the reader looks at the
  second run, not at the slowest files.

## Open steps

The two tags, the one-child collapse and the budget verdict's growth comparison (`Get-TestRunGrowth`, spread against concentrated, the
rule's sentence) landed on 2026-11-16, each test file passing alone; the signature itself is not read, since the import that saw the change
may be hours before the run, while the spread of the growth tells a cold run from a regression.

- [ ] The user's runs, in task-user-runs-and-commits: the post-build run under its roof with the two moved files in, the warm source run,
      and a cold source run after the next signature update under 240 s. Check: the three `run.json` records; a cold run over the roof names
      the next duplicate proof here from its growth.

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-IMPORTER-CONSOLEROOF
  ([importer](../../docs/drs/automation/importer.md)), ADR-AUTO-RETRY
  ([retry-as-last-resort](../../docs/drs/automation/retry-as-last-resort.md)).
- The measurements: `out/test-automation/20261116-132816` against `20261109-233820`; `out/import-times.jsonl`.
