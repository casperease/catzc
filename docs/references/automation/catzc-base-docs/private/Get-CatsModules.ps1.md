---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
    kind: comment-page
    body_sha: e539a88de28e
---

# automation/Catzc.Base.Docs/private/Get-CatsModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$loaded = foreach ($module in (Get-Module)) {`.

```text
Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
so keep only the entry named for its folder whose root file is not a nested .ps1.
```
