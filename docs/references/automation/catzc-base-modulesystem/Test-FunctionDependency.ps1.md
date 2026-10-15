---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
    kind: comment-page
    body_sha: "039322106972"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-PESTER#9
    links: []
---

# automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Parses every .ps1 file (excluding tests) under the automation root using AST,
then checks each function call against: (a) the definitions map of automation
functions, and (b) Get-Command for built-ins, vendor modules, and other loaded
commands.

An issue is an unresolved call ('<caller> -> <missing> (<module>/<file>:<line>)') or two modules defining the
same public (module-root) function name — exported names must be globally unique, mirroring the importer's
Assert-UniqueModuleFunctionName. Duplicate private names across modules are allowed (privates are
module-scoped and not exported).

A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
through Write-QualityGateReport, which writes out/test-function-dependency/, prints every issue, and throws
once listing them all; -PassThru returns the result instead.

Must run post-import so Get-Command covers all loaded modules. Reads the per-function source files, which
exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `$parsed = [System.Collections.Generic.List[object]]::new()`.

```text
Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
overhead, [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); the definition map
and the call-resolution walk reuse these ASTs, so each file is read and parsed a single time. The walk itself is
[Catzc.Base.ModuleSystem.FunctionCallCollector] — one C# pass per function, not scriptblock-predicate FindAll calls.
```

## comment:3

Above `$rel = $path.Substring($moduleDir.Length)`.

```text
Match assets/private against the MODULE-RELATIVE path, not the absolute one: an absolute temp/CI
path can itself sit under a '/private/' or '/assets/' segment (e.g. macOS $TestDrive resolves to
/private/var/folders/...), which would otherwise misclassify every fixture file as private.
```

## comment:4

Above `$existing = $definitions[$fn.Name]`.

```text
Two PUBLIC (module-root) definitions of one name is a real collision — the module imported
last silently shadows the other (defense-in-depth; the importer's Assert-UniqueModuleFunctionName
already blocks this at load). Duplicate PRIVATE names across modules are legal (privates are
module-scoped, not exported): keep first-wins, but prefer a public definition over a private one
for resolution and reporting.
```

## comment:5

Above `$isLoadedCommand = [System.Collections.Generic.Dictionary[string,...`.

```text
Check each collected call → flag any that resolve to nothing. Get-Command runs once per distinct external name
in this run (a whole-session Get-Command snapshot measures slower than the few dozen lookups the memo leaves).
```
