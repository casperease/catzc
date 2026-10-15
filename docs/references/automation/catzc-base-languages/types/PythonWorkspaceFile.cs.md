---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/PythonWorkspaceFile.cs.md
    kind: comment-page
    body_sha: "336ea67e73b2"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One file New-PythonProject renders: the uv workspace root <root>/pyproject.toml, or a member
<root>/tests/<folder>/pyproject.toml. A result type, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The renderer only composes
content; Build-RootConfig owns the write ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```
