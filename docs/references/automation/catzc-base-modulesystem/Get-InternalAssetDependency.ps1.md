---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
    kind: comment-page
    body_sha: c51a52e3cd34
    adrs:
      - ADR-AUTO-ASSETDEP#2
---

# automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The inventory of [ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2),
derived from the code: the code is the registration, so there is no
separate list to keep in step. Parses every module function file — the .ps1 files at a module folder's root
and in its private/ folder, never tests/ or assets/ — and finds each call to Get-CatzcModuleRoot. Each call
site becomes one record:

    Module     the module whose folder the call resolves under: the -Module literal when the call passes
               one (a cross-module read), otherwise the module that holds the file
    Function   the function that makes the call
    ChildPath  the -ChildPath literal (positional argument 0 or -ChildPath); $null when the call names the
               module folder itself
    File       the file, repository-relative (automation/<Module>/...)
    Line       the line of the call

-ChildPath must be a string literal at every call site
([ADR-AUTO-ASSETDEP#2](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep2)), and so must
-Module when it
is passed. A call whose value is computed — a variable, an expandable string, a subexpression, or a splat
that hides the arguments — cannot be inventoried. Such a call site is a violation: by default the command
throws, naming every violating site, so the inventory is never silently partial. -Violation returns the
violating sites instead of the inventory, without throwing.

Reads the per-function source files, which exist only in the source tree, so it stops with a named error
in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Section `.PARAMETER Violation` of the comment-based help.

```text
Return the call sites whose -ChildPath or -Module is not a string literal ({ Module; Function; File; Line;
Expression; Reason }) instead of the inventory, and do not throw.
```

## comment:3

Above `$helperName = 'Get-CatzcModuleRoot'`.

```text
The helper's own parameter metadata decides how each argument binds: which names (or unambiguous
prefixes, or aliases) mean -ChildPath / -Module, and which other parameters take a value (common
parameters such as -ErrorAction) so their value is never mistaken for the positional child path.
```

## comment:4

Above `$helperName = 'Get-CatzcModuleRoot'`.

```text
The helper's own parameter metadata decides how each argument binds: which names (or unambiguous
prefixes, or aliases) mean -ChildPath / -Module, and which other parameters take a value (common
parameters such as -ErrorAction) so their value is never mistaken for the positional child path.
```
