---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-cats-modules-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1ddcb43d259d"
---

# automation/Catzc.Base.Docs/private/Get-CatsModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$loaded = foreach ($module in (Get-Module)) {`, written with `#`.

```text
Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
so keep only the entry named for its folder whose root file is not a nested .ps1.
```
