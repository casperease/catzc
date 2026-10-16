---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Get-ModuleDependencyClosure.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: get-module-dependency-closure-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ac19161945f2
---

# automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ModuleDependencyClosure' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ModuleDependencyClosure is private (breadth-first over the declared dependency map). Tested via InModuleScope with
the map mocked to a small fixture graph, so the breadth-first/closure logic is exercised independent of the real graph.
```
