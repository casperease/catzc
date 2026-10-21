# pwsh/Catzc.Base.Reports/types/ReportsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The quality-gate report settings (configs/reports.yml): where a gate writes its report and how the files are
named. Every key has a sensible default, so the file overrides only what differs — an empty file means the
defaults: out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md plus out/test-<subject>/latest.txt
([ADR-AUTO-TEST-QUALITYGATE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)). `{subject}` in a value is the
gate's subject (a kebab-case name such as 'spelling'). Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
