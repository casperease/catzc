# pwsh/Base.Files/Get-GitCurrentBranch.ps1

The command that answers which branch the checkout is on, read from the HEAD file in-process.

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
