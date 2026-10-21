# pwsh/Catzc.Azure.Templates/types/BicepShortName.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A template's `short_name` — the 2-5 char, lowercase-alnum Azure id segment every resource name is built
from ([ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS](/docs/drs/azure/azure-naming-standard.md#rule-adr-az-naming-twotemplateidentifiers)). A template carries TWO identifiers: its readable,
kebab-case on-disk FOLDER name and this short_name; only the short_name is ever Azure-facing.

The short_name is DERIVED from the folder name by default — lowercase, keep only [a-z0-9] (hyphens and any
other punctuation dropped), take the first 5 characters ("discovery" -> "disco"). A template MAY override it
with an explicit `short_name` in its optional options.yml
(Read-BicepTemplateOptions). This type makes the two identifiers, the derivation, and the format validation
ONE construction-time invariant, so no caller re-implements the rule and a malformed name cannot exist.

A plain model type ([ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)) — Get-BicepTemplates
constructs one per template and pins its .value as the short_name; it does not mirror a YAML file, so it
keeps default validation and derivation logic here rather than a loose dictionary.
```

## comment:2

Above `public const int MaxLength = 5;`, written with `//`.

```text
The maximum short_name length. Keeping this at 5 keeps the worst-case tight (storage) name at 23/24
with a byte to spare ([ADR-AZ-NAMING](/docs/drs/azure/azure-naming-standard.md), "Length budget").
```

## comment:3

Above `public static BicepShortName Resolve(string folder, string overrideValue)`, written with `//`.

```text
Resolve a template's short_name from its folder name and an optional options.yml override.
  overrideValue null/empty -> derive from the folder name;
  otherwise                -> validate and take the override.
Throws (naming the template) when the override is malformed, or when the folder derives a value that
cannot be a valid short_name (fewer than 2 [a-z0-9] chars, or a leading digit) and no override is given.
```

## comment:4

Above `public static string Derive(string folder)`, written with `//`.

```text
The derivation: lowercase, keep only [a-z0-9] (drop hyphens and any other punctuation), take the first
MaxLength characters. Pure and total — an empty/all-punctuation folder yields "" (which IsValid rejects
at Resolve, prompting an override).
```

## comment:5

Above `public static bool IsValid(string value)`, written with `//`.

```text
A well-formed short_name: 2-MaxLength chars, a leading letter then lowercase-alnum. Mirrors the
options.yml schema regex ^[a-z][a-z0-9]{1,4}$ (Read-BicepTemplateOptions) and naming-standard Rule
[ADR-AZ-NAMING-LOWERCASECOMPONENTS](/docs/drs/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents).
```
