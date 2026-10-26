# pwsh/Base.ModuleSystem/Get-FunctionDependency.ps1

Compiles the function-to-function call graph of every module from the source files, by AST. It is the one expensive walk behind
`Get-ModuleDependency`, `Get-ModuleFunction`, `Get-FunctionDependencyTree` and the integrity tests, so its result is cached for the session.

## help

### synopsis

Compiles a list of function-to-function calls across all catzc modules using AST.

### description

Parses every .ps1 file (excluding tests) under the modules root, builds a definition map of all functions, then walks each function body for
CommandAst nodes and cross-references them against the map.

Reads the per-function source files, which exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
[DDR-RUNMODE](../../../drs/design/run-modes.md)).

### parameter `ModulesRoot`

Path to the modules folder. Defaults to the loaded code root (Get-CatzcModulesRoot).

### parameter `ParsedScripts`

The call's shared parse of each script; the session cache of the result stays, this only spares a second parse of a file within one build.

### example 1

```powershell
Get-FunctionDependency
```

### example 2

```powershell
Get-FunctionDependency | Where-Object CrossModule
```

### example 3

```powershell
Get-FunctionDependency | Get-ModuleDependency
```

## Caching

The result is derived from the file system, so it is cached for the session on first use and keyed on the resolved modules root
([ADR-AUTO-CACHE-FILESYSTEMDERIVED](../../../drs/automation/caching.md#rule-adr-auto-cache-filesystemderived),
[ADR-AUTO-CACHE-KEYEDBYINPUTS](../../../drs/automation/caching.md#rule-adr-auto-cache-keyedbyinputs)). The AST walk runs once and every
consumer reuses it. Re-running the importer resets the `$script:` state, which is the only invalidation
([ADR-AUTO-CACHE-IMPORTERINVALIDATES](../../../drs/automation/caching.md#rule-adr-auto-cache-importerinvalidates)). A fixture root passed by
a test gets its own entry, so it cannot collide with the real tree
([ADR-AUTO-TEST-SAFESEAMSWAPS](../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)). Callers treat the result as
read-only ([ADR-AUTO-CACHE-READONLYVALUES](../../../drs/automation/caching.md#rule-adr-auto-cache-readonlyvalues)). The cache entry is
probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## One parse per file

Every source `.ps1` is listed and parsed once, and both the definition map and the call walk reuse those parses, capturing each file's
top-level functions. Listing avoids `Get-ChildItem -Recurse`, which carries about 20 ms of provider overhead a call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
