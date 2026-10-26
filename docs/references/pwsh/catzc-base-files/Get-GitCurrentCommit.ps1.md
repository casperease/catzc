# pwsh/Base.Files/Get-GitCurrentCommit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the current git commit hash (full 40-char SHA).

### description

The commit HEAD names in the checkout at Get-RepositoryRoot, read from its ref files in-process (`[Catzc.Base.Git.GitRefs]`) — what
`git rev-parse HEAD` answers, without starting git.

### example 1

```powershell
Get-GitCurrentCommit
```
