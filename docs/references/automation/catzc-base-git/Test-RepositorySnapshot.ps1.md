---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/Test-RepositorySnapshot.ps1.md
    kind: comment-page
    body_sha: "6d7f89a53e0f"
    adrs: []
---

# automation/Catzc.Base.Git/Test-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one reader of the snapshot provenance marker (.git/catzc-snapshot.json) that New-RepositorySnapshot
writes. A snapshot is a disposable clone a test run executes in: Remove-RepositorySnapshot deletes only a
snapshot, and the importer's generated-file commit never commits inside one.
```
