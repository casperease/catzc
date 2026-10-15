---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md
    kind: test-asset
    body_sha: "9e07bc5499bf"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The mapping from a tools.yml entry to the probe's plain inputs: the tools config is a fixture dictionary
(Get-Config mocked) and Find-Executable is mocked whole, so the assertions bind to which inputs each platform
and session actor hands it. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
