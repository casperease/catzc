# pwsh/Catzc.Base.QualityGates/Get-GeneratedWriterDue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Says which generated-file writers a changed set makes due: the one reading of the inputs and outputs lists in generated-files.yml.

### description

A writer is due when a path git reports changed matches one of its inputs or outputs globs, or when an output named without a wildcard is
missing. A writer with neither list is due whenever anything changed, and HasLists tells the caller it has none (the import janitor runs
such a writer as it always has). Test-GeneratedFiles -Changed and the import janitors both ask here, so what a writer depends on is declared
once, in generated-files.yml.

### parameter `ChangedPath`

The repository-relative paths that changed. Default: git's changed set against HEAD (Get-GitChangedPath).

### parameter `RepositoryRoot`

The root a missing output is looked for under. Default: the repository root.

### outputs

`[pscustomobject]` @{ Name; Due; HasLists } per writer of generated-files.yml, in declaration order.

### example 1

```powershell
Get-GeneratedWriterDue | Where-Object Due
```
