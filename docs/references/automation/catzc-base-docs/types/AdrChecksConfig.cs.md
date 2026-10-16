---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrChecksConfig.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c2d0a9b81cc6
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#35
      - ADR-AUTO-TYPES#8
      - ADR-CONF-LOADING#4
      - ADR-PRIN-CONFIG#{1,3}
---

# automation/Catzc.Base.Docs/types/AdrChecksConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
adr-checks.yml — the settings of the ADR checks over the rule registries, and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). Every key is optional: an omitted key
behaves exactly like its default, so the file states only what deviates
([ADR-PRIN-CONFIG#3](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config3)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AdrChecksConfig), so Get-Config -Config adr-checks returns this typed
record ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)). Mirrors the YAML mapping
(snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
  engine_neutrality — AdrNeutralityCheck, read by Test-AdrEngineNeutrality
  citation_graph    — AdrCheck, read by Test-AdrRegistry
  dora_coverage     — AdrDoraCheck, read by Test-AdrRegistry
Each check's mode is one setting, never a branch per check in code
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)); its default is CheckMode's, Gate,
because every repository check is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
Constructing an instance validates the file, collecting every violation into one ArgumentException.
```
