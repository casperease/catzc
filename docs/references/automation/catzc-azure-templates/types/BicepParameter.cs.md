---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepParameter.cs.md
    kind: comment-page
    body_sha: "7e09d8bdc468"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Azure.Templates/types/BicepParameter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One parameter of a compiled Bicep template: the contract `az bicep build` writes into the `parameters` section of
main.json — its type, whether it has a default, its @allowed values, and its @minValue/@maxValue and
@minLength/@maxLength bounds. Get-BicepParameterViolations checks every rendered parameters.<config>.json value
against it.

A result type, not a config mirror, so its properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). It is a model type
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)): the checks branch on its
Type and bounds, so the shape is fixed here and validated at construction. Nested into BicepParameterModel, which
parses the whole section.

The nested shape of an object or array parameter (Bicep `items`/`properties`) is not modelled: only the top-level
type, the allowed values, and the bounds are.
```

## comment:2

Above `public static readonly IReadOnlyList<string> Types = Array.AsReadOnly(new[]`, written with `//`.

```text
The parameter types ARM declares, spelled the way Bicep and the ARM documentation spell them. ARM reads the
type case-insensitively (main.json writes "securestring"); the model stores this canonical spelling.
```

## comment:3

Above `public static BicepParameter FromArmDeclaration(string name, JsonElement...`, written with `//`.

```text
Builds the parameter from its main.json declaration. A declaration that names a user-defined type
(`"$ref": "#/definitions/<name>"`) takes its type and any constraint it does not set itself from that definition.
```

## comment:4

Above `public static object ToComparable(JsonElement value)`, written with `//`.

```text
Normalizes a JSON value for comparison against AllowedValues: a string stays a string, an integer becomes a
long, true/false a bool, null a null, and any other value (a fractional number, an object, an array) its
compact JSON text.
```
