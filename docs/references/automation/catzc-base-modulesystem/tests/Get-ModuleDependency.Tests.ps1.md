---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependency.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: get-module-dependency-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "63348807e13d"
---

# automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$violations = @($edges | Where-Object { $_.CallCount -le 0 })`, written with `#`.

```text
One Should over the violating set — a Should per edge pays Pester's per-assertion cost
times the whole discovered graph.
```
