# pwsh/Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1

The tests of `Resolve-ToolExecutable`: the mapping from a `tools.yml` entry to the probe's plain inputs.

## Fixtures

`Get-Config` is mocked to return a typed `ToolsConfig`, the record the real call returns, so the function reads typed properties as it does
in production. `Find-Executable` is mocked whole, so the assertions bind to which inputs each platform and session actor hands it. Fixture
tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
