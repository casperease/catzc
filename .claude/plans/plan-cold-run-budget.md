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
  and the two lamp sweeps of `TrackLamps.Tests.ps1` (two drivers, a stub editor and the module, each measured once).
- A run over the budget says where its growth lies against the last complete run of its kind, spread (a cold run, run again) or concentrated
  (one file, made faster); the signature is not read, since the import that saw it change may be hours before the run. Its first live use
  (2026-11-17) misdiagnosed a cold run: the baseline skipped a complete run that had two red tests and reached back to 2026-11-13, and the
  twelve language-bridge rows of one script name added up to one "file", so the cold penalty on the bridge's child sessions read as
  concentrated. The baseline is the newest complete run of the kind whatever its red tests, bridge rows key by their test folder as
  `durations.json` does, and concentrated means one file holds half or more of the growth.
- **The cold run after the cuts still reads over the roof**: 248.5 s on 2026-11-17 (`20261117-141530`, 0 failed; the console import of 13:13
  UTC was the first after a signature change, 15.3 s of wall for 9.1 s of CPU, the probe 63 ms against 9), against 235.3 s the day before on
  the same tree and 237.4 s warm on 2026-11-13. The band is now cold 235 to 248 against warm 205 to 237 with a 240 roof, so one more cut is
  needed. The fresh sessions looked like it (77 mentions of the importer in 42 test files, a child import 13 to 16 s pooled against 1.8 s
  for a console-shaped one), but measured on the run of 2026-11-17 those 42 files hold 211 file-seconds in all, and the largest must stay
  eager (`Import-AllModules` proves the load, `New-TestAutomationShardScript` runs a real worker, the bridge child reaches into a module);
  the children that may load lazily sum to about 60 file-seconds, 4 s of wall, so no file-by-file round is run for it now. The `-ModuleLoad`
  parameter stays as the mechanism for a child that runs one command.
- **The cold penalty is attacked where it arises**: the scanner rescans every file at its first read after a signature update, and the first
  console import after one already knows it (its line says so). That import starts one detached, idle-priority process that reads every file
  of the repository once, excluding the output folder, the git folder and the vendored tool folders, so the scanner's verdicts are warm
  before the run starts minutes later; a marker under the output folder keyed by the signature keeps a second console from warming again,
  and the import line says "warming the scanner's cache in the background". Only a console-shaped import does it: a worker or a child
  imports through a script file and writes no ledger line. Reading the tree is no control of the machine; the exclusion stays declined.
  Expected: the first run after a signature update reads in the warm band; the measure is the next such run against 248.5.
- **The mechanism is one importer parameter**, `-ModuleLoad eager|lazy`, overriding the load row's `moduleLoad` for that import
  (ADR-AUTO-IMPORTER-LOADEDBYFIRSTUSE and -MODEANDHOSTORTHOGONAL: the cell stays the default, the caller names the exception), passed by a
  test's child spawn when the child runs one command; no environment variable, since a child of a child must not inherit a choice its own
  test did not make. The test workers stay eager, as decided on 2026-11-06, because the harness reaches into loaded modules. The parameter
  lands as import-path work: the type-free switch in `Import-AllModules.ps1`'s policy read, the importer's parameter block (which
  `New-Importer` renders into `importer.ps1`), a staged burst, one fresh import after it.

- **The warmup's first live run** (2026-11-17, signature 1.463.344.0 at 21:58 UTC): 7844 files read in 45.7 s, an hour before the run
  `20261117-225953`, whose twelve worker imports read a normal file probe (9 to 15 ms against 63 at the console import), so the scanner's
  file verdicts were warm. The run still read 255.7 s, 0 failed, spread over 17 files, and the growth sits in the build tests
  (`Get-DynamicManifestContent` +44.9 s, `Test-ScriptAnalyzer` +33.9, `Invoke-ModuleBuild` +12.2, `Import-AllModules` +12.5): it was the
  first run after a commit that touched the importer and the builder, and `Get-BuildSourceStamp` counts every tracked file outside docs,
  plans and tests, so every stored build was stale and each build test rebuilt. Two penalties were confounded until now: the scanner's
  (addressed by the warmup) and the store's (every commit to code empties it). The measure of both is the second run on the unchanged tree;
  a narrower stamp, counting only a selection's inputs, is the candidate if that run reads warm and the first-after-commit run stays over.

- **The second run on the unchanged tree read 222.3 s** (`20261118-031946`, 0 failed), 33 s under the first after the commit, with the same
  signature and the warmup's marker in place: the scanner's part is covered, and what is left of the cold band is the build store emptying
  at every commit to code. **A build is stamped from the files it reads**, not from every tracked code file: the module folders of its
  selection, the engine under the internal folder, the root files the build copies, and the language tracks it packages (all of them when
  the profile is the whole repository, else the named ones); docs, plans, tests and the modules outside the selection no longer move the
  stamp, so a commit to a test or to one module keeps every other bundle's stored build. The post-build parity test keeps the net: a build
  reused against a changed input of its own would fail it.

## Open steps

The two tags, the one-child collapse and the budget verdict's growth comparison (`Get-TestRunGrowth`, spread against concentrated, the
rule's sentence) landed on 2026-11-16, each test file passing alone; the signature itself is not read, since the import that saw the change
may be hours before the run, while the spread of the growth tells a cold run from a regression. Its follow-up landed on 2026-11-17: the
baseline is the newest complete run of the kind whatever its red tests, bridge rows carry their test folder as a `Key` in the shard rows and
compare per folder from the first run after it, concentrated means half or more, and the spread sentence counts the grown files; replayed on
the cold run of that day it reads "spread over 17 files (top: Invoke-TestFile.Tests.ps1 +24.4s)". The importer parameter landed the same day
by three staged bursts: `-ModuleLoad eager|lazy` on the importer and in the rendered `importer.ps1`, applied once where the policy is
resolved, under every row, since the lookup hook is installed whenever a module is deferred (the row's trigger concerns the types only, and
the check that said otherwise is gone); a headless child importing lazily held 30 modules after import against every module, and loaded
Azure.Templates at the first command of it. The janitors still run at a headless import and pull about six modules; a child that needs no
root file refreshed also passes `-SkipJanitors`, the lean load the importer already has. The scanner warmup landed the same day by a staged
burst: `Start-ScanWarmup` and the child's `Invoke-ScanWarmup` under the importer's assets, called from the ledger write when the signature
changed, one idle-priority detached read of the tree per signature with the marker `out/scan-warmup/<signature>.json` (the count lands in
the marker when the child ends, so the import line says only ", warming the scanner's cache in the background"), the rule's half sentence
and the section paragraph in the importer record; eighteen ledger cases and the warmup's own case pass. No real warmup has run yet: the next
signature update is its first.

The stamp landed on 2026-11-18: `Get-BuildSourceInput` names what a build reads (the selected modules' folders, the internal, vendor and
analyzer folders, every module's `types/`, the engine modules whose configs and commands decide the bytes, the tools pins, the config
overlay, the packaged language modules; contracts and unselected modules are no input), `Get-BuildSourceStamp -InputPath` counts those files
only and throws without a list, ADR-AUTO-BUNDLE-IMMUTABLEBUILD says so; the base bundle's dry-run stamp at landing is `c169e6fa018603e6`.
The commit that lands it touches the internal folder, so every bundle rebuilds once more; the proof is the first run after a later commit
outside the bundles' inputs, read from its build tests' seconds.

- [ ] The user's runs, in task-user-runs-and-commits: the warm source run after each landing, and a cold source run after the next signature
      update under 240 s, the first one with the warmup in. Check: the `run.json` records; a cold run over the roof names the next cut here
      from its growth.

## Open questions

- Whether the `catzc-run` skill gains one line naming the gates that take no `-Path` (`Test-Glossary`, `Test-Terminology`,
  `Test-DrsEngineNeutrality` run whole), since two drones and the meister each lost a call to it this round (proposed at the checkpoint of
  2026-11-18, unanswered).

## Refs

- ADR-AUTO-TEST ([test-automation](../../docs/drs/automation/test-automation.md)), ADR-AUTO-IMPORTER-CONSOLEROOF
  ([importer](../../docs/drs/automation/importer.md)), ADR-AUTO-RETRY
  ([retry-as-last-resort](../../docs/drs/automation/retry-as-last-resort.md)).
- The measurements: `out/test-automation/20261116-132816` against `20261109-233820`; `out/import-times.jsonl`.
