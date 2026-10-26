# pwsh/Base.ModuleSystem/types/FunctionCallCollector.cs

Collects, per top-level function of a parsed `.ps1` file, the commands its body calls and the names of the functions nested inside it. It is
the one AST walk `Test-FunctionDependency` needs.

## What counts

A top-level function is a function definition that is a statement directly in one of the file's named blocks. A function defined inside
another is never its own entry, only a name in its outer function's `NestedFunctionNames`. The body walk descends into nested script blocks
and nested function bodies, so a call anywhere in the function is attributed to it. Commands without a static name, such as `& $script`, are
skipped. Each call is a [FunctionCall](FunctionCall.cs.md), and results are in document order.

## Why it is a C# type

Walking in C# replaces two PowerShell scriptblock-predicate `FindAll` passes per function, whose per-node predicate invocation dominated the
check's run time.
