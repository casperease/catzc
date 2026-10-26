# pwsh/Base.Git/Remove-RepositorySnapshot.ps1

The deleter of a repository snapshot: it removes a folder only when it carries the provenance marker `New-RepositorySnapshot` wrote.

## help

### synopsis

Deletes a repository snapshot made by New-RepositorySnapshot.

### description

Removes the snapshot folder in one `[System.IO.Directory]::Delete` call, not item by item. It refuses any folder that does not carry
New-RepositorySnapshot's provenance marker (.git/catzc-snapshot.json), so a wrong path can never delete a real checkout. Read-only files
(git writes some) are made writable and the delete is retried once. A path that no longer exists is a no-op.

### parameter `Path`

The snapshot folder (the Path of New-RepositorySnapshot's result).

### outputs

None.

### example 1

```powershell
Remove-RepositorySnapshot $snapshot.Path
```

## The walk prunes nothing

Clearing read-only files is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the read-only files
are mostly git objects under `.git`, so nothing is pruned.
