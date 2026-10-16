---
catzc:
  immutable:
    with_body_sha: "8f72f4b324da"
    path: docs/references/automation/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests/types
    name: engine-set-check-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'EngineSetCheck' -Tag 'L0', 'logic' {`, written with `#`.

```text
EngineSetCheck maps the engine-set check's settings and matches its phrases against the engine names it is given —
widget, gadget and sprocket stand in for the model's engines
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — so no engine name or count is a
literal of the check ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```
