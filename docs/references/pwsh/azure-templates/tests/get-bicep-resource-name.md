# pwsh/Azure.Templates/tests/Get-BicepResourceName.Tests.ps1

<!-- cspell:ignore alweutstsmplst alweutstsmplacst -->

The L0 tests of the template-slot resource-name function.

## Setup once

These are read-only resolver tests. The boundary mocks and the config-cache reset are set up once, not per test. The mocked config is the
same fixture for every test and no test mutates it, so `Get-Config` keys its cache on the fixture path: the first call derives it cold,
about 80 ms, and the rest hit the warm cache. A per-test reset would force that cold re-derive on every test
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
