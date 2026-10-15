---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-FunctionDependency.Tests.ps1.md
    kind: test-asset
    body_sha: "5037221dd250"
---

# automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$violations = foreach ($dependency in $dependencies) {`.

```text
One Should over the violating set — a Should per edge costs ~0.5ms × ~1000 cross-module edges,
which alone breaches the L0 time limit.
```
