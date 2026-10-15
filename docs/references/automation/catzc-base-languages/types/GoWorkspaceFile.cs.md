---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/GoWorkspaceFile.cs.md
    kind: reference
    body_sha: aa57d63fbba2
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One file New-GoWorkspace renders: the root go.work, or a go/tests/<folder>/go.mod. A result type, so its
properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
The renderer only composes content; Build-RootConfig owns the write
([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```
