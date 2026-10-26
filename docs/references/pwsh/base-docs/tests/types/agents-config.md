# pwsh/Base.Docs/tests/types/AgentsConfig.Tests.ps1

The tests of the compiled `AgentsConfig` type, called directly: the constructor stops a malformed `agents.yml` from ever producing an
instance. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
