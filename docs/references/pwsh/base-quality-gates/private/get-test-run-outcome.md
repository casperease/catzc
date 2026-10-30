# pwsh/Base.QualityGates/private/Get-TestRunOutcome.ps1

Reduces the rows, file entries and shards of a test run to one outcome per test file that ran.

## help

### synopsis

Reduces a test run's rows, file entries and shards to one outcome per test file that ran.

### description

Each outcome holds the file's `Path`, whether it `Failed` and its `FailedCount`. A file entry marked `NotRun` has no outcome. A shard that
failed with no failed file or row, such as a container error, counts every file it ran as failed, never as passed. The outcomes feed
`Write-TestResultMarker`.

### parameter `Row`

The run's merged rows, their files already mapped to the working folder.

### parameter `File`

The run's file entries (`File`, `Result`), one per test file a worker ran, mapped the same way.

### parameter `Shard`

The run's shards (`Label`, `FilesPath`, `RowsPath`), read for a shard that failed with no failed file or row.

### parameter `FailedShardLabel`

The labels of the shards that failed.

### parameter `Location`

The run's location, used to map a shard's file paths back to the source.

### outputs

`[pscustomobject[]]` One outcome per file that ran: `Path`, `Failed` and `FailedCount`.

## Counting

The failed rows are counted per file in one pass, since a filter per file costs files times rows and stalls a full run.

## comment:1

Above `$failedByFile = @{}`, written with `#`.

```text
One outcome per file that ran. A NotRun row or a protected module has no file entry, so it has no outcome.
Failed rows counted per file in one pass; a filter per file is files x rows and stalls a full run.
```
