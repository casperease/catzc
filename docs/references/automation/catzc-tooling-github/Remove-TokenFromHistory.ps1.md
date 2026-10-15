---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/Remove-TokenFromHistory.ps1.md
    kind: reference
    body_sha: e7400351dc9b
    adrs: []
---

# automation/Catzc.Tooling.Github/Remove-TokenFromHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Rewrites every commit, replacing the token in file content (and, unless
-SkipMessages, in commit messages) with a placeholder. This is the
second-choice tool: a filter-repo rewrite leaves the old, un-scrubbed commits
as unreachable objects until GitHub garbage-collects them, and it does NOT
touch the token where it appears in a file *path* (content replacement cannot
rename files). When the token also lives in path names — or you simply want a
guaranteed-clean result with no residual objects — rebuild the history from a
clean tree with New-SyntheticHistory instead.

After scrubbing it re-scans with Test-GitHistoryClean and returns the result,
so a caller can see any path-name residue the content scrub could not reach.

Rewriting a whole history takes longer than an ordinary call, so the
function declares its own time limit ([TimeLimit]; tune it under `commands`
in timeouts.yml) and bounds the filter-repo run with it.
```
