---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-TestAutomationWorkers.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7ffdef78f74c"
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$repositoryRoot = Get-RepositoryRoot`, written with `#`.

```text
The per-file durations the last runs measured on this machine, keyed on the source paths: the shards are dealt
from them longest first, so they finish together (Select-TestShardAssignment), and the greedy files go to the
pool longest first. A per-machine file beside the run folders, written at the end of this run.
```

## comment:2

Above `$shardArguments = @{`, written with `#`.

```text
The shard-script arguments every phase shares — including the entry-script seam (which entry script loads
the modules in each worker) and the tools this source session located for the language bridge (a build's
engine has no tools.yml entry to locate them from).
```

## comment:3

Above `$workerCount = if ($Workers -gt 0) {`, written with `#`.

```text
Pool size: explicit -Workers, else ProcessorCount / 4 — measured on all tests, wall clock is flat
from PC/4 up to PC/2 workers (the box saturates), while per-test wall clock inflates with every extra
worker until the level time limits read as breached. PC/4 keeps the timing report honest for free.
Never more workers than files, and at least one when only serial files exist (that pool is skipped below).
```

## comment:4

Above `$assignment = @(Select-TestShardAssignment -File $sourceParallelFiles...`, written with `#`.

```text
Deal the parallel files across the shards by measured duration, longest first to the least-loaded shard, so
the phase ends when its work does rather than when its unluckiest shard does; the serial phase (when present)
is one extra shard scheduled after the pool completes.
```

## comment:5

Above `$greedyGroupSize = if ($GreedyGroupSize -gt 0) {`, written with `#`.

```text
Greedy shards: one file each, scheduled through the pool after the parallel phase — machine-hungry
files overlap each other (their tests carry L2-scale time limits) without starving the parallel pool.
```

## comment:6

Above `$WorkerEnvironment = if ($WorkerEnvironment) {`, written with `#`.

```text
Workers inherit CATZC_TEST_RUN_LOCATION_HELD, so a test driving Invoke-TestFile for real inside this run
runs in place in this run's root instead of claiming a location of its own.
```

## comment:7

Above `Write-Message "Running $($ParallelFiles.Count) test file(s) across...`, written with `#`.

```text
Announce before the pool blocks: each worker pays its own importer + Pester load before the first
Pester line streams, so silence here would read as a hang
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```

## comment:8

Above `if ($greedyShards.Count -gt 0) {`, written with `#`.

```text
The greedy phase: single-file shards through the pool, one per worker — machine-hungry files
overlap each other but never the parallel phase. Phase offsets place each phase's workers (whose
start offsets are relative to their own Run call) on the run's single wall-clock timeline.
```

## comment:9

Above `if ($serialShard) {`, written with `#`.

```text
The serial phase runs last, alone — its files mutate state no other worker may see changing
underneath it.
```

## comment:10

Above `$rows = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Aggregate the rows sidecars, in shard order. A worker that exited outside {0,1} or never wrote its
artifacts (the rows sidecar AND the NUnit results file — asserted here, not inferred from the shard
script's write order) crashed before finishing its run — fail loudly naming the shard and the run
directory rather than reporting a partial run as the whole truth. run.json in that directory carries
the run's own status record (see Write-TestRunManifest).
```

## comment:11

Above `$isSerial = $serialShard -and $shard.Label -eq $serialShard.Label`, written with `#`.

```text
One summary per worker for the end-of-run table: queue number is submission order (greedy after
the pool, serial last), start is on the run's single wall-clock timeline (the workers of
each phase after the first offset by their phase boundary).
```

## comment:12

Above `$measured = @{}`, written with `#`.

```text
Every shard finished: record each file's measured duration for the next run's scheduling, keyed on its source
path. A shard without its files sidecar contributes nothing; the history keeps the file's last measurement.
The same entries, with their working-folder paths, are the run's Files: a file's own outcome and error.
```
