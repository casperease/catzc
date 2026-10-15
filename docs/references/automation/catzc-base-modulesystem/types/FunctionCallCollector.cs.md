# docs/references/automation/catzc-base-modulesystem/types/FunctionCallCollector.cs.md

`automation/Catzc.Base.ModuleSystem/types/FunctionCallCollector.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Collects, per top-level function of a parsed .ps1 file, the commands its body calls and the names of the
functions nested inside it — the one AST walk Test-FunctionDependency needs. A top-level function is a
FunctionDefinitionAst that is a statement directly in one of the file's named blocks; a function defined
inside another is never its own entry, only a name in its outer function's NestedFunctionNames. The body
walk descends into nested script blocks and nested function bodies, so a call anywhere in the function is
attributed to it. Commands without a static name (`& $script`) are skipped. Results are in document order.

Walking in C# replaces two PowerShell-scriptblock-predicate FindAll passes per function, whose per-node
predicate invocation dominated the check's run time.
```
