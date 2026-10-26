# pwsh/Base.Drs/types/DrsNeutralityToken.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
One forbidden token of the engine-neutrality check (configs/drs-checks.yml, engine_neutrality.tokens): a kebab-case name and a
case-sensitive .NET regular expression that matches engine-specific syntax in a rule summary. Mirrors the YAML entry (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); built and validated by
DrsNeutralityCheck, which rejects a name that is not kebab-case and a pattern that does not compile.
```
