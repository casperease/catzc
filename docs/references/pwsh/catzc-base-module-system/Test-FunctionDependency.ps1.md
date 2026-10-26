# pwsh/Base.ModuleSystem/Test-FunctionDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The function dependency quality gate: every function-to-function call resolves to a defined command.

### description

Parses every .ps1 file (excluding tests) under the modules root using AST, then checks each function call against: (a) the definitions map
of module functions, and (b) Get-Command for built-ins, vendor modules, and other loaded commands.

An issue is an unresolved call ('`<caller>` -> `<missing>` (`<module>/<file>:<line>`)') or two modules defining the same public
(module-root) function name — exported names must be globally unique, mirroring the importer's Assert-UniqueModuleFunctionName. Duplicate
private names across modules are allowed (privates are module-scoped and not exported).

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-function-dependency/, prints every issue, and throws once listing them all; -PassThru returns
the result instead.

Must run post-import so Get-Command covers all loaded modules. Reads the per-function source files, which exist only in the source tree, so
it stops with a named error in build mode (Assert-SourceTree, [DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `ModulesRoot`

Path to the modules folder. Defaults to the loaded code root (Get-CatzcModulesRoot).

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-function-dependency`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; FunctionCount }) instead of throwing.

### outputs

Throws on any issue; with -PassThru, returns the result object.

### example 1

```powershell
Test-FunctionDependency
```

### example 2

```powershell
(Test-FunctionDependency -PassThru).Issues
```

## comment:1

Above `$parsed = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
overhead, [ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)); the definition map
and the call-resolution walk reuse these ASTs, so each file is read and parsed a single time. The walk itself is
[Catzc.Base.ModuleSystem.FunctionCallCollector] — one C# pass per function, not scriptblock-predicate FindAll calls.
```

## comment:2

Above `$rel = $path.Substring($moduleDir.Length)`, written with `#`.

```text
Match assets/private against the MODULE-RELATIVE path, not the absolute one: an absolute temp/CI
path can itself sit under a '/private/' or '/assets/' segment (e.g. macOS $TestDrive resolves to
/private/var/folders/...), which would otherwise misclassify every fixture file as private.
```

## comment:3

Above `$existing = $definitions[$fn.Name]`, written with `#`.

```text
Two PUBLIC (module-root) definitions of one name is a real collision — the module imported
last silently shadows the other (defense-in-depth; the importer's Assert-UniqueModuleFunctionName
already blocks this at load). Duplicate PRIVATE names across modules are legal (privates are
module-scoped, not exported): keep first-wins, but prefer a public definition over a private one
for resolution and reporting.
```

## comment:4

Above `$isLoadedCommand = [System.Collections.Generic.Dictionary[string,...`, written with `#`.

```text
Check each collected call → flag any that resolve to nothing. Get-Command runs once per distinct external name
in this run (a whole-session Get-Command snapshot measures slower than the few dozen lookups the memo leaves).
```
