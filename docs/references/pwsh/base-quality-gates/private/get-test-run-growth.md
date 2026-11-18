# pwsh/Base.QualityGates/private/Get-TestRunGrowth.ps1

Measures where a run over its budget grew, against the last complete run of its kind, so the verdict tells a cold run from one slow file.

## help

### synopsis

The growth of a run's file seconds against the newest earlier complete run of its kind.

### description

Reads the run folders beside the current one, newest first, and takes the first complete run of the same kind. The kind is the same run,
selection, tier range and post-build flag, so a post-build run is never compared with a source run. A run is complete when its `run.json`
reads `passed` or `failed` and every shard it names left a `files-shard-*.json` record with all its files: red tests leave the timing sound,
while an abandoned, crashed or stopped run is skipped.

Each row is keyed as the duration history keys it: by the `Key` the shard record carries (a language test folder for a row of the shared
bridge script, so each folder compares with itself), else by its path relative to the repository root. A bridge row with no recorded key
names only the shared bridge script, so it is left out rather than summed with the other folders. The growth is summed over the files both
runs ran. It is concentrated when the top file holds at least half of it, and spread otherwise, the mark of a cold run after an antivirus
signature update; the files grown by two seconds or more are counted for the spread wording
([ADR-AUTO-TEST-DEVBOXRUNBUDGET](../../../../drs/automation/test-automation.md#rule-adr-auto-test-devboxrunbudget)). The comparison is best
effort: no earlier complete run of the kind, an unreadable record or no growth returns nothing, never a throw.

### parameter `OutputFolder`

The report base holding the run folders.

### parameter `RunDirectory`

The current run's folder, never compared with itself.

### parameter `File`

The current run's per-file records, each with `File`, `DurationMs` and, from Save-TestShardDurations, `Key`.

### parameter `Context`

The current run's context as `run.json` records it, which decides the kind of run to compare with.

### parameter `RepositoryRoot`

The root a row without a recorded key is keyed relative to; defaults to the repository root.

### outputs

`[pscustomobject]` with `Run` (the earlier run's folder name), `Seconds` (its duration), `GrowthSeconds`, `GrownFiles` (the files grown by
two seconds or more), `TopFile` (a file's name, or a bridged folder's key), `TopGrowthSeconds` and `Spread`; nothing when there is no
comparison.

### example 1

```powershell
Get-TestRunGrowth -OutputFolder $outputFolder -RunDirectory $runDir -File @($workerRun.Files) -Context $context
```

## comment:1

Above `$addSeconds = {`, written with `#`.

```text
A row is keyed as the duration history keys it: its recorded key (a bridged folder for a language test), else its relative path.
A bridge row with no recorded key names only the shared bridge script, so it is left out rather than summed with the other folders.
```
