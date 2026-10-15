---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
    kind: comment-page
    body_sha: "492f9dc9878f"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every module's native types compile into ONE assembly (see Import-CSharpTypes), so the C# compiler no
longer structurally forbids a type in one module referencing a type in another — including a layer
inversion or a cycle. This scanner recovers that enforcement for the dependency graph: it reads each
module's types/*.cs and reports an edge From -> To whenever a file references another module's namespace
by fully-qualified name (e.g. Catzc.Azure.Templates referencing Catzc.Base.Objects.DictionaryRecord).

Detection, made precise so Catzc.Azure is not confused with Catzc.Azure.Templates:

  1. The known module names (Get-AutomationModules) are also the known namespaces.
  2. Comments, string/char literals, and the file's own file-scoped namespace declaration are stripped
     first, so a token in a comment — or the module's own "namespace <module>;" line — never becomes an edge.
  3. Every dotted identifier is mapped to its LONGEST known-module-name prefix
     (Catzc.Azure.Templates.BicepTemplate -> Catzc.Azure.Templates; Catzc.Azure.SubCtx -> Catzc.Azure;
     System.String -> none). Self-references (target == the file's own module) and BCL tokens are dropped.

These edges are folded into Get-ModuleDependencyViolations beside the function-call edges, so the same
acyclic allow-list (configs/dependencies.yml, asserted by the L2 tests) governs C# type layering.

Reads the per-module types/*.cs sources, which exist only in the source tree, so it stops with a named
error in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') | S...`.

```text
[System.IO] (sorted) instead of Get-ChildItem/Get-Content — ~20ms-per-call cmdlet overhead the raw
.NET enumeration + read avoid
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:3

Above `$code = [System.IO.File]::ReadAllText($cs)`.

```text
Strip block comments, line comments, then double- and single-quoted literals, so only real code
tokens are scanned. A heuristic, but reliable here: references are FQN with no 'using' aliasing.
```

## comment:4

Above `$code = [regex]::Replace($code, '(?m)^\s*namespace\s+[A-Za-z_][A-Za-z0-9_.]*\...`.

```text
Drop the file's own file-scoped namespace declaration ("namespace <module>;"). It names THIS file's
own module, never a cross-module reference, and its token would otherwise mis-map to a shorter
known-module prefix: 'namespace Catzc.Azure.Templates;' has no 'Catzc.Azure.Templates.' continuation,
so it would resolve to the parent module Catzc.Azure and fabricate a false Templates -> Azure edge.
```
