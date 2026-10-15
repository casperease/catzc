---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Test-Tool.Tests.ps1.md
    kind: test-asset
    body_sha: "663a04b62e76"
---

# automation/Catzc.Tooling.Core/tests/Test-Tool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Hermetic: every collaborator mocked in module scope, so the assertion binds to the version-check LOGIC
(pin vs devbox lever vs pipeline), never to the shipped tools.yml or the installed toolchain.
```

## comment:2

Above `function New-TestToolConfig {`.

```text
Get-ToolConfig returns the typed record, so the mocks do too: every key the entry omits reads as its
default, exactly as in production.
```
