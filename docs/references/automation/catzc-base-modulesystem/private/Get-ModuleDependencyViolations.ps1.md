---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md
    kind: comment-page
    body_sha: db4c688fc7bf
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$resolveAllowed = {`.

```text
Resolves a source module to { Constrained; Allowed }. A source with no constraint (not a declared
module and not a group member) is skipped by callers regardless of its (empty) Allowed set.
```

## comment:5

Above `$typeEdges = Get-CSharpTypeDependency`.

```text
Same allow-list, applied to cross-module C# type references (one combined types assembly, so the
compiler permits them — see Get-CSharpTypeDependency).
```
