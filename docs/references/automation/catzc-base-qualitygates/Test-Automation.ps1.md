---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Automation.ps1.md
    kind: comment-page
    body_sha: f3294df13643
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TEST#32
      - ADR-AUTO-TEST#33
      - ADR-AUTO-TEST#37
      - ADR-AUTO-TEST#41
      - ADR-FLOW-CD-GLOBS#7
      - ADR-PWSH-ASSERT#1
      - ADR-PWSH-ERROR#3
---

# automation/Catzc.Base.QualityGates/Test-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The harness parallelizes at whole-file granularity: the run's test files are round-robin sharded across
worker processes (pwsh children driven by the PesterRunner type), each of which imports the repository,
runs its shard, writes results-shard-<N>.xml plus a rows-shard-<N>.json sidecar, and streams its output
through the pool — the first unfinished worker is live, later workers buffer and replay in submission
order, so the console reads sequentially while the wall clock runs in parallel. Files containing a
'greedy'-tagged test (tests that fan out heavy machine load of their own but share no state) follow as
single-file shards through the pool, one file per worker; files containing a 'serial'-tagged test
(tests that mutate state shared across processes) run last in a one-worker phase, alone — see
[ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26). Pester executes tests sequentially
within a worker; a single file never splits across
workers.
```

## comment:2

Section `.PARAMETER MaxLevel` of the comment-based help.

```text
Maximum test level to run (alias: -Level). Defaults to 3: every tier the run's location allows. A run that
owns the working folder runs L0-L3; a run in a snapshot (another run holds the working folder, or
-Isolated) skips L3 and says so ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
4 adds the opt-in L4 tier, the tests of the released system after final approval
([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)); run from a console it is a
run of that gate outside its pipeline, never a gate verdict.
Tests self-skip when their tool or access is absent,
so the default stays green on a machine that is missing one.
Tiers are defined by what a test integrates with (not by speed):
L0/L1 = unit tests — pure logic with every external boundary mocked. L2 = integrates with a local CLI
tool for real (e.g. `az bicep build`, python, dotnet), inside the repository. L3 = vertical system tests:
they change or depend on state outside the repository — the cloud (e.g. `az deployment create`), the
user's environment, installed tools — so only the run that owns the working folder runs them.
Level 1 runs L0 + L1. Level 2 runs L0 + L1 + L2. Level 3 runs all.
Every test must carry exactly one tier tag (L0-L3) and one category tag (logic|integrity); tests
missing a tag are reported before the run (see Get-TestTagViolations).
```

## comment:3

Section `.PARAMETER MinLevel` of the comment-based help.

```text
Minimum test level to run. Defaults to 0 (no lower bound). Tiers below MinLevel are excluded, so
-MinLevel 2 -MaxLevel 2 runs only L2 tests. Must not exceed MaxLevel.
```

## comment:4

Section `.PARAMETER Modules` of the comment-based help.

```text
One or more automation module names to test (tab-completes from Get-AutomationModules). Only the named
modules' tests/ folders run; dot-prefixed infrastructure (.internal, .scriptanalyzer) is excluded.
Empty (the default) runs every module plus that infrastructure. Composes with -Level and -Category.
```

## comment:5

Section `.PARAMETER Category` of the comment-based help.

```text
Which category of test to run: `Logic` (function-logic tests on mocks/fixtures), `Integrity`
(tests that read the real repository contents — shipped configs, real templates, the module graph,
checked-in binaries, conventions), or `Both` (the default). Composes with -Level — e.g.
`-Level 1 -Category Logic` runs the L0/L1 logic tests only. Implemented by excluding the other
category's tag.
```

## comment:6

Section `.PARAMETER Workers` of the comment-based help.

```text
How many parallel worker processes to shard the test files across. 0 (the default) sizes the pool
automatically — max(1, ProcessorCount / 4), never more than the file count: past that the box is
throughput-saturated, so extra workers only inflate per-test wall clock against the level time limits.
1 runs everything through a single worker process (serialized, but still process-isolated). The serial
phase always runs one worker, after the parallel shards complete.
```

## comment:7

Section `.PARAMETER TimeoutSeconds` of the comment-based help.

```text
Hard ceiling on each execution phase (the parallel pool, then the serial phase). On expiry every worker
is killed and the run throws. Defaults to this function's [TimeLimit] (360 s on a devbox, where a full run takes
about 250 s; 3600 s in a pipeline), unless timeouts.yml overrides it
([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)).
```

## comment:8

Section `.PARAMETER Output` of the comment-based help.

```text
Pester output verbosity level inside each worker. Defaults to 'Detailed' (one line per test with its
own duration); use 'Normal' for one line per file, or 'Minimal' for just the final tally.
```

## comment:9

Section `.PARAMETER PassThru` of the comment-based help.

```text
Returns the run summary object: Result, TotalCount/PassedCount/FailedCount/SkippedCount/NotRunCount,
DurationSeconds, Rows (the aggregated per-test rows), RunDirectory, and Shards (the shard descriptors).
By default, no object is returned.
```

## comment:10

Section `.PARAMETER Rule` of the comment-based help.

```text
Run only the tests that cite one of these ADR rules (the provenance filter) — e.g. `-Rule ADR-PWSH-ERROR#3`.
Each value is a citation in `ADR-<CODE>#<n>` form. The run narrows to the files carrying a matching test
and, within them, to the cited tests (Pester tag include). Composes with -Level/-Category/-Modules. It is
the executable companion of the rule-coverage report: find a rule's tests, then run just them.
```

## comment:11

Section `.PARAMETER Suite` of the comment-based help.

```text
Run a test suite: the named globset's declared `verify:` scope in globs.yml, resolved to the module list and
tier to run ([ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37); the blast-radius
marker role, [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)) — "which tests do I
need to run to verify a change in that area-of-control". Mutually exclusive with -Modules; a globset without a
verify scope is not a test suite and throws with the remedy. Find the suites a change touches with
Get-MarkerBlastRadius.
```

## comment:12

Section `.PARAMETER EnforceTimings` of the comment-based help.

```text
Fail the run when a test exceeds its level's time limit. Off by default — timings are
machine-dependent, so the run only *reports* over-limit tests (with their durations) and stays
green. Pass this (e.g. in a controlled CI lane) to turn the report into a failure.
```

## comment:13

Section `.PARAMETER OutputFolder` of the comment-based help.

```text
Base directory for the run report. Every run writes a timestamped subfolder
(<OutputFolder>/yyyyMMdd-HHmmss/) holding the per-shard results-shard-<N>.xml (Pester NUnit), the
rows-shard-<N>.json sidecars, summary.md, and tests.csv. Defaults to <out>/test-automation (out/
locally, the artifact staging directory in a pipeline).
```

## comment:14

Section `.PARAMETER Isolated` of the comment-based help.

```text
Run in an isolated snapshot of the working folder even when it is free. A run never waits for another
([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): when another run holds the
working folder this one runs in a snapshot anyway; this
switch asks for a snapshot up front — a deterministic run, immune to edits made in the working folder
while it runs. The report lands in the working folder's out/ either way, and run.json records where the
run executed.
```

## comment:15

Above `if ($Suite) {`.

```text
-Suite: run a test suite — the named globset's declared verify scope resolves to the module list and tier
(Resolve-TestSuite, [ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)).
```

## comment:16

Above `Invoke-TestRun -EntryPoint 'Test-Automation' -Title 'Test Automation'...`.

```text
The harness itself — discovery, tag checks, sharding, workers, rows, reports — is the core both runs
share (Invoke-TestRun,
[ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)). The source run loads each
worker through the
repository importer, the core's default.
```
