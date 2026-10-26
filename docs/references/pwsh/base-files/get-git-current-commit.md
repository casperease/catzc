# pwsh/Base.Files/Get-GitCurrentCommit.ps1

The command that answers which commit the checkout is on, read from the ref files in-process.

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
