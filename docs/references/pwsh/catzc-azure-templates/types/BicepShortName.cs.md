# pwsh/Azure.Templates/types/BicepShortName.cs

The typed short name of a template: the 2 to 5 character, lowercase-alphanumeric Azure id segment every resource name is built from
([ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-twotemplateidentifiers)). A
template carries two identifiers, its readable, kebab-case on-disk folder name and this short name, and only the short name is ever
Azure-facing.

The type makes the two identifiers, the derivation and the format validation one construction-time invariant, so no caller re-implements the
rule and a malformed name cannot exist. It is a plain model type
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)):
`Get-BicepTemplates` constructs one per template and pins its `value` as the short name. It does not mirror a YAML file, so it keeps the
validation and derivation logic here and not in a loose dictionary.

## Length

`MaxLength` is 5. Five keeps the worst-case tight (storage) name at 23 of 24 characters, one byte to spare
([ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md), "Length budget").

## Resolving

`Resolve(folder, overrideValue)` resolves the short name from the folder name and an optional `options.yml` override. A null or empty
override derives from the folder name, and otherwise the override is validated and taken. It throws, naming the template, when the override
is malformed, or when the folder derives a value that cannot be a valid short name (fewer than 2 `[a-z0-9]` characters, or a leading digit)
and no override is given.

## Deriving

`Derive(folder)` lowercases the folder name, keeps only `[a-z0-9]` (hyphens and any other punctuation are dropped) and takes the first
`MaxLength` characters, so `discovery` becomes `disco`. It is pure and total: an empty or all-punctuation folder yields an empty string,
which `IsValid` rejects at `Resolve` and so prompts an override.

## Validity

`IsValid(value)` accepts a well-formed short name: 2 to `MaxLength` characters, a leading letter, then lowercase alphanumerics. It mirrors
the `options.yml` schema regex `^[a-z][a-z0-9]{1,4}$` (`Read-BicepTemplateOptions`) and the naming rule
[ADR-AZ-NAMING-LOWERCASECOMPONENTS](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents).
