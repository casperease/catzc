---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/SourceCheck.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: source-check-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ef2e495b535e
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.QualityGates/types/SourceCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The settings every source check shares, read from its key in a QualityGates config (links.yml's string_citations,
source-conventions.yml's engine_set and neutral_codes), and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
  mode   — gate (every finding fails the run; the default) or report (findings are printed and counted, and never
           fail it). A check is in report mode only while its work list is drained (Catzc.Base.Docs.CheckMode,
           whose zero value, Gate, is the one declared default, parsed by the one Catzc.Base.Docs.CheckModes parser).
  exempt — repository-relative glob (the durable-sha-globs dialect) -> why the files it matches are left out of the
           check. Omitted: no file is exempt. Every reason is non-empty: an exception is a declared entry with
           its reason, never a list in code
           ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)).
A check with settings of its own derives from this type and names its extra keys, so one key set is validated
in one place. Property names mirror the YAML keys (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
