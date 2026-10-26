# pwsh/Base.Docs/tests/types/AgentEntry.Tests.ps1

The tests of the compiled `AgentEntry` type, called directly: the constructor stops a malformed `agents.yml` entry from ever producing an
instance. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
