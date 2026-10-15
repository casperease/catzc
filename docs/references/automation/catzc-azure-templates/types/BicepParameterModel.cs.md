---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepParameterModel.cs.md
    kind: comment-page
    body_sha: c647dc514fd6
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Azure.Templates/types/BicepParameterModel.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A compiled Bicep template's parameter model: the template name plus every parameter main.json declares, keyed by
name. Parsed from the `parameters` section (and the `definitions` a user-defined type refers to) of the main.json
`az bicep build` writes; Get-BicepParameterModel returns it and Get-BicepParameterViolations checks every rendered
parameters.<config>.json against it.

A result type, so PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
The keys compare case-insensitively, as ARM matches parameter names.
```

## comment:2

Above `public static BicepParameterModel Parse(string template, string mainJson)`.

```text
Parses the text of a compiled main.json. Throws, naming the template, when the text is not a JSON object or a
parameter declaration is malformed.
```
