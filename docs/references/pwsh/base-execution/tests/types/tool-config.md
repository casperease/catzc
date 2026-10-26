# pwsh/Base.Execution/tests/types/ToolConfig.Tests.ps1

The tests of `ToolConfig`, the typed record over one `tools.yml` entry.

## What they pin

The record rejects keys it does not map, since a dropped key would be invisible to every caller, and the tests pin the optional flags the
provisioning loops branch on. Fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
