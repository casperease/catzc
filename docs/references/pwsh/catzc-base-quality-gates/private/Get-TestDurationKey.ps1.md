# pwsh/Base.QualityGates/private/Get-TestDurationKey.ps1

Returns the key a test file's measured duration is stored and looked up under: the file's repository-relative path with forward slashes. One
function names the key, so the writer and the reader of the history agree.

## help

### synopsis

Returns the key a test file's measured duration is stored and looked up under.

### description

The key is the file's repository-relative path with forward slashes. A one-file shard is keyed by the file it was given rather than the file
it reports, because a bridged go or python test reports the shared bridge script as its file; without this every bridged shard would share
one key and lose its own weight.

### parameter `File`

The test file a result row reports.

### parameter `ShardFile`

The one file a greedy shard was given, when the shard holds a single file.

### parameter `RepositoryRoot`

The repository root the key is made relative to.

### outputs

`[string]` the repository-relative key, with forward slashes.
