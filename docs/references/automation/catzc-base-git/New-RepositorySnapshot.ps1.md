---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md
    folder: docs/references/automation/catzc-base-git
    name: new-repository-snapshot-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: be6c7812933e
---

# automation/Catzc.Base.Git/New-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$marker = [ordered]@{`, written with `#`.

```text
The provenance marker goes in first, so the cleanup below (and any later Remove-RepositorySnapshot)
recognises even a half-built snapshot as one it may delete.
```

## comment:2

Above `$statusCommand = 'git --no-optional-locks -C "{0}" -c core.quotepath=off...`, written with `#`.

```text
The gate: the snapshot's status must equal the source's. --no-optional-locks keeps the source's index
untouched (a plain status may rewrite it, racing other git commands on the source).
```

## comment:3

Above `$modified = 0`, written with `#`.

```text
Status counts relative to HEAD: '1'/'2'/'u' lines are changed entries (deleted when either side of
the XY code is D), '?' lines are untracked files.
```
