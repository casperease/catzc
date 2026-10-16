---
catzc:
  immutable:
    with_body_sha: ff786f7c9b84
    path: docs/references/automation/catzc-base-qualitygates/tests/types/GuidsConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests/types
    name: guids-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/types/GuidsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:zeroGuid = "$([guid]::Empty)"`, written with `#`.

```text
The all-zeros GUID is itself denied (it must not appear as a tracked literal), so build it at
runtime — the same discipline Test-ManagedGuids enforces on every other file.
```
