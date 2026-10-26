# pwsh/Base.ModuleSystem/Test-FunctionDependency.ps1

A quality gate that checks every statically named call in the module code resolves to a defined command, and that no public function name is
defined by two modules.

## help

### synopsis

Checks that every function-to-function call resolves to a defined command.

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

## One parse per file

Every source `.ps1` is listed and parsed once, and the definition map and the call-resolution walk reuse those parses
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)). The walk
itself is [FunctionCallCollector](types/function-call-collector.md), one C# pass per function. Each collected call that resolves to nothing
is flagged. `Get-Command` runs once per distinct external name, memoised, because a whole-session snapshot measures slower than the few
dozen lookups the memo leaves.

## Module-relative paths

Whether a file counts as private or as an asset is decided on the module-relative path, never the absolute one. An absolute temporary or CI
path can itself sit under a `/private/` or `/assets/` segment (the macOS `$TestDrive` resolves under `/private/var/folders/...`), which
would otherwise classify every fixture file as private.

## Duplicate names

Two public (module-root) definitions of one name are a real collision, because the module imported last silently shadows the other. The
check is defense in depth: the importer's `Assert-UniqueModuleFunctionName` already blocks it at load. Duplicate private names across
modules are legal, since privates are module-scoped and not exported. The first definition wins, but a public definition is preferred over a
private one for resolution and reporting.
