---
catzc:
  immutable:
    with_body_sha: e9bd40d4b74c
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-change-check-plan-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ChangeCheckPlan' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ChangeCheckPlan over fixture files, with the file-language registry mocked to fixture languages. Neutral fixture
names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
