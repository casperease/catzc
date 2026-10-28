# pwsh/Base.Repository/Get-RepositoryTextSource.ps1

The probe that tells a repository reader whether it answers from a source or from the working tree.

## help

### synopsis

Returns the source that Use-RepositoryTextSource holds, or nothing outside one.

### description

The source is a hashtable with `Name` (its identity, such as a commit id) and `Path` (its repository-relative paths, in ordinal order). A
reader that caches adds the name to its cache key. A reader that lists a folder tree filters the paths. The hashtable is shared, so callers
treat it as read-only.

### outputs

`[hashtable]`

### example 1

```powershell
(Get-RepositoryTextSource).Name
```
