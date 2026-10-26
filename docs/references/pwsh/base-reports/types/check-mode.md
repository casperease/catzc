# pwsh/Base.Reports/types/CheckMode.cs

How a repository check treats what it finds, set per check in its config (`drs-checks.yml` in `Catzc.Base.Docs`; `links.yml` and
`source-conventions.yml` in `Catzc.Base.QualityGates`), never per check in code
([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)).

## The modes

- **Gate:** every finding is an issue, so the run fails until the count is 0, like any quality gate
  ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
- **Report:** every finding is printed and counted, and the run never fails on it; a check starts here while its work list is drained, and
  moves to Gate once its count reaches 0.

## Default

Gate is the default, declared once here as the type's zero value: a check whose config omits `mode` is `default(CheckMode)`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
