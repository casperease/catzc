---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/Publish-CleanHistory.ps1.md
    kind: comment-page
    body_sha: "83e8b2100296"
    adrs: []
---

# automation/Catzc.Tooling.Github/Publish-CleanHistory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Use this when there is no existing repository to purge — you already hold a
clean local tree (for example, freshly rebuilt by New-SyntheticHistory) and
want to push it to a new repo. It refuses to target a name that already
exists (that is Reset-GitHubRepository's job), and after pushing it reads
the new remote's refs and proves every one points at the scanned local
commit, so the check covers what the server actually stored without
downloading it.

Pushing a whole history takes longer than an ordinary call, so the function
declares its own time limit ([TimeLimit]; tune it under `commands` in
timeouts.yml) and bounds the push and the remote read with it.

Safe by default: unless armed with -ConfirmRepo equal to -NewRepo (and not
-DryRun), it validates and returns a plan without creating or pushing
anything.
```

## comment:2

Section `.PARAMETER NewRepo` of the comment-based help.

```text
The new GitHub repository to create and push to, as owner/name. Must not
already exist.
```

## comment:3

Section `.PARAMETER Token` of the comment-based help.

```text
The token that must be absent from the pushed history. When set, the local
branch is scanned before the push, and after it the new remote must hold
only that branch's commit; anything else aborts with a warning.
```

## comment:4

Section `.PARAMETER ConfirmRepo` of the comment-based help.

```text
Must equal -NewRepo to arm. Any other value (or absence) keeps the run a dry
run.
```
