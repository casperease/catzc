# docs/references/automation/catzc-base-reports/types/ReportsConfig.cs.md

`automation/Catzc.Base.Reports/types/ReportsConfig.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The quality-gate report settings (configs/reports.yml): where a gate writes its report and how the files are
named. Every key has a sensible default, so the file overrides only what differs — an empty file means the
defaults: out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md plus out/test-<subject>/latest.txt
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). `{subject}` in a value is the
gate's subject (a kebab-case name such as 'spelling'). Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
