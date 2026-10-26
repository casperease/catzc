# pwsh/Azure/tests/types/NetworkConfig.Tests.ps1

The logic tests of the `NetworkConfig` type: what the constructor accepts and each violation it reports.

## fixtures

The base config uses Greek environment names (alpha, beta, gamma, delta) and neutral subscription names: `widget_core`, a hub, and
`gadget_edge`, a spoke. They are not the shipped names, so the test owns its identity inputs and editing `azure.yml` cannot change its
outcome ([ADR-AUTO-TEST-ONECATEGORY](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory),
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
