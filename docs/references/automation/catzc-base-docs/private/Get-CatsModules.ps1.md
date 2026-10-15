---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
    kind: comment-page
    body_sha: b794294647c2
    adrs:
      - ADR-DSGN-RUNMODE#2
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.Docs/private/Get-CatsModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot)
and is not dot-prefixed (a dot-prefix means infrastructure,
[ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)), with the functions it
exports.
Because it reads what is loaded rather than the per-function files, the answer is the same in source mode and
in build mode, where each module's functions are merged into one file
([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)). Private functions
are never exported, so they never appear.

Private helper for Show-Cats; not exported.
```

## comment:2

Section `.PARAMETER ModulesRoot` of the comment-based help.

```text
The code root whose loaded modules to list. Defaults to Get-CatzcModulesRoot. A test points this at a fixture
root from which it loaded fixture modules.
```

## comment:3

Above `$loaded = foreach ($module in (Get-Module)) {`.

```text
Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
so keep only the entry named for its folder whose root file is not a nested .ps1.
```

## comment:4

Above `$loaded = foreach ($module in (Get-Module)) {`.

```text
Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
so keep only the entry named for its folder whose root file is not a nested .ps1.
```
