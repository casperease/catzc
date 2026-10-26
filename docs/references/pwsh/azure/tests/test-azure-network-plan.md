# pwsh/Azure/tests/Test-AzureNetworkPlan.Tests.ps1

The logic tests of the network plan check and its join, `Get-NetworkPlanViolations`.

## fixtures

The tests run over typed fixture configs with Greek environment names and neutral subscription names: `core_lower`, a hub, and
`widget_lower`, a spoke for the customer widget. They never use the shipped names, so editing `azure.yml` cannot change the outcome
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## plan builder

The `$script:plan` block builds the plan for a fixture: environment entries by name, plus the subscription block. With no block given it
uses the one that is in sync.
