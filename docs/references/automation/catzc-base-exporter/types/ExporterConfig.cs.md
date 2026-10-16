---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ba9589b91c4a
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Exporter/types/ExporterConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The single export config (configs/exporter.yml): how this repository exports itself as the installable,
versioned Catzc build ([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Exporter.ExporterConfig), so Get-Config -Config exporter
returns this typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException. Every key
is required, and an unknown key throws (a typo fails fast at load):
  direct_install_version  numeric MAJOR.MINOR.PATCH (a valid module version) — the devbox build placeholder
  bundles                 a non-empty map of lowercase bundle name -> a well-formed ExporterBundle (its profile, its
                          own version line, its vendor policy); each bundle versions on its own
  default_bundle          the bundle built when none is named; one of the bundles
  module_guid             a GUID — the Catzc module's stable identity (a registered managed GUID)
  package                 a well-formed ExporterPackage
```
