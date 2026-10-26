# pwsh/Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1

The L0 tests of `Write-ToolProbeReport`.

## Rendering

The report renders the records it is given as one plain table through `Write-Message -NoHeader`. The fixture tokens are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
