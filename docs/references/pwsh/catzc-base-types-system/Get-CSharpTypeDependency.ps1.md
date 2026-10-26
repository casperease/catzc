# pwsh/Base.TypesSystem/Get-CSharpTypeDependency.ps1

The scanner that finds which modules reference which: it reads each module's `types/*.cs` and compiles the module-to-module edges from the
cross-module type references.

## help

### synopsis

Compiles module-to-module edges from cross-module C# type references in `types/*.cs`.

### description

Every module's native types compile into ONE assembly (see Import-CSharpTypes), so the C# compiler no longer structurally forbids a type in
one module referencing a type in another — including a layer inversion or a cycle. This scanner recovers that enforcement for the dependency
graph: it reads each module's `types/*.cs` and reports an edge From -> To whenever a file references another module's namespace by
fully-qualified name (e.g. Catzc.Azure.Templates referencing Catzc.Base.Objects.DictionaryRecord).

Detection, made precise so Catzc.Azure is not confused with Catzc.Azure.Templates:

1. The known module names (Get-CatzcModule -TrackType modules) are also the known namespaces.
2. Comments, string/char literals, and the file's own file-scoped namespace declaration are stripped first, so a token in a comment — or the
   module's own "namespace `<module>`;" line — never becomes an edge.
3. Every dotted identifier is mapped to its LONGEST known-module-name prefix (Catzc.Azure.Templates.BicepTemplate -> Catzc.Azure.Templates;
   Catzc.Azure.SubCtx -> Catzc.Azure; System.String -> none). Self-references (target == the file's own module) and BCL tokens are dropped.

These edges are folded into Get-ModuleDependencyViolations beside the function-call edges, so the same acyclic allow-list
(configs/dependencies.yml, asserted by the L2 tests) governs C# type layering.

Reads each module's C# type files (`types/*.cs`), which exist only in the source tree, so it stops with a named error in build mode
(Assert-SourceTree, [DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `ModulesRoot`

Path to the modules folder. Defaults to the loaded code root (Get-CatzcModulesRoot).

### example 1

```powershell
Get-CSharpTypeDependency
```

### example 2

```powershell
Get-CSharpTypeDependency | Where-Object { $_.From -eq 'Catzc.Azure.Templates' }
```

## Reading the files

A module's `types/*.cs` are listed through the bounded folder walker (`PathSet`, configured by folder-walk) instead of `Get-ChildItem`, and
read with `[System.IO]` instead of `Get-Content`: the cmdlets cost about 20 ms per call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).

## What counts as a reference

Block comments, line comments, then double- and single-quoted literals are stripped, so only real code tokens are scanned. That is a
heuristic, but a reliable one here: references are fully qualified names with no `using` aliasing. Only a token that starts with a module
name's first segment can name a module, so the scan leaves every other dotted name unmatched.

The file's own file-scoped namespace declaration (`namespace <module>;`) is dropped. It names the file's own module, never a cross-module
reference, and its token would otherwise map to a shorter known-module prefix: `namespace Catzc.Azure.Templates;` has no
`Catzc.Azure.Templates.` continuation, so it would resolve to the parent module `Catzc.Azure` and fabricate a false Templates to Azure edge.
