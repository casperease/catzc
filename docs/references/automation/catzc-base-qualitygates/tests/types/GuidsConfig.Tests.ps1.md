---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/GuidsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: c432be394227
---

# automation/Catzc.Base.QualityGates/tests/types/GuidsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:zeroGuid = "$([guid]::Empty)"`.

```text
The all-zeros GUID is itself denied (it must not appear as a tracked literal), so build it at
runtime — the same discipline Test-ManagedGuids enforces on every other file.
```
