# pwsh/Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1

The L2 integrity test of the shipped bicep templates' parameter contract
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)).

## What it proves

Every template is built with the real `az bicep build`, and every parameters file it renders must satisfy the parameter model of its
compiled `main.json`: types, `@allowed` values, bounds, required parameters, no undeclared parameter, and a Key Vault reference, never a
literal, for a secure parameter. `Get-BicepParameterViolations` does the checking, and its rules are proven on fixtures at L0
(`Get-BicepParameterViolations.Tests.ps1`). This file adds what only the real compiler can: the contract the shipped templates actually
declare.

## Shape

The test is generic over the template set
([ADR-AUTO-TEST-GENERICTEMPLATETESTS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-generictemplatetests)): the templates
are discovered with `Get-BicepTemplateNames`, one test each, and no test names a template or asserts a production value. It runs in the
`infrastructure` globset's test suite
([ADR-AUTO-TEST-TESTSUITE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-testsuite)), with the rest of the module's tests,
through `Test-Automation -Suite infrastructure`.

Each test self-skips when `az` is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)). The Bicep CLI is
verified once for the whole template set, not once per `Build-Bicep` call
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)), since each probe is a 2 s
`az bicep version` child process and every build still compiles with the real `az bicep build`.

## Isolation

The build output goes to this file's `$TestDrive` through the `Get-BicepTemplatesOutputRoot` seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)), so it
never shares `out/template/<name>` with another test file or a developer's build. The file is greedy, not serial: it drives real
`az bicep build` child processes but shares no mutable state
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).
