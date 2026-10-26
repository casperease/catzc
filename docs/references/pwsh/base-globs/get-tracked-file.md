# pwsh/Base.Globs/Get-TrackedFile.ps1

The matching universe of every globset: the tracked files of the repository, read from the index, as repo-relative `/`-separated paths.

## help

### synopsis

Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.

### description

`git ls-files` defines "files under version control"
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)): deterministic on every
checkout, independent of build residue, blind to untracked and ignored files. Read through Get-GitTrackedPath, the one place that answers it
(from the index, in-process —
[ADR-AUTO-TRACKED-ONESEAM](../../../drs/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked-oneseam)). A tracked file may be
missing on disk (an unstaged deletion) — it is still listed here; the hashing code folds a distinct marker for it.

### example 1

```powershell
Get-TrackedFile
```
