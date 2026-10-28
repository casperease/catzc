# pwsh/Base.GeneratedFiles/private/Get-GeneratedGuardHook.ps1

The private helper that the two hook commands share, so the path, the marker and the shim body have one source.

## help

### synopsis

Describes the guard hook of a clone: its path, marker line and shim body.

### description

Asks git for the hooks folder of the clone (`git rev-parse --git-path hooks`) and resolves it against the root when relative. It throws when
git names none.

### parameter `RepositoryRoot`

The clone whose hooks folder is asked.

### outputs

`[pscustomobject]` With `Path` (the pre-commit file), `Marker` (the line that names catzc's guard) and `Shim` (the LF-ended shell body).

### example 1

```powershell
Get-GeneratedGuardHook -RepositoryRoot (Get-RepositoryRoot)
```
