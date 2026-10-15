---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md
    kind: test-asset
    body_sha: "3feea9fe8575"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `It 'reads the first token of <commandLine> as <expected>' -ForEach @(`.

```text
The name a command's time limit is looked up by (Get-TimeoutSeconds -Executable), so a wrong parse gives the
command another executable's limit. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
