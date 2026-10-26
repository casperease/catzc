# pwsh/Base.Exporter/types/ExporterBundle.cs

One named bundle of `configs/exporter.yml` (`bundles.<name>`): a release identity of its own, with the modules it carries, its own version
line and the vendored modules that travel with it ([ADR-AUTO-BUNDLE](../../../../drs/automation/platform-bundle.md)). The repository is a
mono repo, so every bundle versions on its own and no bundle's version moves another's. The properties mirror the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the block and collects every violation into one `ArgumentException`:

- **`profile`** is required: the module set, a `profiles.yml` key. It is not cross-checked here, so loading stays self-contained.
- **`version`** is required: the numeric MAJOR.MINOR of a pipeline build of this bundle (the PATCH is calculated).
- **`vendor_policy`** is `runtime` (the default), which ships only the runtime-required vendored module, or `full`, which also ships the
  test toolset.
- **`max_files`** and **`max_bytes`** are optional positive integers, the most files or bytes a build of this bundle may hold. Absent means
  no limit.

## Why the limits are opt-in

A footprint limit is opt-in, like any check that is off until a bundle states its number: a bundle that ships to a constrained target states
one, and `Build-Modules` fails a build that outgrows it.
