# pwsh/Base.Exporter/types/ExporterBundle.cs

One named bundle of `configs/exporter.yml` (`bundles.<name>`): a release identity of its own, with the modules it carries, its own version
line ([ADR-AUTO-BUNDLE](../../../../drs/automation/platform-bundle.md)). The repository is a mono repo, so every bundle versions on its own
and no bundle's version moves another's. The properties mirror the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the block and collects every violation into one `ArgumentException`:

- **`profile`** is required: the module set, a `profiles.yml` key. It is not cross-checked here, so loading stays self-contained.
- **`version`** is required: the numeric MAJOR.MINOR of a pipeline build of this bundle (the PATCH is calculated).
- **`max_files`** and **`max_bytes`** are optional positive integers, the most files or bytes a build of this bundle may hold. Absent means
  no limit.
- **`platforms`** is an optional list of `<os>/<arch>` entries (lowercase, no duplicates), the targets a packaged binary is built for
  ([ADR-AUTO-BUNDLE-EVERYLANGUAGE](../../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)). The default set,
  declared once on the type, is `windows/amd64`, `linux/amd64` and `darwin/arm64`.

## Why the limits are opt-in

A footprint limit is opt-in, like any check that is off until a bundle states its number: a bundle that ships to a constrained target states
one, and `Build-Modules` fails a build that outgrows it.
