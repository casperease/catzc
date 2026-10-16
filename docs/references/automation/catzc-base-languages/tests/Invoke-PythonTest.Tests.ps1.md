---
catzc:
  immutable:
    with_body_sha: d845f13115b2
    repo_status: locked
    path: docs/references/automation/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md
    folder: docs/references/automation/catzc-base-languages/tests
    name: invoke-python-test-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`, written with `#`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture repository root in $TestDrive, a mocked tool probe (Resolve-ToolExecutable) that finds a managed uv
at a fixture path with a space in it, and a mocked uv (Invoke-Executable) whose pytest writes a canned JUnit
report from tests/assets to the path the command names.
```
