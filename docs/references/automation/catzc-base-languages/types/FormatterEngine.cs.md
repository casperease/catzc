---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/FormatterEngine.cs.md
    kind: reference
    body_sha: a29997bc9e1b
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.Languages/types/FormatterEngine.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One formatter engine's settings in the file-language registry (configs/languages.yml `engines:`): the VS Code
extension that runs the same engine in the editor, so Format Document and Format-Code agree
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)), and the repository files whose
content decides what the engine writes, so Format-Code's result cache is invalidated when one of them changes. The
fields mirror the YAML keys, so the properties are snake_case
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's key.
```

## comment:2

Above `public string vscode_extension { get; }`.

```text
The publisher.name id of the VS Code extension that runs the engine (e.g. esbenp.prettier-vscode). Null when the
editor has none.
```
