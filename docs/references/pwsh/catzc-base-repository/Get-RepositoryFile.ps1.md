# pwsh/Catzc.Base.Repository/Get-RepositoryFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the full, normalized path to a file relative to the repository root.

### description

A binding helper (see [ADR-AUTO-PATH-NAMEBYFORM](../../../drs/automation/path-representation.md#rule-adr-auto-path-namebyform)): it takes a
repo-relative path and returns the normalized absolute path to bind against — '.\', '..', and mixed separators collapse, so a leading './'
never leaks into the result. Resolution is against the repository root, not $PWD. Delegates to Resolve-RepoPath so the normalization lives
in one place.

### parameter `Path`

Relative path from the repository root.

### example 1

```powershell
Get-RepositoryFile 'importer.ps1'
```
