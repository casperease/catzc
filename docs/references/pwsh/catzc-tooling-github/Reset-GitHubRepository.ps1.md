# pwsh/Catzc.Tooling.Github/Reset-GitHubRepository.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Hard-purges a GitHub repository — deletes it, recreates it (optionally under a new name), pushes the local history, and verifies the result
is token-free.

### description

A normal force-push leaves the old commits unreachable but still stored, so a fetch of a known old SHA keeps resolving until GitHub
garbage-collects (days, or a support ticket). Deleting the repository destroys its object store, so the old commit hashes stop resolving the
instant the repo is gone. This is the only way to erase a secret together with its remote objects.

Safe by default: it runs the full preflight and, unless armed, changes nothing and returns a plan. Arm the destructive path by passing
-ConfirmRepo equal to -Repo (and not -DryRun). On any failure after deletion, it throws with the exact recovery commands — the local clone
and the backup bundle are always intact.

Pushing a whole history takes longer than an ordinary call, so the function declares its own time limit (`[TimeLimit]`; tune it under
`commands` in timeouts.yml) and bounds the push and the remote read with it.

### parameter `Repo`

The GitHub repository to delete, as owner/name.

### parameter `NewName`

The owner/name to recreate under. Defaults to -Repo (recreate in place). Pass a different value to delete-and-rename in one step.

### parameter `Branch`

The local branch to push as the new default. Defaults to main.

### parameter `Token`

The token that must be absent from the pushed history. When set, the pushed branch is scanned locally, and the new remote must hold only
that branch's commit — the commit names its whole history, so this proves what the server stored without a mirror clone. A hit or a foreign
ref aborts with a "do not make public" warning.

### parameter `BackupBundle`

A verified `git bundle create --all` backup. The purge refuses to run without one (checked by Assert-GitHubPurgeReady).

### parameter `RepositoryPath`

The local clone to push from. Defaults to the repository root.

### parameter `Visibility`

Visibility of the recreated repo: 'private' (default) or 'public'.

### parameter `AllowForks`

Proceed even if the repo has forks (they defeat the purge). Off by default.

### parameter `ConfirmRepo`

Must equal -Repo to arm the destructive path. Any other value (or absence) keeps the run a dry run.

### parameter `DryRun`

Force a dry run even when -ConfirmRepo matches.

### example 1

```powershell
Reset-GitHubRepository -Repo 'me/project' -BackupBundle $bundle
# Dry run: preflight only, nothing changes.
```

### example 2

```powershell
Reset-GitHubRepository -Repo 'me/old' -NewName 'me/new' -Token 'old-name' -BackupBundle $bundle -ConfirmRepo 'me/old'
# Armed: delete me/old, create me/new, push, verify token-free.
```
