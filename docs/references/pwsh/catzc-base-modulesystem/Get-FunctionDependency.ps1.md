# pwsh/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Compiles a list of function-to-function calls across all automation modules using AST.

### description

Parses every .ps1 file (excluding tests) under the automation root, builds a definition map of all functions, then walks each function body
for CommandAst nodes and cross-references them against the map.

Reads the per-function source files, which exist only in the source tree, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

### parameter `ModulesRoot`

Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot).

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

## comment:1

Above `if ($null -eq...`, written with `#`.

```text
Filesystem-derived information — cached for the session, lazily on first use, keyed on the resolved automation
root
([ADR-AUTO-CACHE#2](/docs/adr/automation/caching.md#rule-adr-auto-cache2)/[ADR-AUTO-CACHE#4](/docs/adr/automation/caching.md#rule-adr-auto-cache4)). The expensive AST walk runs once and Get-ModuleDependency / Get-ModuleFunction
/ Get-FunctionDependencyTree (and the integrity tests) all reuse it. Re-running the importer resets the
$script: state — the only invalidation ([ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6)).
A fixture root passed by a test gets its own entry, so it
cannot collide with the real tree
([ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)). Callers treat the result as
read-only ([ADR-AUTO-CACHE#5](/docs/adr/automation/caching.md#rule-adr-auto-cache5)).
```

## comment:2

Above `$script:functionDependencyCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:3

Above `$parsed = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
Enumerate + parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/
call provider overhead, [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)),
capturing each file's top-level functions. Both the definition map and
the call walk reuse these ASTs, so a file is read and parsed a single time (it was twice before).
```
