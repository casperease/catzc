---
catzc:
  immutable:
    with_body_sha: ad307d553bd1
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ManualTestPlan.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-manual-test-plan-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ManualTestPlan' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ManualTestPlan over a fixture repository in $TestDrive: the repository root is mocked, and each test writes the
test files and the plan rows it needs. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
