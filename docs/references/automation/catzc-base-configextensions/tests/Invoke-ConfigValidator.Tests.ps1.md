---
catzc:
  derived:
    path: docs/references/automation/catzc-base-configextensions/tests/Invoke-ConfigValidator.Tests.ps1.md
    kind: test-asset
    body_sha: c17245394422
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-ConfigValidator' -Tag 'L0', 'logic' {`.

```text
Invoke-ConfigValidator over in-memory fixture modules whose private validators it must find and run in their
own scope. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
