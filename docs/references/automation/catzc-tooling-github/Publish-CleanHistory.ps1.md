# automation/Catzc.Tooling.Github/Publish-CleanHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Publishes a verified local history to a brand-new, empty GitHub repository, then independently re-scans the remote to prove what landed is
token-free.

### description

Use this when there is no existing repository to purge — you already hold a clean local tree (for example, freshly rebuilt by
New-SyntheticHistory) and want to push it to a new repo. It refuses to target a name that already exists (that is Reset-GitHubRepository's
job), and after pushing it reads the new remote's refs and proves every one points at the scanned local commit, so the check covers what the
server actually stored without downloading it.

Pushing a whole history takes longer than an ordinary call, so the function declares its own time limit (`[TimeLimit]`; tune it under
`commands` in timeouts.yml) and bounds the push and the remote read with it.

Safe by default: unless armed with -ConfirmRepo equal to -NewRepo (and not -DryRun), it validates and returns a plan without creating or
pushing anything.

### parameter `NewRepo`

The new GitHub repository to create and push to, as owner/name. Must not already exist.

### parameter `Branch`

The local branch to push as the default. Defaults to main.

### parameter `Token`

The token that must be absent from the pushed history. When set, the local branch is scanned before the push, and after it the new remote
must hold only that branch's commit; anything else aborts with a warning.

### parameter `RepositoryPath`

The local clone to push from. Defaults to the repository root.

### parameter `Visibility`

Visibility of the new repo: 'private' (default) or 'public'.

### parameter `ConfirmRepo`

Must equal -NewRepo to arm. Any other value (or absence) keeps the run a dry run.

### parameter `DryRun`

Force a dry run even when -ConfirmRepo matches.

### example 1

```powershell
Publish-CleanHistory -NewRepo 'me/fresh' -Token 'old-name' -ConfirmRepo 'me/fresh'
```
