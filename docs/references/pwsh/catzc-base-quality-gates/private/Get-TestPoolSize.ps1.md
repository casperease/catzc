# pwsh/Catzc.Base.QualityGates/private/Get-TestPoolSize.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
