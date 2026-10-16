---
catzc:
  immutable:
    with_body_sha: dd3bde32dec4
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-logic-test-identity-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{1,3,35}
---

# automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-LogicTestIdentity' -Tag 'L1', 'integrity', 'source-only' {`, written with `#`.

```text
The integrity block binds the REAL shipped config (the live-identity set is derived from it), so it also names
live identities (e.g. 'apex') as fixture data; the integrity tag is both correct
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1))
and what exempts that block from the gate's own self-scan. source-only: it scans the repository's test files,
which give the same answer in both run modes. The logic block mocks the live set with neutral tokens
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and pins the gate's uniform
shape ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
