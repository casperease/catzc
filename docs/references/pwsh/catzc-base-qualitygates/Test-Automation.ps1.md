# automation/pwsh/Catzc.Base.QualityGates/Test-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs all Pester tests found across the catzc modules, sharded across parallel worker processes.

### description

The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across worker processes (pwsh children
driven by the PesterRunner type), each of which imports the repository, runs its shard, writes `results-shard-<N>.xml` plus a
`rows-shard-<N>.json` sidecar, and streams its output through the pool — the first unfinished worker is live, later workers buffer and
replay in submission order, so the console reads sequentially while the wall clock runs in parallel. Files containing a 'greedy'-tagged test
(tests that fan out heavy machine load of their own but share no state) follow as single-file shards through the pool, one file per worker;
files containing a 'serial'-tagged test (tests that mutate state shared across processes) run last in a one-worker phase, alone — see
[ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../adr/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool). Pester executes tests
sequentially within a worker; a single file never splits across workers.

### parameter `MinLevel`

Minimum test level to run. Defaults to 0 (no lower bound). Tiers below MinLevel are excluded, so -MinLevel 2 -MaxLevel 2 runs only L2 tests.
Must not exceed MaxLevel.

### parameter `MaxLevel`

Maximum test level to run (alias: -Level). Defaults to 3: every tier the run's location allows. A run that owns the working folder runs
L0-L3; a run in a snapshot (another run holds the working folder, or -Isolated) skips L3 and says so
([ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../adr/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)). 4 adds the opt-in
L4 tier, the tests of the released system after final approval
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../adr/automation/test-automation.md#rule-adr-auto-test-testinginproduction)); run from a console
it is a run of that gate outside its pipeline, never a gate verdict. Tests self-skip when their tool or access is absent, so the default
stays green on a machine that is missing one. Tiers are defined by what a test integrates with (not by speed): L0/L1 = unit tests — pure
logic with every external boundary mocked. L2 = integrates with a local CLI tool for real (e.g. `az bicep build`, python, dotnet), inside
the repository. L3 = vertical system tests: they change or depend on state outside the repository — the cloud (e.g. `az deployment create`),
the user's environment, installed tools — so only the run that owns the working folder runs them. Level 1 runs L0 + L1. Level 2 runs L0 +
L1 + L2. Level 3 runs all. Every test must carry exactly one tier tag (L0-L3) and one category tag (logic|integrity); tests missing a tag
are reported before the run (see Get-TestTagViolations).

### parameter `Modules`

One or more automation module names to test (tab-completes from Get-CatzcModule -TrackType modules). Only the named modules' tests/ folders
run; dot-prefixed infrastructure (.internal, .scriptanalyzer) is excluded. Empty (the default) runs every module plus that infrastructure.
Composes with -Level and -Category.

### parameter `Category`

Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity` (tests that read the real repository contents —
shipped configs, real templates, the module graph, checked-in binaries, conventions), or `Both` (the default). Composes with -Level — e.g.
`-Level 1 -Category Logic` runs the L0/L1 logic tests only. Implemented by excluding the other category's tag.

### parameter `Workers`

How many parallel worker processes to shard the test files across. 0 (the default) sizes the pool automatically — max(1, ProcessorCount /
4), never more than the file count: past that the box is throughput-saturated, so extra workers only inflate per-test wall clock against the
level time limits. 1 runs everything through a single worker process (serialized, but still process-isolated). The serial phase always runs
one worker, after the parallel shards complete.

### parameter `GreedyGroupSize`

Greedy files run side by side in groups of this size, one group after another; 0 reads greedy_group_size from test-policy.yml.

### parameter `TimeoutSeconds`

Hard ceiling on each execution phase (the parallel pool, then the serial phase). On expiry every worker is killed and the run throws.
Defaults to this function's `[TimeLimit]` (360 s on a devbox, where a full run takes about 250 s; 3600 s in a pipeline), unless timeouts.yml
overrides it ([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](../../../adr/automation/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)).

### parameter `Output`

Pester output verbosity level inside each worker. Defaults to 'Detailed' (one line per test with its own duration); use 'Normal' for one
line per file, or 'Minimal' for just the final tally.

### parameter `PassThru`

Returns the run summary object: Result, TotalCount/PassedCount/FailedCount/SkippedCount/NotRunCount, DurationSeconds, Rows (the aggregated
per-test rows), RunDirectory, and Shards (the shard descriptors). By default, no object is returned.

### parameter `EnforceTimings`

Fail the run when a test exceeds its level's time limit. Off by default — timings are machine-dependent, so the run only _reports_
over-limit tests (with their durations) and stays green. Pass this (e.g. in a controlled CI lane) to turn the report into a failure.

### parameter `Rule`

Run only the tests that cite one of these ADR rules (the provenance filter) — e.g. `-Rule ADR-PWSH-ERROR-THROWNOTWRITEERROR`. Each value is
a citation in `ADR-<CODE>#<n>` form. The run narrows to the files carrying a matching test and, within them, to the cited tests (Pester tag
include). Composes with -Level/-Category/-Modules. It is the executable companion of the rule-coverage report: find a rule's tests, then run
just them.

### parameter `Suite`

Run a test suite: the named globset's declared `verify:` scope in globs.yml, resolved to the module list and tier to run
([ADR-AUTO-TEST-TESTSUITE](../../../adr/automation/test-automation.md#rule-adr-auto-test-testsuite); the blast-radius marker role,
[ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-everysethaslayer)) — "which tests do I
need to run to verify a change in that area-of-control". Mutually exclusive with -Modules; a globset without a verify scope is not a test
suite and throws with the remedy. Find the suites a change touches with Get-MarkerBlastRadius.

### parameter `OutputFolder`

Base directory for the run report. Every run writes a timestamped subfolder (`<OutputFolder>/yyyyMMdd-HHmmss/`) holding the per-shard
`results-shard-<N>.xml` (Pester NUnit), the `rows-shard-<N>.json` sidecars, summary.md, and tests.csv. Defaults to `<out>/test-automation`
(out/ locally, the artifact staging directory in a pipeline).

### parameter `Isolated`

Run in an isolated snapshot of the working folder even when it is free. A run never waits for another
([ADR-AUTO-TEST-RUNSNEVERWAIT](../../../adr/automation/test-automation.md#rule-adr-auto-test-runsneverwait)): when another run holds the
working folder this one runs in a snapshot anyway; this switch asks for a snapshot up front — a deterministic run, immune to edits made in
the working folder while it runs. The report lands in the working folder's out/ either way, and run.json records where the run executed.

### parameter `KeepSandbox`

Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.

### example 1

```powershell
Test-Automation
```

### example 2

```powershell
Test-Automation -Isolated -KeepSandbox   # run in a frozen snapshot of the working folder and keep it
```

### example 3

```powershell
Test-Automation -Level 2
```

### example 4

```powershell
Test-Automation -MinLevel 2 -MaxLevel 2   # run only the L2 tier (skip L0/L1)
```

### example 5

```powershell
Test-Automation -Modules Catzc.Base.ModuleSystem   # run only one module's tests
```

### example 6

```powershell
Test-Automation -Modules Catzc.Azure, Catzc.Azure.Cli -Level 2   # several modules, through L2
```

### example 7

```powershell
Test-Automation -Category Integrity   # run only integrity tests (real configs/templates/repo checks)
```

### example 8

```powershell
Test-Automation -Category Logic       # run only the hermetic logic tests
```

### example 9

```powershell
Test-Automation -Workers 4            # pin the pool size instead of the automatic sizing
```

### example 10

```powershell
Test-Automation -Output Detailed -PassThru
```

### example 11

```powershell
Test-Automation -EnforceTimings   # fail if any test is over its level's limit
```

### example 12

```powershell
Test-Automation -Rule ADR-PWSH-ERROR-THROWNOTWRITEERROR   # run only the tests that cite ADR-PWSH-ERROR-THROWNOTWRITEERROR
```

### example 13

```powershell
Test-Automation -Suite infrastructure   # run the infrastructure test suite (its globs.yml verify scope)
```

### example 14

```powershell
Test-Automation -OutputFolder C:\reports\catzc   # write the run report under a custom base
```

## comment:1

Above `if ($Suite) {`, written with `#`.

```text
-Suite: run a test suite — the named globset's declared verify scope resolves to the module list and tier
(Resolve-TestSuite, [ADR-AUTO-TEST-TESTSUITE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-testsuite)).
```

## comment:2

Above `Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation'...`, written with `#`.

```text
The harness itself — discovery, tag checks, sharding, workers, rows, reports — is the core both runs
share (Invoke-TestRun,
[ADR-AUTO-TEST-SAMETESTSBOTHRUNS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns)). The source run loads each
worker through the
repository importer, the core's default.
```
