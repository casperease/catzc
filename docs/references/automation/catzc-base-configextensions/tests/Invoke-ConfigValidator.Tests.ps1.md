---
catzc:
  immutable:
    with_body_sha: "25b006c5662e"
    path: docs/references/automation/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md
    folder: docs/references/automation/catzc-base-configextensions/tests
    name: invoke-config-validator-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-ConfigValidator' -Tag 'L0', 'logic' {`, written with `#`.

```text
Invoke-ConfigValidator over in-memory fixture modules whose private validators it must find and run in their
own scope. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
