# pwsh/Base.Repository/Get-RepositoryFolder.ps1

The binding helper that turns a repository-relative folder path into a normalized absolute path.

## help

### synopsis

Returns the full, normalized path to a folder relative to the repository root.

### description

A binding helper (see [ADR-AUTO-PATH-NAMEBYFORM](../../../drs/automation/path-representation.md#rule-adr-auto-path-namebyform)): it takes a
repo-relative path and returns the normalized absolute path to bind against — '.\', '..', and mixed separators collapse, so a leading './'
never leaks into the result. Resolution is against the repository root, not $PWD. Delegates to Resolve-RepoPath so the normalization lives
in one place.

### parameter `Path`

Relative path from the repository root.

### example 1

```powershell
Get-RepositoryFolder 'pwsh/Base.Repository'
```
