# pwsh/Catzc.Base.Drs/types/DrsCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections;`, written with `//`.

```text
One ADR check's settings in configs/drs-checks.yml that need nothing beyond their mode: the citation graph of the rule
summaries, checked by Test-DrsRegistry. Mirrors the YAML mapping (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); built and validated by DrsChecksConfig.
  mode — report | gate; default CheckMode's default, gate
```
