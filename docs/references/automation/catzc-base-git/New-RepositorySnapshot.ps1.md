---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md
    kind: comment-page
    body_sha: bb2c873d0964
---

# automation/Catzc.Base.Git/New-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$marker = [ordered]@{`.

```text
The provenance marker goes in first, so the cleanup below (and any later Remove-RepositorySnapshot)
recognises even a half-built snapshot as one it may delete.
```

## comment:7

Above `$statusCommand = 'git --no-optional-locks -C "{0}" -c core.quotepath=off...`.

```text
The gate: the snapshot's status must equal the source's. --no-optional-locks keeps the source's index
untouched (a plain status may rewrite it, racing other git commands on the source).
```

## comment:8

Above `$modified = 0`.

```text
Status counts relative to HEAD: '1'/'2'/'u' lines are changed entries (deleted when either side of
the XY code is D), '?' lines are untracked files.
```
