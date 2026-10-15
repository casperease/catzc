---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md
    kind: comment-page
    body_sha: ac39ac529abe
---

# automation/Catzc.Base.QualityGates/private/Get-LinkScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies
untracked in the working folder. With -Path, the given files and the files under the given folders, from the
filesystem. Either way a file the content tools leave as written (Get-ContentExemptPath: vendored, generated,
fixture, or contract asset) is never aligned. No list of its own: a new class is declared in the .gitattributes
source.
```

## comment:2

Above `$isDiskRoot = {`.

```text
Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
```

## comment:3

Above `$isDiskRoot = {`.

```text
Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
```
