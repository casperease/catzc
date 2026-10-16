---
catzc:
  immutable:
    with_body_sha: "94f10a51b345"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-PythonCheckScope.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-python-check-scope-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-PythonCheckScope' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-PythonCheckScope with the test folders and the git index mocked: the Python checks read the test folders and every
tracked .py file outside the Python root. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
