# pwsh/Base.Execution/tests/types/CliRunner.Tests.ps1

The tests of `CliRunner`'s command parsing.

## First token

The first token is the name a command's time limit is looked up by (`Get-TimeoutSeconds -Executable`), so a wrong parse gives the command
another executable's limit. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
