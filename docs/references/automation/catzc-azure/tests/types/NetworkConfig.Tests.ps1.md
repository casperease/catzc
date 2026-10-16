---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6730189523e6"
    adrs:
      - ADR-AUTO-TEST#{1,3}
---

# automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:baseConfig = [ordered]@{`, written with `#`.

```text
Fixture network plan — deliberately-distinct Greek env names (alpha/beta/gamma/delta) and neutral
subscription names (widget_core, a hub; gadget_edge, a spoke), NOT the shipped ones, so this logic test owns
its identity inputs and editing azure.yml can never change its outcome
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1),
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
