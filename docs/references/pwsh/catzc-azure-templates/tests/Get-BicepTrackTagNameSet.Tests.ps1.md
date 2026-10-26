# pwsh/Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1

The L0 tests of the tracking-tag name set.

## Setup once

These are read-only resolver tests. The boundary mocks and the config-cache reset run once, not per test: the mocked config is identical for
every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
