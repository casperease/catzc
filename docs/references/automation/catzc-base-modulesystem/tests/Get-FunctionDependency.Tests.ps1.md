---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-FunctionDependency.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "170ee801ba9c"
---

# automation/Catzc.Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$violations = foreach ($dependency in $dependencies) {`, written with `#`.

```text
One Should over the violating set — a Should per edge costs ~0.5ms × ~1000 cross-module edges,
which alone breaches the L0 time limit.
```
