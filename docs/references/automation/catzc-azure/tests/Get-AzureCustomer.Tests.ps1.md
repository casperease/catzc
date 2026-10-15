---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md
    kind: test-asset
    body_sha: "377e9f687d19"
    adrs:
      - ADR-AUTO-TEST#19
---

# automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Redirect the 'customer' config to the fixture catalogue (acme/ac, globex/gx). Read-only resolver, so
the mock + cache reset run once
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```
