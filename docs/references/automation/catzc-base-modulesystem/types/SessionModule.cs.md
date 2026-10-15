---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/SessionModule.cs.md
    kind: comment-page
    body_sha: "66cc733e57c8"
---

# automation/Catzc.Base.ModuleSystem/types/SessionModule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.ModuleSystem;`, written with `//`.

```text
A module loaded into the current PowerShell session, mapped by how it came into play (its ModuleBase
location): Kind 'imported' (our automation module, under automation/), 'vendored' (under automation/.vendor/),
'builtin' (shipped with PowerShell, under $PSHOME), or 'residue' (genuinely foreign — user profile, the
PowerShell Gallery, or a manual import). The runtime facet — introspection and collision reporting, not copying.
```
