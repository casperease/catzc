# pwsh/Base.Drs/types/DrsChecksConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
drs-checks.yml — the settings of the ADR checks over the rule registries, and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Every key is optional: an omitted key
behaves exactly like its default, so the file states only what deviates
([PDR-CONFIG-DEFAULTDECLAREDONCE](/docs/drs/principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Drs.DrsChecksConfig), so Get-Config -Config drs-checks returns this typed
record ([ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)). Mirrors the YAML mapping
(snake_case, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
  engine_neutrality — DrsNeutralityCheck, read by Test-DrsEngineNeutrality
  citation_graph    — DrsCheck, read by Test-DrsRegistry
  dora_coverage     — DrsDoraCheck, read by Test-DrsRegistry
Each check's mode is one setting, never a branch per check in code
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)); its default is CheckMode's, Gate,
because every repository check is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
Constructing an instance validates the file, collecting every violation into one ArgumentException.
```
