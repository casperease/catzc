---
catzc:
  immutable:
    with_body_sha: ae2c9680b4d6
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-Gofmt.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: invoke-gofmt-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,6}
---

# automation/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-Gofmt' -Tag 'L0', 'logic' {`, written with `#`.

```text
The gofmt engine with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
the tool probe (Resolve-ToolExecutable) finding a managed go beside a fixture gofmt in $TestDrive, and gofmt itself
(Invoke-Executable). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
