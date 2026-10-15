---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoScriptRootAnchor.psm1.md
    kind: comment-page
    body_sha: f5abe8f392d2
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoScriptRootAnchor.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A module's code runs in two modes: source mode, loading each function file from automation/<Module>/, and
build mode, loading the module's functions merged into one file inside a built package. $PSScriptRoot names
the folder of the file that is running, so in source mode a lookup like Join-Path $PSScriptRoot 'assets/x'
happens to find the module folder, while in build mode it points somewhere else and the lookup breaks.
Module-internal content (configs/, assets/, another module's files) is located only through
Get-CatzcModuleRoot -ChildPath '<literal>' (or Get-CatzcModulesRoot for the dot-prefixed infrastructure).

This rule flags every $PSScriptRoot reference in a module function file: a .ps1 file directly under
automation/<Module>/ (public) or automation/<Module>/private/ (private). Everything else is exempt by path:
- tests/, assets/ and any other subfolder of a module (only the module root and private/ are function files);
- dot-prefixed folders under automation/ (.internal, .scriptanalyzer, .vendor) — the infrastructure that
  anchors the modules root itself;
- files outside automation/ (repository-root scripts, infrastructure/).
A script analysed without a file path (Invoke-ScriptAnalyzer -ScriptDefinition) has no location and is not
flagged.

See ADR: [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1).
```

## comment:2

Above `$file = $ScriptBlockAst.Extent.File`.

```text
Only module function files are in scope: automation/<Module>/<File>.ps1 or automation/<Module>/private/<File>.ps1,
where <Module> is not dot-prefixed (.internal, .scriptanalyzer, .vendor are infrastructure).
```

## comment:3

Above `$isVariable = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
