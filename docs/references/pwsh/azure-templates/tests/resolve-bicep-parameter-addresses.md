# pwsh/Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1

The L0 tests of the private parameter-address resolver.

## Invocation and fixtures

The tests invoke the private function in the module's scope. The config reader is mocked at its boundary with neutral widget and gadget
addresses ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
