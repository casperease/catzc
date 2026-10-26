# pwsh/Base.Drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1

The tests of `ConvertTo-DrsDomainDiagram`, a pure renderer.

## Fixtures

It is fed fixture edges and a fixture `DrsConfig` for the node roles, with `Get-Config` mocked. The fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
