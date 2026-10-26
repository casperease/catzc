# pwsh/Base.Exporter/types/ExporterConfig.cs

The typed record of the single export config, `configs/exporter.yml`: how this repository exports itself as the installable, versioned Catzc
build ([ADR-AUTO-BUNDLE](../../../../drs/automation/platform-bundle.md)). It is registered in `Catzc.Base.Config/configs/configs.yml`
(`type: Catzc.Base.Exporter.ExporterConfig`), so `Get-Config -Config exporter` returns it. The properties mirror the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`. Every key is required, and an unknown
key throws, so a typo fails fast at load:

- **`direct_install_version`** is a numeric MAJOR.MINOR.PATCH (a valid module version), the devbox build placeholder.
- **`bundles`** is a non-empty map of lowercase bundle name to a well-formed `ExporterBundle`.
- **`default_bundle`** is the bundle built when none is named, and one of the bundles.
- **`module_guid`** is a GUID, the Catzc module's stable identity (a registered managed GUID).
- **`package`** is a well-formed `ExporterPackage`.
