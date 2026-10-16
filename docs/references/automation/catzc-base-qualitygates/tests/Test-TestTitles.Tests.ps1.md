---
catzc:
  immutable:
    with_body_sha: c3c5978b9a64
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-TestTitles.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-test-titles-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-TestTitles' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-TestTitles over fixture test files in $TestDrive (the repository root is mocked). The fixture titles are built
from string pieces, so this file's own titles never carry the very token the gate bans. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
