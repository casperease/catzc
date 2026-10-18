# automation/Catzc.Base.Git/Test-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns true when a repository is a test-run snapshot made by New-RepositorySnapshot.

### description

The one reader of the snapshot provenance marker (.git/catzc-snapshot.json) that New-RepositorySnapshot writes. A snapshot is a disposable
clone a test run executes in: Remove-RepositorySnapshot deletes only a snapshot, and the importer's generated-file commit never commits
inside one.

### parameter Path

The repository root to check. Default: the loaded repository root.

### outputs

`[bool]`

### example 1

```powershell
Test-RepositorySnapshot
```

### example 2

```powershell
Test-RepositorySnapshot 'C:\Temp\catzc-run-0f3a'
```
