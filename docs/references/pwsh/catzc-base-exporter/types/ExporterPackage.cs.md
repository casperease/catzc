# pwsh/Catzc.Base.Exporter/types/ExporterPackage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The package identity and metadata block of configs/exporter.yml (`package:`) — Build-Modules hands it to the
build engine, which writes it into the build's top-level Catzc.psd1 (the manifest Install-PSResource and the
PowerShell Gallery read). Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the block, collecting every violation into one ArgumentException: author,
company, description, project_uri and license_uri are non-empty strings, and tags is a non-empty list.
```
