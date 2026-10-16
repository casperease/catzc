---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/types/ReportsConfig.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a4c5189a4f76
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Reports/types/ReportsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The quality-gate report settings (configs/reports.yml): where a gate writes its report and how the files are
named. Every key has a sensible default, so the file overrides only what differs — an empty file means the
defaults: out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md plus out/test-<subject>/latest.txt
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). `{subject}` in a value is the
gate's subject (a kebab-case name such as 'spelling'). Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
