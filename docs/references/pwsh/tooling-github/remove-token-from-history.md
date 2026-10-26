# pwsh/Tooling.Github/Remove-TokenFromHistory.ps1

The fallback scrub: it rewrites a history with git-filter-repo, replacing the token in file content and commit messages. It leaves the old
commits as unreachable objects and cannot reach a token in a path name, so it ends with a `Test-GitHistoryClean` scan and returns that
result; `New-SyntheticHistory` is the first choice.

## help

### synopsis

Scrubs a token from a git history's blob content and commit messages with git-filter-repo, the fallback route to New-SyntheticHistory.

### description

Rewrites every commit, replacing the token in file content (and, unless -SkipMessages, in commit messages) with a placeholder. This is the
second-choice tool: a filter-repo rewrite leaves the old, un-scrubbed commits as unreachable objects until GitHub garbage-collects them, and
it does NOT touch the token where it appears in a file _path_ (content replacement cannot rename files). When the token also lives in path
names — or you simply want a guaranteed-clean result with no residual objects — rebuild the history from a clean tree with
New-SyntheticHistory instead.

After scrubbing it re-scans with Test-GitHistoryClean and returns the result, so a caller can see any path-name residue the content scrub
could not reach.

Rewriting a whole history takes longer than an ordinary call, so the function declares its own time limit (`[TimeLimit]`; tune it under
`commands` in timeouts.yml) and bounds the filter-repo run with it.

### parameter `Token`

The literal token to replace across the history.

### parameter `ReplaceWith`

The placeholder to substitute. Defaults to '`***REMOVED***`'.

### parameter `SkipMessages`

Only scrub blob content, leaving commit messages untouched.

### parameter `RepositoryPath`

The repository to rewrite. Defaults to the repository root.

### parameter `DryRun`

Return the planned command and replacement expression without rewriting.

### example 1

```powershell
Remove-TokenFromHistory -Token 'old-name' -DryRun
```

### example 2

```powershell
$result = Remove-TokenFromHistory -Token 'secret'
if (-not $result.Clean) { $result.Paths }   # path-name residue the scrub cannot reach
```
