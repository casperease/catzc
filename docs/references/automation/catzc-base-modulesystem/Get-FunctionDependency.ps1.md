---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-FunctionDependency.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "21cbd7522c30"
    adrs:
      - ADR-AUTO-CACHE#{2,4-6}
      - ADR-AUTO-TEST#4
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($null -eq...`, written with `#`.

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
