---
catzc:
  immutable:
    with_body_sha: "8e91c2ada132"
    path: docs/references/automation/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-templates/tests
    name: resolve-bicep-parameter-addresses-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:resolve = {`, written with `#`.

```text
Invoke the private function in the module's scope; the config reader is mocked at its boundary with neutral
widget/gadget addresses ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
