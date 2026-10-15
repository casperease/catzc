---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependency.Tests.ps1.md
    kind: test-asset
    body_sha: fd504c01a76d
---

# automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$violations = @($edges | Where-Object { $_.CallCount -le 0 })`.

```text
One Should over the violating set — a Should per edge pays Pester's per-assertion cost
times the whole discovered graph.
```
