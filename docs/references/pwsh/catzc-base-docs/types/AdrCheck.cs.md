# pwsh/Catzc.Base.Docs/types/AdrCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections;`, written with `//`.

```text
One ADR check's settings in configs/adr-checks.yml that need nothing beyond their mode: the citation graph of the rule
summaries, checked by Test-AdrRegistry. Mirrors the YAML mapping (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by AdrChecksConfig.
  mode — report | gate; default CheckMode's default, gate
```
