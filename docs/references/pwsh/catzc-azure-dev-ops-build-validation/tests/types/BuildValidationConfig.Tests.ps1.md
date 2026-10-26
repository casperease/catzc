# pwsh/Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1

The L0 tests of the `build-validation.yml` type, which collects every violation and then throws, plus the shipped-config integrity check.

## Shape at load, ties in the integrity check

The type checks shape only. The cross-config reference is enforced elsewhere, never at config load: every shipped entry must tie to a
declared globset and resolve a pipeline, which the integrity check asserts and the commands enforce at run time
([ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](../../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)).

## Fixtures

The shape fixtures use the neutral names widget and gadget. The type checks shape only, so a logic fixture never borrows a real
deployable-unit name
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
