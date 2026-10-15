---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/Reset-GitHubRepository.ps1.md
    kind: comment-page
    body_sha: "6359fdf4b870"
---

# automation/Catzc.Tooling.Github/Reset-GitHubRepository.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A normal force-push leaves the old commits unreachable but still stored, so a
fetch of a known old SHA keeps resolving until GitHub garbage-collects (days,
or a support ticket). Deleting the repository destroys its object store, so
the old commit hashes stop resolving the instant the repo is gone. This is
the only way to erase a secret together with its remote objects.

Safe by default: it runs the full preflight and, unless armed, changes
nothing and returns a plan. Arm the destructive path by passing -ConfirmRepo
equal to -Repo (and not -DryRun). On any failure after deletion, it throws
with the exact recovery commands — the local clone and the backup bundle are
always intact.

Pushing a whole history takes longer than an ordinary call, so the function
declares its own time limit ([TimeLimit]; tune it under `commands` in
timeouts.yml) and bounds the push and the remote read with it.
```

## comment:2

Section `.PARAMETER NewName` of the comment-based help.

```text
The owner/name to recreate under. Defaults to -Repo (recreate in place). Pass
a different value to delete-and-rename in one step.
```

## comment:3

Section `.PARAMETER Token` of the comment-based help.

```text
The token that must be absent from the pushed history. When set, the
pushed branch is scanned locally, and the new remote must hold only that
branch's commit — the commit names its whole history, so this proves what
the server stored without a mirror clone. A hit or a foreign ref aborts
with a "do not make public" warning.
```

## comment:4

Section `.PARAMETER BackupBundle` of the comment-based help.

```text
A verified `git bundle create --all` backup. The purge refuses to run without
one (checked by Assert-GitHubPurgeReady).
```

## comment:5

Section `.PARAMETER ConfirmRepo` of the comment-based help.

```text
Must equal -Repo to arm the destructive path. Any other value (or absence)
keeps the run a dry run.
```
