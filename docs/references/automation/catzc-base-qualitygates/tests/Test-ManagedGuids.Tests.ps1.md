---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "68a435df76a8"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ManagedGuids' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ManagedGuids over a mocked scan, registry, and 'repository' globset, so each test pins one rule. Neutral
fixture names and test-shaped guids ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
