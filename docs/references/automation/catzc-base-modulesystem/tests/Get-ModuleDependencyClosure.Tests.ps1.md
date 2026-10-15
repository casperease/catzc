---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependencyClosure.Tests.ps1.md
    kind: test-asset
    body_sha: f980be321af8
---

# automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ModuleDependencyClosure' -Tag 'L0', 'logic' {`.

```text
Get-ModuleDependencyClosure is private (breadth-first over the declared dependency map). Tested via InModuleScope with
the map mocked to a small fixture graph, so the breadth-first/closure logic is exercised independent of the real graph.
```
