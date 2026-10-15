---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/types/ExporterPackage.cs.md
    kind: comment-page
    body_sha: e81f1d72a735
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.Exporter/types/ExporterPackage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The package identity and metadata block of configs/exporter.yml (`package:`) — Build-Modules hands it to the
build engine, which writes it into the build's top-level Catzc.psd1 (the manifest Install-PSResource and the
PowerShell Gallery read). Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the block, collecting every violation into one ArgumentException: author,
company, description, project_uri and license_uri are non-empty strings, and tags is a non-empty list.
```
