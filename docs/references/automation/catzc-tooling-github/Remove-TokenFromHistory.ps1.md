# automation/Catzc.Tooling.Github/Remove-TokenFromHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Scrubs a token from a git history's blob content and commit messages with
git-filter-repo. The fallback route — prefer New-SyntheticHistory.

### description

Rewrites every commit, replacing the token in file content (and, unless
-SkipMessages, in commit messages) with a placeholder. This is the
second-choice tool: a filter-repo rewrite leaves the old, un-scrubbed commits
as unreachable objects until GitHub garbage-collects them, and it does NOT
touch the token where it appears in a file _path_ (content replacement cannot
rename files). When the token also lives in path names — or you simply want a
guaranteed-clean result with no residual objects — rebuild the history from a
clean tree with New-SyntheticHistory instead.

After scrubbing it re-scans with Test-GitHistoryClean and returns the result,
so a caller can see any path-name residue the content scrub could not reach.

Rewriting a whole history takes longer than an ordinary call, so the
function declares its own time limit (`[TimeLimit]`; tune it under `commands`
in timeouts.yml) and bounds the filter-repo run with it.

### parameter Token

The literal token to replace across the history.

### parameter ReplaceWith

The placeholder to substitute. Defaults to '`***REMOVED***`'.

### parameter SkipMessages

Only scrub blob content, leaving commit messages untouched.

### parameter RepositoryPath

The repository to rewrite. Defaults to the repository root.

### parameter DryRun

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
