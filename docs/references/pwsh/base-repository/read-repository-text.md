# pwsh/Base.Repository/Read-RepositoryText.ps1

The one text reader for a repository file that a source may stand in for.

## help

### synopsis

Returns the text of a repository file, from the active source or the working tree, or nothing when the file is absent.

### description

Outside a source, it reads the file from disk as [System.IO.File]::ReadAllText does. Inside Use-RepositoryTextSource, a repository path
reads the source's text. A path the source does not list is absent. A listed path whose text the source did not load throws, so a reader
never falls back to the working tree. A path outside the repository reads from disk in either mode.

### parameter `Path`

The file, either absolute or relative to the repository root.

### outputs

`[string]`

### example 1

```powershell
Read-RepositoryText 'docs/drs/index.md'
```
