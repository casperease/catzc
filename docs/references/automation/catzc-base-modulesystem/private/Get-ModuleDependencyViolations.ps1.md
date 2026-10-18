---
catzc:
  immutable:
    with_body_sha: eaa67b4c30f1
    repo_status: locked
    path: docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyViolations.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/private
    name: get-module-dependency-violations-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Collects conformance violations of the real code against the declared dependency graph.

### description

Compares the actual module-to-module edges against the declared allow-list (Get-ModuleDependencyConfig + Get-ModuleGroupConfig). Edges come
from TWO sources, both governed by the same allow-list: PowerShell function calls (Get-ModuleDependency) and cross-module C# type references
(Get-CSharpTypeDependency).

Allow-list resolution is GROUP-AWARE. A source module is constrained if it is a declared module (top-level 'modules' key) or a member of a
declared group; otherwise it is unconstrained and skipped. Its allowed target set is:

- if a declared module: each name in its declared list, with group names expanded to their members (so pinning a group permits an edge to
  any member; naming a module is the tight form), plus plain module names as-is.
- if a group member: the members listed for it in that group's internal DAG (the layering contract).

An actual edge whose target is not in the resolved allowed set is an UndeclaredDependency (function) or UndeclaredTypeDependency (C# type).
A declared module — or a group member — that does not exist on disk is an UnknownModule (typo catch). Group names themselves are concepts
and are not checked on disk.

Returns one message per violation, each led by its kind ('`[UndeclaredDependency]` A -> C ...'); empty when the code conforms. This is the
query behind the Test-ModuleDependency quality gate.

### outputs

`[string[]]` One message per violation.

### example 1

```powershell
Get-ModuleDependencyViolations
```

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
