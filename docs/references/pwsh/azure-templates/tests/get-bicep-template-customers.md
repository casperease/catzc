# pwsh/Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1

The L0 tests of the template-customers function and of the customer completer the commands expose.

## Setup once

These are read-only resolver tests. In both blocks the boundary mocks and the config-cache reset run once, not per test: the mocked config
is identical for every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

## The completer

The naming and file-addressing paths take `-Customer`, since the deploy paths are session-determined. Each of them exposes the completer
over `Get-BicepTemplateCustomers`.
