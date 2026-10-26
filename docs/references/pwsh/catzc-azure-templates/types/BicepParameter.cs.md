# pwsh/Azure.Templates/types/BicepParameter.cs

The typed record of one parameter of a compiled Bicep template: the contract `az bicep build` writes into the `parameters` section of
`main.json`. It holds the type, whether there is a default, whether the parameter is nullable, the `@allowed` values, and the
`@minValue`/`@maxValue` and `@minLength`/`@maxLength` bounds. `Get-BicepParameterViolations` checks every rendered
`parameters.<config>.json` value against it, and it nests into `BicepParameterModel`, which parses the whole section.

## Shape

It is a result type, not a config mirror, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). It is
a model type ([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)):
the checks branch on its type and bounds, so the shape is fixed here and validated at construction.

The nested shape of an object or array parameter (Bicep `items` and `properties`) is not modelled, only the top-level type, the allowed
values and the bounds.

## Types

`Types` lists the parameter types ARM declares, spelled as Bicep and the ARM documentation spell them. ARM reads the type
case-insensitively, and `main.json` writes `securestring`, so the model stores this canonical spelling.

## From a declaration

`FromArmDeclaration` builds the parameter from its `main.json` declaration. A declaration that names a user-defined type
(`"$ref": "#/definitions/<name>"`) takes its type, and any constraint it does not set itself, from that definition.

## Comparable values

`ToComparable` normalizes a JSON value for comparison against the allowed values: a string stays a string, an integer becomes a long,
true and false become a bool, null stays null, and any other value (a fractional number, an object, an array) becomes its compact JSON
text.
