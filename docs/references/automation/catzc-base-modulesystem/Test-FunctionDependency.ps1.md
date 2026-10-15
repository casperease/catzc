---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-FunctionDependency.ps1.md
    kind: comment-page
    body_sha: "164160fba238"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$parsed = [System.Collections.Generic.List[object]]::new()`.

```text
Parse every source .ps1 ONCE ([System.IO] recursive — Get-ChildItem -Recurse carries ~20ms/call provider
overhead, [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); the definition map
and the call-resolution walk reuse these ASTs, so each file is read and parsed a single time. The walk itself is
[Catzc.Base.ModuleSystem.FunctionCallCollector] — one C# pass per function, not scriptblock-predicate FindAll calls.
```

## comment:7

Above `$rel = $path.Substring($moduleDir.Length)`.

```text
Match assets/private against the MODULE-RELATIVE path, not the absolute one: an absolute temp/CI
path can itself sit under a '/private/' or '/assets/' segment (e.g. macOS $TestDrive resolves to
/private/var/folders/...), which would otherwise misclassify every fixture file as private.
```

## comment:8

Above `$existing = $definitions[$fn.Name]`.

```text
Two PUBLIC (module-root) definitions of one name is a real collision — the module imported
last silently shadows the other (defense-in-depth; the importer's Assert-UniqueModuleFunctionName
already blocks this at load). Duplicate PRIVATE names across modules are legal (privates are
module-scoped, not exported): keep first-wins, but prefer a public definition over a private one
for resolution and reporting.
```

## comment:9

Above `$isLoadedCommand = [System.Collections.Generic.Dictionary[string,...`.

```text
Check each collected call → flag any that resolve to nothing. Get-Command runs once per distinct external name
in this run (a whole-session Get-Command snapshot measures slower than the few dozen lookups the memo leaves).
```
