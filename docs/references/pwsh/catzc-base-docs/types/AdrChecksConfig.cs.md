# pwsh/Catzc.Base.Docs/types/AdrChecksConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
adr-checks.yml — the settings of the ADR checks over the rule registries, and the single declaration of their sensible defaults
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). Every key is optional: an omitted key
behaves exactly like its default, so the file states only what deviates
([PDR-CONFIG-DEFAULTDECLAREDONCE](/docs/adr/principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AdrChecksConfig), so Get-Config -Config adr-checks returns this typed
record ([ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)). Mirrors the YAML mapping
(snake_case, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
  engine_neutrality — AdrNeutralityCheck, read by Test-AdrEngineNeutrality
  citation_graph    — AdrCheck, read by Test-AdrRegistry
  dora_coverage     — AdrDoraCheck, read by Test-AdrRegistry
Each check's mode is one setting, never a branch per check in code
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/adr/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)); its default is CheckMode's, Gate,
because every repository check is a quality gate ([ADR-AUTO-TEST-QUALITYGATE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
Constructing an instance validates the file, collecting every violation into one ArgumentException.
```
