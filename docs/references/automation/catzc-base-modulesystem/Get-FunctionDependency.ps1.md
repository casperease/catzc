# docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md

`automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Parses every .ps1 file (excluding tests) under the automation root, builds a
definition map of all functions, then walks each function body for CommandAst
nodes and cross-references them against the map.

Reads the per-function source files, which exist only in the source tree, so it stops with a named error
in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `if ($null -eq...`.

```text
Filesystem-derived information — cached for the session, lazily on first use, keyed on the resolved automation
root
([ADR-AUTO-CACHE#2](/docs/adr/automation/caching.md#rule-adr-auto-cache2)/[ADR-AUTO-CACHE#4](/docs/adr/automation/caching.md#rule-adr-auto-cache4)). The expensive AST walk runs once and Get-ModuleDependency / Get-AutomationFunctions
/ Get-FunctionDependencyTree (and the integrity tests) all reuse it. Re-running the importer resets the
$script: state — the only invalidation ([ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6)).
A fixture root passed by a test gets its own entry, so it
cannot collide with the real tree
([ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)). Callers treat the result as
read-only ([ADR-AUTO-CACHE#5](/docs/adr/automation/caching.md#rule-adr-auto-cache5)).
```

## comment:3

Above `$script:functionDependencyCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:4

Above `$isFunction = { param($n) $n -is...`.

```text
Enumerate + parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/
call provider overhead, [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)),
capturing each file's top-level functions. Both the definition map and
the call walk reuse these ASTs, so a file is read and parsed a single time (it was twice before).
```
