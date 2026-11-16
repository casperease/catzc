# pwsh/Base.QualityGates/private/Get-TestRunGrowth.ps1

Measures where a run over its budget grew, against the last run of its kind that fit the budget, so the verdict tells a cold run from one
slow file.

## help

### synopsis

The growth of a run's file seconds against the newest earlier run of its kind that passed.

### description

Reads the run folders beside the current one, newest first, and takes the first whose `run.json` reads `passed` and whose context is of the
same kind: the same run, selection, tier range and post-build flag, so a post-build run is never compared with a source run. Its
`files-shard-*.json` records are summed per file, a file keyed by its module folder, tests folder and name so a snapshot run matches an
in-place one, and compared with the current run's files over the files both ran. The growth is spread when the top file holds less than a
third of it, the mark of a cold run after an antivirus signature update
([ADR-AUTO-TEST-DEVBOXRUNBUDGET](../../../../drs/automation/test-automation.md#rule-adr-auto-test-devboxrunbudget)). The comparison is best
effort: no earlier run of the kind, no file records, an unreadable record or no growth returns nothing, never a throw.

### parameter `OutputFolder`

The report base holding the run folders.

### parameter `RunDirectory`

The current run's folder, never compared with itself.

### parameter `File`

The current run's per-file records, each with `File` and `DurationMs`.

### parameter `Context`

The current run's context as `run.json` records it, which decides the kind of run to compare with.

### outputs

`[pscustomobject]` with `Run` (the earlier run's folder name), `Seconds` (its duration), `GrowthSeconds`, `TopFile`, `TopGrowthSeconds` and
`Spread`; nothing when there is no comparison.

### example 1

```powershell
Get-TestRunGrowth -OutputFolder $outputFolder -RunDirectory $runDir -File @($workerRun.Files) -Context $context
```
