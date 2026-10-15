---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-AutomationFunctions.ps1.md
    kind: comment-page
    body_sha: "3a08a7a4fa1b"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/Get-AutomationFunctions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enumerates all non-dot-prefixed module folders under the automation root,
finds the matching loaded modules, and returns their exported functions.

With -NotUsedInternally, filters to functions that are never called by
another automation function (no incoming edges in the call graph).

The listing describes the loaded modules, so it works in both run modes
([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
-NotUsedInternally reads the per-function source files, so it stops with a named error in build mode
(Assert-SourceTree).
```
