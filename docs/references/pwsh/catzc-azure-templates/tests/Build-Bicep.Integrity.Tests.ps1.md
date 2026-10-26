# pwsh/Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1

The integrity tests of the shipped bicep templates under `infrastructure/templates/`: that they are named so discovery finds them, and that
their contents meet easily verified structural constraints, without building them.

## Scope

Compiling a production template is the pipeline's build step, not an integrity test. End-to-end build coverage lives in the fixture-based L2
tests (`Build-Bicep.*.Tests.ps1`), which mock `Get-BicepTemplatesRoot` to `tests/assets/templates/` and build a `sample-*` asset.

This file binds to the real `infrastructure/templates/` and configs, and does not mock the `Get-BicepTemplatesRoot` or
`Resolve-ConfigEntry` seams, because binding to the real assets is the whole point of an integrity test
([ADR-AUTO-TEST-ONECATEGORY](../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory)). It is generic: it discovers the
set and asserts invariants that hold for every shipped template, binding to no template name and no production-derived value
([ADR-AUTO-TEST-GENERICTEMPLATETESTS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)).

## Shape

One read-only scan in `BeforeAll`, and each `It` block asserts one facet of it
([ADR-AUTO-TEST-INTEGRITYREADSFILES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-integrityreadsfiles)). Both
validators run, and neither builds:

- `Get-BicepTemplates` is discovery. It checks that folders and files are named right, the options schema, and the identity references.
  Discovery is itself a check that throws on a violation, so the outcome is captured and each facet below reports cleanly instead of one
  failure aborting the block.
- `Assert-BicepTemplate` is the consolidated validator, run without `-Build`: `main.bicep` present, the `options.yml` schema and short name,
  environment class, identity references and parameter alignment, every problem in one message.

`Get-BicepTemplates` returns a comma-wrapped array, so the result is assigned (an `@()` wrap nests it one level) and iterated with
`foreach`.
