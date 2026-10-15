---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md
    kind: test-asset
    body_sha: a368bd60d7db
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:resolve = {`.

```text
Invoke the private function in the module's scope; the config reader is mocked at its boundary with neutral
widget/gadget addresses ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
