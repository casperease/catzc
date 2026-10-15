---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
    kind: test-asset
    body_sha: "5dc814886a17"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AzureNetworkPlan' -Tag 'L0', 'logic' {`.

```text
Test-AzureNetworkPlan and its join (Get-NetworkPlanViolations) over typed fixture configs with Greek environment
names and neutral subscription names (core_lower, a hub; widget_lower, a spoke for customer widget), not the shipped
ones, so editing azure.yml can never change the logic outcome
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$script:plan = {`.

```text
The plan for the fixture: environment entries by name, plus the subscription block (the in-sync one when
none is given).
```
