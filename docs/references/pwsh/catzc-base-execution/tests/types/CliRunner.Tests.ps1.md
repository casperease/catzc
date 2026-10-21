# pwsh/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'reads the first token of <commandLine> as <expected>' -ForEach @(`, written with `#`.

```text
The name a command's time limit is looked up by (Get-TimeoutSeconds -Executable), so a wrong parse gives the
command another executable's limit. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
