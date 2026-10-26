# pwsh/Base.QualityGates/private/Select-TestShardAssignment.ps1

Assigns a run's parallel test files to worker shards by their measured duration, longest first, so the shards finish together. A phase lasts
as long as its slowest shard.

## help

### synopsis

Assigns a run's parallel test files to worker shards by their measured duration, longest first, so the shards finish together.

### description

A phase lasts as long as its slowest shard, so the files are dealt longest first, each to the shard with the least work so far
(longest-processing-time first). A file's work is its duration from the last run that ran it (Get-TestDurationHistory); a file without one
counts as the median of the known durations, or 1 s when nothing is known yet, so a first run is a fair even split. Ties keep the files'
given order, so the result is deterministic.

### parameter `File`

The parallel test files, absolute paths.

### parameter `WorkerCount`

How many shards to fill.

### parameter `DurationMs`

The known durations, repository-relative '/'-separated file path -> milliseconds.

### parameter `RepositoryRoot`

The root the history's paths are relative to.

### outputs

`[string[]]` One array of files per shard, in shard order; a shard with no file is an empty array.
