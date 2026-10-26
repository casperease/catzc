# pwsh/Base.Variants/types/VariantAspect.cs

One aspect of a track's ordered classification in the `aspects` variant (`configs/variants.yml`,
[DDR-ASPECT](../../../../drs/design/module-aspects.md)): a single-key `{name: [patterns]}` entry, its patterns relative to the unit root.
VariantsConfig validates the entry in its track's context (name, order, catch-all) and builds one; `Get-Aspect` returns them.

## Shape

The YAML key is the aspect's name, which is data rather than a fixed field, so the record is not a key mirror and keeps .NET PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`Patterns` holds the aspect's globs; a track's last aspect is the bare `**` catch-all for whatever the earlier aspects leave.
