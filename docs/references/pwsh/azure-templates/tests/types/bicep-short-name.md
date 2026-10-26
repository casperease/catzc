# pwsh/Azure.Templates/tests/types/BicepShortName.Tests.ps1

<!-- cspell:ignore deriv abcdef gadge gadgetry getry gadg -->

The L0 tests of the C# type that owns short name derivation and validation
([ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS](../../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-twotemplateidentifiers)).

## Loading and fixtures

The type is loaded by the `Import-CSharpTypes` pre-pass and referenced here by its full name. The template names are neutral fixtures
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
