# pwsh/Base.Repository/Get-RepositoryRoot.ps1

The reader of the working repository root the importer sets in `$env:RepositoryRoot`.

## help

### synopsis

Returns the repository root path.

### description

Returns the value of $env:RepositoryRoot set by importer.ps1, and throws when it is unset or empty.

### example 1

```powershell
Get-RepositoryRoot
```
