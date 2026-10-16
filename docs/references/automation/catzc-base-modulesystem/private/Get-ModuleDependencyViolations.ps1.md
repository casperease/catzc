---
catzc:
  immutable:
    with_body_sha: eaa67b4c30f1
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/private
    name: get-module-dependency-violations-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$resolveAllowed = {`, written with `#`.

```text
Resolves a source module to { Constrained; Allowed }. A source with no constraint (not a declared
module and not a group member) is skipped by callers regardless of its (empty) Allowed set.
```

## comment:2

Above `$typeEdges = Get-CSharpTypeDependency`, written with `#`.

```text
Same allow-list, applied to cross-module C# type references (one combined types assembly, so the
compiler permits them — see Get-CSharpTypeDependency).
```
