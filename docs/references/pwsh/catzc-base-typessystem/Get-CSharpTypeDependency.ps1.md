# pwsh/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
(Assert-SourceTree, [ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

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

## comment:1

Above `foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') |...`, written with `#`.

```text
[System.IO] (sorted) instead of Get-ChildItem/Get-Content — ~20ms-per-call cmdlet overhead the raw
.NET enumeration + read avoid
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:2

Above `$code = [System.IO.File]::ReadAllText($cs)`, written with `#`.

```text
Strip block comments, line comments, then double- and single-quoted literals, so only real code
tokens are scanned. A heuristic, but reliable here: references are FQN with no 'using' aliasing.
```

## comment:3

Above `$code = [regex]::Replace($code,...`, written with `#`.

```text
Drop the file's own file-scoped namespace declaration ("namespace <module>;"). It names THIS file's
own module, never a cross-module reference, and its token would otherwise mis-map to a shorter
known-module prefix: 'namespace Catzc.Azure.Templates;' has no 'Catzc.Azure.Templates.' continuation,
so it would resolve to the parent module Catzc.Azure and fabricate a false Templates -> Azure edge.
```
