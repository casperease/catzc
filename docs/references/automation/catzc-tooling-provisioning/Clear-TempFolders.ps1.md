---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md
    kind: comment-page
    body_sha: bbf8190a3836
---

# automation/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$removed = 0`.

```text
Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
recurses each subtree. A file or directory held open by a running process throws and is skipped.
In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
```
