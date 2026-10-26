# pwsh/Base.QualityGates/private/Get-TestPoolSize.ps1

Returns how many workers a test run's pool starts at once. At least one worker starts.

## help

### synopsis

Returns how many workers a test run's pool starts at once.

### description

Every parallel shard starts with the run, and the greedy files get workers of their own beside them, up to the greedy group size, so the
longest greedy files start at the beginning of the run instead of waiting for a shard to finish. The pool is never smaller than one worker.

### parameter `ParallelShardCount`

The number of parallel shards the run starts.

### parameter `GreedyFileCount`

The number of greedy test files the run holds.

### parameter `GreedyGroupSize`

The most greedy files that run at once (`greedy_group_size` in the test policy).

### outputs

`[int]` the number of workers in the pool.

## Sizing

Every parallel shard starts with the run. The greedy files get workers of their own, up to the group size, so the longest of them start with
the run too.
