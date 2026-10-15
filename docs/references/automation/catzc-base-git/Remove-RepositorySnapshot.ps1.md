# docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md

`automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes the snapshot folder in one [System.IO.Directory]::Delete call, not item by item. It refuses any
folder that does not carry New-RepositorySnapshot's provenance marker (.git/catzc-snapshot.json), so a
wrong path can never delete a real checkout. Read-only files (git writes some) are made writable and the
delete is retried once. A path that no longer exists is a no-op.
```
