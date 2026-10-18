# pwsh/Catzc.Tooling.Github/Assert-GitHubPurgeReady.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts every precondition for a hard-purge of a GitHub repository is met, throwing on the first gap. Nothing here mutates anything.

### description

A hard purge (delete the repo, recreate it, push a clean history) is irreversible and only actually erases the old objects when a set of
conditions all hold. This checks them up front so the destructive step never runs against a repo it cannot safely purge:

- gh is installed and authenticated;
- the token carries the delete_repo scope (needed to delete a repo);
- you own the repo and it is not itself a fork;
- the repo has no forks — a fork keeps the old objects alive elsewhere, so deleting this repo would not purge them;
- the local origin points at the repo you are about to delete;
- a backup bundle exists and passes git bundle verify.

Throws a specific, actionable error for whichever check fails first.

### parameter `Repo`

The GitHub repository as owner/name (e.g. 'contoso/hello-world').

### parameter `BackupBundle`

Path to a `git bundle create --all` backup of the current history. The purge refuses to proceed without one that verifies.

### parameter `RepositoryPath`

The local clone whose origin is checked. Defaults to the repository root.

### parameter `AllowForks`

Proceed even if the repo has forks. Off by default because a fork defeats the purge (the old objects survive in the fork).

### example 1

```powershell
Assert-GitHubPurgeReady -Repo 'contoso/hello-world' -BackupBundle $bundle
```
