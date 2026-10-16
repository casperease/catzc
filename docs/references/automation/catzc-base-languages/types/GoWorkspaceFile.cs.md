---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/GoWorkspaceFile.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3f04bc386939"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One file New-GoWorkspace renders: the root go.work, or a go/tests/<folder>/go.mod. A result type, so its
properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
The renderer only composes content; Build-RootConfig owns the write
([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```
