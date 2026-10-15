---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/SessionModule.cs.md
    kind: comment-page
    body_sha: b2415eb74a00
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/types/SessionModule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.ModuleSystem;`.

```text
A module loaded into the current PowerShell session, mapped by how it came into play (its ModuleBase
location): Kind 'imported' (our automation module, under automation/), 'vendored' (under automation/.vendor/),
'builtin' (shipped with PowerShell, under $PSHOME), or 'residue' (genuinely foreign — user profile, the
PowerShell Gallery, or a manual import). The runtime facet — introspection and collision reporting, not copying.
```
