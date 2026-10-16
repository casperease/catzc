---
catzc:
  immutable:
    with_body_sha: f7120001802a
    repo_status: locked
    path: docs/references/automation/catzc-base-modulesystem/tests/Sync-GeneratedFile.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: sync-generated-file-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Sync-GeneratedFile | Should -Not -BeNullOrEmpty` (occurrence 5), written with `#`.

```text
The commit is pathspec-limited inside Invoke-GitCommit, so a dirty (or staged) tree never holds
the stamp commit back and never leaks into it.
```
