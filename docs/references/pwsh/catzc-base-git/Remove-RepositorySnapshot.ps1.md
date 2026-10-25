# pwsh/Catzc.Base.Git/Remove-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the
read-only files are mostly git objects under .git, so nothing is pruned.
```
