# pwsh/Base.QualityGates/private/Save-AbandonedRunDurationHistory.ps1

Feeds the duration history from the shards an abandoned run finished, so the next run deals its files by measured time.

## help

### synopsis

Records the file durations that abandoned runs left in their shard sidecars.

### description

A run killed past its roof never saved its durations. Each shard of such a run left a `files-shard-*.json` sidecar of file durations; this
reads them, skips an unreadable one, keeps only the `*.Tests.ps1` files inside the repository root (a bridged test reports the shared bridge
script, whose key only the live run knows, and a snapshot path lies outside the root), and saves them to the history.

### parameter `RunDirectory`

The folders of the abandoned runs; a folder that is gone is skipped.

### parameter `Path`

The duration history file to save to.

### example 1

```powershell
Save-AbandonedRunDurationHistory -RunDirectory $abandoned -Path $historyPath
```
