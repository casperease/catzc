---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: dd2622030779
    adrs:
      - ADR-AUTO-TEST#{3,6}
---

# automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-Prettier' -Tag 'L0', 'logic' {`, written with `#`.

```text
The prettier engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
never launch a real process in a unit test. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
