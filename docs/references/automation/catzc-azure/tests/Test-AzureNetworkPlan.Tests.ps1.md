---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "828f1cd57b2e"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AzureNetworkPlan' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-AzureNetworkPlan and its join (Get-NetworkPlanViolations) over typed fixture configs with Greek environment
names and neutral subscription names (core_lower, a hub; widget_lower, a spoke for customer widget), not the shipped
ones, so editing azure.yml can never change the logic outcome
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$script:plan = {`, written with `#`.

```text
The plan for the fixture: environment entries by name, plus the subscription block (the in-sync one when
none is given).
```
