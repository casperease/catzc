# automation/Catzc.Base.Exporter/types/ExporterBundle.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One named bundle of configs/exporter.yml (`bundles.<name>`): a release identity of its own — which modules it
carries, its own version line, and which vendored modules travel with it
([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). The repository is a mono repo, so every bundle
versions on its own; no bundle's version moves another's. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the block, collecting every violation into one ArgumentException:
  profile        required; the module set (a profiles.yml key; not cross-checked here, so loading stays
                 self-contained)
  version        required; numeric MAJOR.MINOR of a pipeline build of this bundle (PATCH is calculated)
  vendor_policy  'runtime' (the default) ships only the runtime-required vendored module; 'full' also ships the
                 test toolset
  max_files      optional; the most files a build of this bundle may hold (a positive integer). Absent: no limit
  max_bytes      optional; the most bytes a build of this bundle may hold (a positive integer). Absent: no limit
A footprint limit is opt-in, like any check that is off until a bundle states its number: a bundle that ships to
a constrained target states one, and Build-Modules fails a build that outgrows it.
```
