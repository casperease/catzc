# pwsh/Base.Files/Get-GitCurrentBranch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the current git branch name (or 'HEAD' when detached).

### description

The branch HEAD is on in the checkout at Get-RepositoryRoot, read from its HEAD file in-process (`[Catzc.Base.Git.GitRefs]`) — what
`git rev-parse --abbrev-ref HEAD` answers, without starting git.

### example 1

```powershell
Get-GitCurrentBranch
```
