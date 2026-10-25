# pwsh/Catzc.Base.QualityGates/Get-GeneratedWriterDue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Says which generated-file writers are due: the one reading of the inputs and outputs lists in generated-files.yml.

### description

A writer is due when an output named without a wildcard is missing, or when the stamp of every file on disk its inputs match, salted with
the folders its wildcard inputs could write into, differs from the stamp stored after its last run. A pull, a drifted ignored file and a new
folder all change the stamp; a changed output alone never does. A missing or unreadable memo makes every writer due. A writer with neither
list is due whenever git reports anything changed, and HasLists tells the caller it has none. Test-GeneratedFiles -Changed and the import
janitors both ask here, so what a writer depends on is declared once, in generated-files.yml.

### parameter `ChangedPath`

The repository-relative paths that changed, read only for a writer with neither list. Default: git's changed set against HEAD
(Get-GitChangedPath), read once and only when such a writer exists.

### parameter `RepositoryRoot`

The root the inputs are walked and a missing output is looked for under. Default: the repository root.

### parameter `MemoPath`

The memo of the stamps each writer stored after its last run (Save-GeneratedWriterStamp). Default: out/cache/generated-writers.json.

### outputs

`[Catzc.Base.QualityGates.GeneratedWriterDue]` One per writer of generated-files.yml, in declaration order: Name, Due and HasLists.

### example 1

```powershell
Get-GeneratedWriterDue | Where-Object Due
```

## comment:1

Above `$writers = @((Get-Config -Config generated-files).writers.Values)`, written with `#`.

```text
A dirty tree is not a stale output: a writer is due when a literal output is missing, or when the stamp of every file its inputs
match differs from the one stored after its last run (Save-GeneratedWriterStamp). A missing or unreadable memo makes every writer
due. The input files are walked once for all writers; git is read only for a writer that declares no lists.
```
