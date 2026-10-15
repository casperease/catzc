---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md
    kind: comment-page
    body_sha: "676371d54e14"
    adrs:
      - ADR-AUTO-TEST#{4,19}
---

# automation/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```
