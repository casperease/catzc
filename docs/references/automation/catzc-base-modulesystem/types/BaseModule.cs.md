---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md
    kind: comment-page
    body_sha: badf79992097
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.ModuleSystem/types/BaseModule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The internal model type for an automation "module" — one concept with four kinds (native C# per
[ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9), because the platform's own logic selects on it
and pins it at call sites). Two facets:
on-disk (kinds 'named'/'hidden', see DiskModule) and in-session (kinds 'imported'/'residue', see
SessionModule). Get-BaseModule returns these; Copy-Automation and module introspection act on them.
```

## comment:2

Above `public string Name { get; }`.

```text
The module name. For a disk module the folder name (e.g. 'Catzc.Base.Config', '.vendor'); for a session
module the loaded module name.
```
