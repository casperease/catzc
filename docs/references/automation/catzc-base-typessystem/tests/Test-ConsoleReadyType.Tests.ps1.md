---
catzc:
  immutable:
    with_body_sha: b65b88b012f4
    path: docs/references/automation/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md
    folder: docs/references/automation/catzc-base-typessystem/tests
    name: test-console-ready-type-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ConsoleReadyType' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ConsoleReadyType — whether a shipped type renders as a readable line in pwsh: it overrides ToString(), or it is
a kind never held as a value. Probed with BCL types and Add-Type probes. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
