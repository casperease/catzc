# pwsh/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Splits the run's test files into the three execution phases: parallel, greedy, and serial.

### description

Inspects a discovery-only Pester result (Get-TestDiscovery — the same pass the tag check consumes) and classifies every file by the phase
tags (both optional) its tests resolve through their block chains (Get-TestBlockTag, nearest contributing block wins — the same resolution
as the tier/category axes):

- 'serial' — the test mutates state shared across worker processes (the committed .compiled assembly, a fixed out/ path two files both
  write). Its file runs in the final one-worker phase, strictly alone, one file after another.
- 'greedy' — the test consumes the machine beyond its own process (fans out a background-process pool, spawns importer-loading pwsh workers)
  but shares no mutable state with other files. Its file runs in the greedy phase: single-file shards through the worker pool, one file per
  worker, so greedy files overlap each other but never the parallel phase they would otherwise starve.
- untagged — the parallel phase (the round-robin shards).

A test that changes state outside the repository is not a phase concern: it is an L3 vertical system test, and only the run that owns the
working folder runs L3 (Resolve-TestRunMaxLevel,
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../../adr/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)).

A file carrying both serial and greedy is serial: strict isolation wins. Granularity is deliberately the file — a file is the unit a shard
schedules, so one tagged test moves its whole file. See the test-automation ADR
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../adr/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).

### parameter `Discovery`

The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.

### parameter `TestFiles`

The run's test files (absolute paths), already filtered to the run's scope.

### outputs

`[pscustomobject]` with Parallel, Greedy, and Serial — each a sorted `string[]` of absolute file paths (empty when nothing falls in that
phase); every input file lands in exactly one.
