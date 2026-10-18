# pwsh/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:baseConfig = [ordered]@{`, written with `#`.

```text
Fixture network plan — deliberately-distinct Greek env names (alpha/beta/gamma/delta) and neutral
subscription names (widget_core, a hub; gadget_edge, a spoke), NOT the shipped ones, so this logic test owns
its identity inputs and editing azure.yml can never change its outcome
([ADR-AUTO-TEST-ONECATEGORY](/docs/adr/automation/test-automation.md#rule-adr-auto-test-onecategory),
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
