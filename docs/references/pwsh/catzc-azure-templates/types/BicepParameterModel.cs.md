# pwsh/Catzc.Azure.Templates/types/BicepParameterModel.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A compiled Bicep template's parameter model: the template name plus every parameter main.json declares, keyed by
name. Parsed from the `parameters` section (and the `definitions` a user-defined type refers to) of the main.json
`az bicep build` writes; Get-BicepParameterModel returns it and Get-BicepParameterViolations checks every rendered
parameters.<config>.json against it.

A result type, so PascalCase ([ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).
The keys compare case-insensitively, as ARM matches parameter names.
```

## comment:2

Above `public static BicepParameterModel Parse(string template, string mainJson)`, written with `//`.

```text
Parses the text of a compiled main.json. Throws, naming the template, when the text is not a JSON object or a
parameter declaration is malformed.
```
