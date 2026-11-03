# pwsh/Base.Globs/Get-FileDigest.ps1

The per-file digest of the module: the `DurableHash` digest of each path, read from a per-machine cache when git proves the file unchanged
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)).

## help

### synopsis

The `DurableHash` digests of repository files in order, with the read skipped for a file git proves unchanged.

### description

Each digest is exactly what `[Catzc.Base.Globs.DurableHash]::HashFile` returns for the file: SHA-256 over the bytes with every CR stripped,
and null for a file missing on disk. The function lists git's index once (`ls-files -s`, the object id per path) and the modified files once
(`ls-files -m`). A file at stage 0, neither a symlink nor a submodule, and not modified is looked up in `out/cache/file-digests.json` under
`<relative path>|<object id>`; a hit is returned without reading the file, a miss is hashed and recorded. A modified, untracked, conflicted
or missing file is always hashed and never recorded, since its index id does not vouch for its bytes.

The cache is written back once per call when it gained entries or lost stale ones: an entry whose path or object id no longer appears in the
index is dropped, so the file stays bounded by the index. The write goes to `<path>.<PID>.tmp` and is moved over the cache file, so a
concurrent reader sees a whole file. A torn or foreign cache file is treated as empty. When git cannot answer (no work tree, no git, a
non-zero exit) every file is hashed and nothing is cached. Losing the cache costs one full read of the tree.

### parameter `RepositoryRoot`

The repository root that the paths are relative to and git is asked in.

### parameter `Path`

The repository-relative paths, `/`-separated.

### example 1

```powershell
Get-FileDigest -RepositoryRoot (Get-RepositoryRoot) -Path 'pwsh/Base.Globs/Get-GlobSetHash.ps1'
```
