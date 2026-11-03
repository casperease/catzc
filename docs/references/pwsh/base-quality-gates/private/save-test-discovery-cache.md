# pwsh/Base.QualityGates/private/Save-TestDiscoveryCache.ps1

Writes the cross-session discovery file that Get-TestDiscovery keeps its stored records in.

## help

### synopsis

Saves the discovery cache to its file through a temporary file.

### description

The entries are written sorted by key as compact JSON to a temporary file beside the target, which is then moved over it, so a reader never
sees a half-written file. The folder is created when it is absent. A failure to write or move because the file is locked or not writable is
reported through Write-Message and skipped, as the cache is only a speed-up, and the temporary file is removed. The file is
out/cache/test-discovery.json, and Get-TestDiscoveryCache reads it.

### parameter `Path`

The discovery cache file.

### parameter `Cache`

The entries to save, keyed by file path and content digest.
