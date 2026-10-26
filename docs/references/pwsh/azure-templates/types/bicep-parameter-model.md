# pwsh/Azure.Templates/types/BicepParameterModel.cs

The typed parameter model of a compiled Bicep template: the template name plus every parameter `main.json` declares, keyed by name. It is
parsed from the `parameters` section, and the `definitions` a user-defined type refers to, of the `main.json` that `az bicep build` writes.
`Get-BicepParameterModel` returns it, and `Get-BicepParameterViolations` checks every rendered `parameters.<config>.json` against it.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
keys compare case-insensitively, as ARM matches parameter names.

## Parsing

`Parse` takes the text of a compiled `main.json`. It throws, naming the template, when the text is not a JSON object or a parameter
declaration is malformed.
