# automation/pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Performs one test run through the parallel harness — the shared core of Test-Automation and Test-CatzcBuild.

### description

The harness both runs share
([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../../adr/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns)): lazy-load Pester
from the code root, scan the selected modules' tests/ folders, discover once, enforce the mandatory tag axes, build the tier/category
filter, open a timestamped run directory with its run.json state record, split the files into parallel/greedy/serial phases, apply
per-module protection, run the workers, and write the timing check, reports, verdict, and -PassThru summary. The two test runs differ only
in what they pass in:

- the entry script each shard worker dot-sources (-EntryScript/-EntryParameter, empty for the source importer; the build's Import-Catzc.ps1
  for the build run) — the one seam;
- an opt-out tag (-OptOutTag 'source-only' for the build run): its tests are excluded from the run and counted and listed on the console and
  in excluded-tests.csv in the run directory
  ([ADR-AUTO-TEST-SOURCEONLYTAG](../../../../adr/automation/test-automation.md#rule-adr-auto-test-sourceonlytag));
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

Narrows the run to the tests that cite these ADR rules (Test-Automation's -Rule).

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

## comment:1

Above `Write-Message '.' -NoHeader -NoNewline`, written with `#`.

```text
Liveness dots ([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](/docs/adr/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)): discovery
runs before the banner and takes a while, so each stage shows a dot.
```

## comment:2

Above `$testPaths = @(Get-TestAutomationTestPaths -Modules $Modules)`, written with `#`.

```text
The run's tests folders, foundation-first — module dependency order, dot-prefixed infrastructure last
(Get-TestAutomationTestPaths owns the scan and the ordering).
```

## comment:3

Above `$discovery = Get-TestDiscovery -TestPath $testPaths`, written with `#`.

```text
One discovery-only pass feeds every pre-run inspection: the tag check below and the phase split
(Split-TestAutomationFiles) share it, so the tree is discovered once per run.
```

## comment:4

Above `if (-not $OutputFolder) {`, written with `#`.

```text
Resolve the run directory — a timestamped subfolder under the report base so each run's artifacts are
preserved (and cleared with the rest of out/). The shard scripts, per-shard results-shard-<N>.xml and
rows-shard-<N>.json, and summary.md/tests.csv all land here.
```

## comment:5

Above `Set-AbandonedTestRun -OutputFolder $OutputFolder | Out-Null`, written with `#`.

```text
Earlier runs whose owning process died never reached their finally: mark them 'abandoned' rather than
leave them claiming 'running' (Set-AbandonedTestRun reads the owner recorded below).
```

## comment:6

Above `$location = Enter-TestRunLocation -EntryPoint $EntryPoint -RunDirectory...`, written with `#`.

```text
Claim the run's location before anything is filtered (Enter-TestRunLocation; it decides the top tier); the
finally releases it.
```

## comment:7

Above `try {`, written with `#`.

```text
try/finally: the location is released and the terminal manifest stamped on every exit path — pass, fail, or crash.
The stamp is what makes run.json trustworthy, so it sits in the finally, not in a best-effort catch.
```

## comment:8

Above `$context = Get-TestRunContext -EntryPoint $EntryPoint -EntryScript...`, written with `#`.

```text
The run's context — what it is and where it runs — printed under the banner and recorded in run.json
(Get-TestRunContext).
```

## comment:9

Above `$excludeTags = Get-TestExcludeTag -MinLevel $MinLevel -MaxLevel $MaxLevel...`, written with `#`.

```text
Build tag filter — exclude tiers outside [MinLevel, MaxLevel] and (when -Category is given) the other
category, so only the requested category's tests run. ExcludeTag matches an item's own tag, so a mixed
file's per-Context category tags filter correctly. Shared with Test-InIsolation via Get-TestExcludeTag.
```

## comment:10

Above `Write-TestRunManifest -RunDirectory $runDir -Manifest ([ordered]@{`, written with `#`.

```text
The run's self-describing state record (run.json): stamped 'running' now, and terminally
('passed'|'failed'|'crashed') in the finally below — so a reader never has to infer completeness from
which artifact files happen to exist yet (Write-TestRunManifest; the write is atomic). The owner (PID
and start time) lets a later run tell a live run from one whose process died ('abandoned').
```

## comment:11

Above `$selection = Select-TestRunFiles -TestPath $testPaths -Discovery $discovery...`, written with `#`.

```text
The work-list: every test file, narrowed by -Rule, by tier and category scope, and by the opt-out tag
(Select-TestRunFiles). Files dropped for scope come back as NotRun rows, reported once after protection.
```

## comment:12

Above `$phases = Split-TestAutomationFiles -Discovery $discovery -TestFiles $testFiles`, written with `#`.

```text
Three execution phases — parallel shards, greedy single-file shards, strict serial (see
Split-TestAutomationFiles / [ADR-AUTO-TEST-ONESCHEDULINGPOOL](/docs/adr/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).
```

## comment:13

Above `$protectionKey = "$entryPointKey|L$MinLevel-L$MaxLevel|$Category|$($Rule...`, written with `#`.

```text
Per-module protection
([ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob-orchestratordecides)): units whose
composite identity is unchanged since their last
green run this session are dropped from the work-list here in the orchestrator (workers never see
the map; in a pipeline the selection is a pass-through). The key carries the entry point and the run
parameters, so an L0-L1 green never skips an L2 run and a green run in the source mode never skips the
build run.
```

## comment:14

Above `$workerEnvironment = if ($MaxLevel -lt 2) {`, written with `#`.

```text
The unit-test tripwire for tool-free levels (L0/L1) travels on each worker's own process environment —
never the parent's $env:. If a worker's test then launches a real process, a Mock failed to intercept
it — almost always a -ModuleName pointing at the wrong module — so Invoke-Executable throws inside the
worker instead of leaking. L2+ legitimately drive real CLIs, so it stays off there.
```

## comment:15

Above `$workerRun = if (($parallelFiles.Count + $greedyFiles.Count +...`, written with `#`.

```text
Shard, run the pool (then the greedy and serial phases), and aggregate the row sidecars — the engine.
When protection drained the whole work-list, there is nothing to execute: the run is vacuously green.
```

## comment:16

Above `` Protect-TestedModule -Candidates @($protectionPlan.Candidates) -Rows $rows ` ``, written with `#`.

```text
Promote protection for every candidate unit that came back green — per-module attribution over the
rows, conservative on anything unattributable (Protect-TestedModule owns the rules).
```

## comment:17

Above `$rows = @($rows) + @($selection.OutOfScopeRows)`, written with `#`.

```text
The scope filter's dropped files report their tests as NotRun, once, after protection (which promotes only
from what the workers ran): every report below reads the same rows whether a file was loaded or not.
```

## comment:18

Above `$runResult = if ($failedCount -gt 0 -or $failedShardLabels.Count -gt 0) {`, written with `#`.

```text
A shard can report failure with zero failed test rows — a container/discovery error fails its run
without producing a failed test. Either signal fails the aggregate verdict.
```

## comment:19

Above `$testTimeLimits = Get-TestTimeLimits`, written with `#`.

```text
Validate test durations against the per-level limits and render the over-limit section
(Write-TestAutomationTimingReport): report-only by default, run-failing under -EnforceTimings. The limits
and the whole-run budget come from the time safeguard's config (Get-TestTimeLimits), never a literal here.
```

## comment:20

Above `$budgetFailure = Test-TestRunOverBudget -DurationSeconds...`, written with `#`.

```text
A devbox run that outlasts its whole-run budget fails
([ADR-AUTO-TEST-DEVBOXRUNBUDGET](/docs/adr/automation/test-automation.md#rule-adr-auto-test-devboxrunbudget)).
```

## comment:21

Above `Write-TestAutomationArtifacts -Rows $rows -RunDirectory $runDir -OutputFolder...`, written with `#`.

```text
Persist summary.md/tests.csv + latest.txt and render the skip report — best-effort, never masking
the run outcome (Write-TestAutomationArtifacts owns the guards).
```

## comment:22

Above `$verdict = Get-TestAutomationVerdict -Rows $rows -Limits $limits -RunResult...`, written with `#`.

```text
Derive the verdict (Result + one-line reason) once; the closing banner and the failure throw both
consume it, so the reason wording lives in exactly one place.
```

## comment:23

Above `` Write-TestAutomationVerdict -Result $verdict.Result -Summary $verdict.Summary ` ``, written with `#`.

```text
The closing bracket prints on every exit path — pass, fail, and -PassThru alike — so a run is always
visually closed. Console UX is orthogonal to the -PassThru data return (banner on the information
stream, object on the output stream), and orthogonal to the throw that still fires last on a fail.
```
