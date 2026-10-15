---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/Assert-GitHubPurgeReady.ps1.md
    kind: comment-page
    body_sha: "49c29f7ead61"
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Github/Assert-GitHubPurgeReady.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A hard purge (delete the repo, recreate it, push a clean history) is
irreversible and only actually erases the old objects when a set of
conditions all hold. This checks them up front so the destructive step
never runs against a repo it cannot safely purge:

  * gh is installed and authenticated;
  * the token carries the delete_repo scope (needed to delete a repo);
  * you own the repo and it is not itself a fork;
  * the repo has no forks — a fork keeps the old objects alive elsewhere,
    so deleting this repo would not purge them;
  * the local origin points at the repo you are about to delete;
  * a backup bundle exists and passes git bundle verify.

Throws a specific, actionable error for whichever check fails first.
```

## comment:2

Section `.PARAMETER BackupBundle` of the comment-based help.

```text
Path to a `git bundle create --all` backup of the current history. The
purge refuses to proceed without one that verifies.
```

## comment:3

Section `.PARAMETER AllowForks` of the comment-based help.

```text
Proceed even if the repo has forks. Off by default because a fork defeats
the purge (the old objects survive in the fork).
```
