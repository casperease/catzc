# pwsh/Base.Drs/types/DrsChecksConfig.cs

The typed record of `drs-checks.yml`, the settings of the ADR checks over the rule registries, and the single declaration of their sensible
defaults ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Registration

Every key is optional: an omitted key behaves exactly like its default, so the file states only what deviates
([PDR-CONFIG-DEFAULTDECLAREDONCE](../../../../drs/principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)). The type is
registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config drs-checks` returns it
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)). It
mirrors the YAML mapping, so its properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

- **`engine_neutrality`** — a `DrsNeutralityCheck`, read by `Test-DrsEngineNeutrality`.
- **`citation_graph`** — a `DrsCheck`, read by `Test-DrsRegistry`.
- **`dora_coverage`** — a `DrsDoraCheck`, read by `Test-DrsRegistry`.
- **`code_language`** — a `DrsCodeLanguageCheck`, the segment grammar of ADR codes.

## Modes

Each check's mode is one setting, never a branch per check in code
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)). Its
default is `CheckMode`'s, `Gate`, because every repository check is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`.
