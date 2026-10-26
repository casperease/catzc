# pwsh/Base.ModuleSystem/private/Get-ModuleDependencyViolations.ps1

The query behind the `Test-ModuleDependency` gate: it compares the real module edges, function calls and C# type references, against the
declared allow-list and returns one message per violation.

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

## Resolving a source

`$resolveAllowed` resolves a source module to `{ Constrained; Allowed }`. A source with no constraint, neither a declared module nor a group
member, is skipped by its callers whatever its empty `Allowed` set says.

## Type references

The same allow-list applies to cross-module C# type references. One combined types assembly means the compiler permits them, so this check is
what keeps them inside the declared graph (see `Get-CSharpTypeDependency`).
