---
catzc:
  immutable:
    with_body_sha: a6dfd9c0052f
    path: docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
    folder: docs/references/automation/catzc-base-globs/tests
    name: test-glob-set-independence-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,35}
      - ADR-FLOW-CD-GLOBS#10
---

# automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GlobSetIndependence' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GlobSetIndependence is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over per-layer independence
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)). The registry, the derived
module sets and the tracked-file universe are mocked with neutral fixtures (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the report goes to $TestDrive.
```
