# automation/Catzc.Base.Repository/Get-RepositoryRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repository root path.

### description

Returns the value of $env:RepositoryRoot set by importer.ps1.

### example 1

```powershell
Get-RepositoryRoot
```
