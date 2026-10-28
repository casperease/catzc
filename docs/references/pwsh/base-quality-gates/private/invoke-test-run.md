# pwsh/Base.QualityGates/private/Invoke-TestRun.ps1

Performs one test run through the parallel harness. It is the shared core of Test-Automation and Test-CatzcBuild: it discovers the tests,
selects and splits the files, runs the workers, and reports the verdict.

## help

### synopsis

Performs one test run through the parallel harness — the shared core of Test-Automation and Test-CatzcBuild.

### description

The harness both runs share
([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns)): lazy-load Pester
from the code root, scan the selected modules' tests/ folders, discover once, enforce the mandatory tag axes, build the tier/category
filter, open a timestamped run directory with its run.json state record, split the files into parallel/greedy/serial phases, apply
per-module protection, run the workers, and write the timing check, reports, verdict, and -PassThru summary. The two test runs differ only
in what they pass in:

- the entry script each shard worker dot-sources (-EntryScript/-EntryParameter, empty for the source importer; the build's Import-Catzc.ps1
  for the build run) — the one seam;
- an opt-out tag (-OptOutTag 'source-only' for the build run): its tests are excluded from the run and counted and listed on the console and
  in excluded-tests.csv in the run directory
  ([ADR-AUTO-TEST-SOURCEONLYTAG](../../../../drs/automation/test-automation.md#rule-adr-auto-test-sourceonlytag));
- the entry point's name (-EntryPoint), which names the default report folder under out/, the protection key, and the failure message; and
  the banner title (-Title).

### parameter `EntryPoint`

The entry point's command name: 'Test-Automation' or 'Test-CatzcBuild'. Its key names the default report folder (out/test-automation,
out/test-catzc-build) and prefixes the protection key.

### parameter `Title`

The banner title (Write-TestAutomationHeader).

### parameter `MinLevel`

The lowest tier asked for; it must not exceed MaxLevel (Test-Automation's -MinLevel).

### parameter `MaxLevel`

The highest tier asked for; the run's location caps it (Resolve-TestRunMaxLevel): a snapshot never runs L3.

### parameter `Modules`

The modules whose tests/ folders run; empty runs every module plus the dot-prefixed infrastructure.

### parameter `Category`

Logic, Integrity or Both: which category of tests runs (Test-Automation's -Category).

### parameter `Workers`

Explicit pool size; 0 sizes automatically (Test-Automation's -Workers).

### parameter `GreedyGroupSize`

Greedy files run side by side in groups of this size; 0 reads greedy_group_size from test-policy.yml.

### parameter `TimeoutSeconds`

The entry point's own limit (its `[TimeLimit]` through Get-TimeoutSeconds -Command); no default here.

### parameter `Output`

Pester output verbosity: Detailed, Normal, Minimal or Diagnostic (Test-Automation's -Output).

### parameter `PassThru`

Return the aggregated per-test rows and the shard descriptors (Test-Automation's -PassThru).

### parameter `EnforceTimings`

Fail the run when a test is over its time limit; by default over-limit tests are only reported (Test-Automation's -EnforceTimings).

### parameter `Rule`

Narrows the run to the tests that cite these rules (Test-Automation's -Rule).

### parameter `Suite`

A test suite's name, when -Modules was resolved from one (Test-Automation -Suite); the context block names it.

### parameter `OutputFolder`

Report base; empty resolves to `<out>/<entry point in lowercase>`.

### parameter `OptOutTag`

Opt-out tags of this test run: tests carrying one are excluded, counted, and listed — never silently.

### parameter `EntryScript`

The script each worker dot-sources to load the modules; empty is the source importer.

### parameter `EntryParameter`

Named arguments for -EntryScript.

### parameter `Isolated`

Run in a snapshot of the working folder even when it is free (Enter-TestRunLocation).

### parameter `KeepSandbox`

Keep the snapshot (when the run used one) after the run, for a post-mortem.

## Discovery

Discovery runs before the banner and takes a while, so each stage prints a liveness dot
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](../../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)).

The run's tests folders come foundation first: module dependency order, dot-prefixed infrastructure last. Get-TestAutomationTestPaths owns
the scan and the ordering.

One discovery-only pass feeds every pre-run inspection. The tag check and the phase split (Split-TestAutomationFiles) share it, so the tree
is discovered once per run.

## Run directory and location

The run directory is a timestamped subfolder under the report base, so each run's artifacts are kept and cleared with the rest of `out/`.
The shard scripts, the per-shard `results-shard-<N>.xml` and `rows-shard-<N>.json`, and `summary.md` and `tests.csv` all land there.

Earlier runs whose owning process died never reached their `finally`. They are marked `abandoned` rather than left claiming `running`;
Set-AbandonedTestRun reads the owner recorded in `run.json`.

The run claims its location before anything is filtered, because Enter-TestRunLocation decides the top tier. The `finally` releases the
location and stamps the terminal manifest on every exit path: pass, fail or crash. The stamp is what makes `run.json` trustworthy, so it
sits in the `finally` and not in a best-effort `catch`.

## Context and manifest

The run's context, what it is and where it runs, is printed under the banner and recorded in `run.json` (Get-TestRunContext).

`run.json` is the run's self-describing state record. It is stamped `running` at the start and terminally (`passed`, `failed` or `crashed`)
in the `finally`, so a reader never infers completeness from which artifact files exist yet. The write is atomic (Write-TestRunManifest).
The owner, a process id and start time, lets a later run tell a live run from one whose process died.

## Tag filter

The tag filter excludes the tiers outside the minimum and maximum level and, when `-Category` is given, the other category, so only the
requested category's tests run. ExcludeTag matches an item's own tag, so the per-Context category tags of a mixed file filter correctly.
Test-InIsolation shares the filter through Get-TestExcludeTag.

## Work-list and phases

The work-list is every test file narrowed by `-Rule`, by tier and category scope, and by the opt-out tag (Select-TestRunFiles). Files
dropped for scope come back as NotRun rows, which are reported once after protection.

The files then fall into three execution phases: parallel shards, greedy single-file shards and strict serial
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).

## Protection

Units whose composite identity is unchanged since their last green run this session are dropped from the work-list here in the orchestrator
([ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-orchestratordecides)). Workers
never see the map, and in a pipeline the selection is a pass-through. The key carries the entry point and the run parameters, so an L0 to L1
green never skips an L2 run and a green run in the source mode never skips the build run.

After the workers finish, every candidate unit that came back green is promoted. Attribution is per module over the rows and conservative on
anything unattributable; Protect-TestedModule owns the rules. The dropped-for-scope rows are added after protection, since it promotes only
from what the workers ran, so every report reads the same rows whether a file was loaded or not.

## Worker environment

The unit-test tripwire for tool-free levels (L0 and L1) travels on each worker's own process environment, never the parent's `$env:`. If a
worker's test then launches a real process, a Mock failed to intercept it, almost always because `-ModuleName` pointed at the wrong module.
Invoke-Executable then throws inside the worker instead of leaking. A run capped below L2 holds only tool-free tests, so it blocks every
launch. Any other run arms the tripwire per container: Test-RealProcessBlocked blocks a launch only inside a Describe whose outermost tag is
L0 or L1. A full run therefore catches an L0 or L1 launch too, while the L2 and higher containers still drive real CLIs.

## Workers

The workers shard the files, run the pool (then the greedy and serial phases) and aggregate the row sidecars. When protection drained the
whole work-list there is nothing to execute, and the run is vacuously green.

## Verdict

A shard can report failure with zero failed test rows, because a container or discovery error fails its run without producing a failed test.
Either signal fails the aggregate verdict.

Test durations are validated against the per-level limits and the over-limit section is rendered (Write-TestAutomationTimingReport). It is
report-only by default and run-failing under `-EnforceTimings`. The limits and the whole-run budget come from the time safeguard's config
(Get-TestTimeLimits), never a literal here. A devbox run that outlasts its whole-run budget fails
([ADR-AUTO-TEST-DEVBOXRUNBUDGET](../../../../drs/automation/test-automation.md#rule-adr-auto-test-devboxrunbudget)).

The report files `summary.md`, `tests.csv` and `latest.txt` and the skip report are written best-effort and never mask the run's outcome;
Write-TestAutomationArtifacts owns the guards.

The verdict, a result and a one-line reason, is derived once. The closing banner and the failure throw both consume it, so the reason
wording lives in exactly one place. The closing bracket prints on every exit path, `-PassThru` included, so a run is always visually closed.
Console output is orthogonal to the `-PassThru` data return, with the banner on the information stream and the object on the output stream,
and orthogonal to the throw that still fires last on a fail.
