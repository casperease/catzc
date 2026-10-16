---
catzc:
  immutable:
    with_body_sha: "104a6465f2e7"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/types/AdrNeutralityCheck.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: adr-neutrality-check-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Docs/types/AdrNeutralityCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The engine-neutrality check's settings (configs/adr-checks.yml, engine_neutrality), read by Test-AdrEngineNeutrality: the rule
summaries of the listed adrs.yml domains carry no engine-specific syntax
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)). Mirrors the YAML mapping (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by AdrChecksConfig.
  mode    — report | gate; default CheckMode's default, gate
  domains — the adrs.yml domains whose rule summaries are checked; default none
  tokens  — a map of token name (kebab-case) to a case-sensitive .NET regular expression; default none
Whether each domain is declared in adrs.yml is the check's own finding, not a load-time rule: this type reads no other config.
```
