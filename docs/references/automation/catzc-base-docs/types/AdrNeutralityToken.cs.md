# docs/references/automation/catzc-base-docs/types/AdrNeutralityToken.cs.md

`automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System.Collections.Generic;`.

```text
One forbidden token of the engine-neutrality check (configs/adr-checks.yml, engine_neutrality.tokens): a kebab-case name and a
case-sensitive .NET regular expression that matches engine-specific syntax in a rule summary. Mirrors the YAML entry (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by
AdrNeutralityCheck, which rejects a name that is not kebab-case and a pattern that does not compile.
```
