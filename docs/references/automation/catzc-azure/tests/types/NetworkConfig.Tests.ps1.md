---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "9f27221a5509"
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:baseConfig = [ordered]@{`.

```text
Fixture network plan — deliberately-distinct Greek env names (alpha/beta/gamma/delta) and neutral
subscription names (widget_core, a hub; gadget_edge, a spoke), NOT the shipped ones, so this logic test owns
its identity inputs and editing azure.yml can never change its outcome
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1),
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
