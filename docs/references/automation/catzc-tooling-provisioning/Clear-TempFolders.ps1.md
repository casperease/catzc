---
catzc:
  immutable:
    with_body_sha: f5aa324dbea0
    path: docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: clear-temp-folders-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$removed = 0`, written with `#`.

```text
Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
recurses each subtree. A file or directory held open by a running process throws and is skipped.
In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
```
