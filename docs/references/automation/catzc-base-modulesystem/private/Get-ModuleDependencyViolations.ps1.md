---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md
    kind: comment-page
    body_sha: "30c3b3fdb327"
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Compares the actual module-to-module edges against the declared allow-list
(Get-ModuleDependencyConfig + Get-ModuleGroupConfig). Edges come from TWO sources, both governed
by the same allow-list: PowerShell function calls (Get-ModuleDependency) and cross-module C# type
references (Get-CSharpTypeDependency).

Allow-list resolution is GROUP-AWARE. A source module is constrained if it is a declared module
(top-level 'modules' key) or a member of a declared group; otherwise it is unconstrained and skipped.
Its allowed target set is:

- if a declared module: each name in its declared list, with group names expanded to their members
  (so pinning a group permits an edge to any member; naming a module is the tight form), plus plain
  module names as-is.
- if a group member: the members listed for it in that group's internal DAG (the layering contract).

An actual edge whose target is not in the resolved allowed set is an UndeclaredDependency (function)
or UndeclaredTypeDependency (C# type). A declared module — or a group member — that does not exist on
disk is an UnknownModule (typo catch). Group names themselves are concepts and are not checked on disk.

Returns one message per violation, each led by its kind ('[UndeclaredDependency] A -> C ...'); empty when
the code conforms. This is the query behind the Test-ModuleDependency quality gate.
```

## comment:2

Above `$resolveAllowed = {`.

```text
Resolves a source module to { Constrained; Allowed }. A source with no constraint (not a declared
module and not a group member) is skipped by callers regardless of its (empty) Allowed set.
```

## comment:3

Above `$typeEdges = Get-CSharpTypeDependency`.

```text
Same allow-list, applied to cross-module C# type references (one combined types assembly, so the
compiler permits them — see Get-CSharpTypeDependency).
```

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
