---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md
    kind: test-asset
    body_sha: "271832314164"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-LanguageTestExecutable' -Tag 'L0', 'logic' {`.

```text
Get-LanguageTestExecutable with the test folder discovery and the tool probe mocked: the source session hands down a
language's tool only when it is found at the pin, and probes nothing for a language without test folders. Neutral
fixture paths ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
