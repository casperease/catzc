---
catzc:
  immutable:
    with_body_sha: "46b3779ff193"
    path: docs/references/automation/catzc-base-languages/types/PythonWorkspaceFile.cs.md
    folder: docs/references/automation/catzc-base-languages/types
    name: python-workspace-file-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/PythonWorkspaceFile.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One file New-PythonProject renders: the uv workspace root <root>/pyproject.toml, or a member
<root>/tests/<folder>/pyproject.toml. A result type, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The renderer only composes
content; Build-RootConfig owns the write ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```
