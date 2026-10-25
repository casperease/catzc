# pwsh/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AzureNetworkPlan'`, written with `#`.

```text
Test-AzureNetworkPlan and its join (Get-NetworkPlanViolations) over typed fixture configs with Greek environment
names and neutral subscription names (core_lower, a hub; widget_lower, a spoke for customer widget), not the shipped
ones, so editing azure.yml can never change the logic outcome
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `$script:plan = {`, written with `#`.

```text
The plan for the fixture: environment entries by name, plus the subscription block (the in-sync one when
none is given).
```
