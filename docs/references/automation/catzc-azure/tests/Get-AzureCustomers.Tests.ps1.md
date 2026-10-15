---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md
    kind: test-asset
    body_sha: "90ed4c83666c"
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---

# automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```
