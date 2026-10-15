---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md
    kind: test-asset
    body_sha: fa4a71259444
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---

# automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:2

Above `Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter {...`.

```text
Redirect the config-assets root to the test fixture so this logic test owns its identity
inputs and never depends on the shipped azure.yml.
```
