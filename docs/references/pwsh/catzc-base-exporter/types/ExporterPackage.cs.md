# pwsh/Base.Exporter/types/ExporterPackage.cs

The package identity and metadata block of `configs/exporter.yml` (`package:`). `Build-Modules` hands it to the build engine, which writes
it into the build's top-level `Catzc.psd1`, the manifest `Install-PSResource` and the PowerShell Gallery read. The properties mirror the
YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the block and collects every violation into one `ArgumentException`: `author`, `company`, `description`,
`project_uri` and `license_uri` are non-empty strings, and `tags` is a non-empty list.
