---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Sync-GeneratedFile.Tests.ps1.md
    kind: test-asset
    body_sha: "4d6ff1dfbc6a"
---

# automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Sync-GeneratedFile | Should -Not -BeNullOrEmpty`.

```text
The commit is pathspec-limited inside Invoke-GitCommit, so a dirty (or staged) tree never holds
the stamp commit back and never leaks into it.
```
