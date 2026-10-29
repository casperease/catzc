# pwsh/Base.QualityGates/private/Save-TestShardDurations.ps1

Records each test file's measured duration after a run, so the next run deals its shards longest first.

## help

### synopsis

Reads every shard's file sidecar, saves the measured durations to the duration history, and returns the file entries.

### description

For each shard whose files sidecar exists, reads its entries, maps each file back to its source path, and keys its duration by the file (and
by the greedy file it ran alone for, when the shard held one file). Saves the measured durations to the history file when any were measured,
and returns every file entry with its source path. A shard without its sidecar adds nothing.

### parameter `Shard`

The run's shards, each with its `Label` and its `FilesPath` sidecar.

### parameter `GreedyShardFile`

The greedy shards' labels mapped to the one file each ran.

### parameter `Location`

The run's location, used to map the run's paths back to the source tree.

### parameter `RepositoryRoot`

The repository root the duration keys are relative to.

### parameter `HistoryPath`

The `durations.json` file the measured durations are saved to.
