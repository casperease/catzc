---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md
    kind: comment-page
    body_sha: "5b9ab973559f"
    adrs:
      - ADR-AUTO-TEST#19
      - ADR-AUTO-TEST#4
---

# automation/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```

## comment:2

Above `Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter {...`, written with `#`.

```text
Redirect the config-assets root to the test fixture so this logic test owns its identity
inputs and never depends on the shipped azure.yml.
```
