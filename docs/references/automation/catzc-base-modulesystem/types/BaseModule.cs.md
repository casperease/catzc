---
catzc:
  immutable:
    with_body_sha: "667e3561134d"
    repo_status: locked
    path: docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md
    folder: docs/references/automation/catzc-base-modulesystem/types
    name: base-module-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.ModuleSystem/types/BaseModule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The internal model type for an automation "module" — one concept with four kinds (native C# per
[ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9), because the platform's own logic selects on it
and pins it at call sites). Two facets:
on-disk (kinds 'named'/'hidden', see DiskModule) and in-session (kinds 'imported'/'residue', see
SessionModule). Get-BaseModule returns these; Copy-Automation and module introspection act on them.
```

## comment:2

Above `public string Name { get; }`, written with `//`.

```text
The module name. For a disk module the folder name (e.g. 'Catzc.Base.Config', '.vendor'); for a session
module the loaded module name.
```
