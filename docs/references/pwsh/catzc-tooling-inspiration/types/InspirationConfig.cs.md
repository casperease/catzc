# pwsh/Catzc.Tooling.Inspiration/types/InspirationConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The inspirations catzc reads for ideas, configs/inspiration.yml: an 'inspirations' list of InspirationEntry
([ADR-REPO-INSPIRE](/docs/drs/repository/inspiration.md)). Constructing an instance MAPS and VALIDATES the parsed
YAML and collects every violation into one throw. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Tooling.Inspiration.InspirationConfig), so Get-Config -Config inspiration returns this typed model.
Mirrors the YAML mapping (snake_case keys, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

The sensible default, the one 'eac' entry, is declared once here (DefaultInspirations,
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an empty file and an
omitted or null 'inspirations' key take it, so an empty file and a fresh checkout behave the same. An explicit
empty list declares no inspirations.

Load-time rules:
  - a mapping whose only key is 'inspirations' (or an empty file);
  - 'inspirations' is a list of well-formed entries (InspirationEntry);
  - every id is unique.
```
