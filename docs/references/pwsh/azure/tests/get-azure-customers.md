# pwsh/Azure/tests/Get-AzureCustomers.Tests.ps1

The logic tests of the customer key list, run against a mocked customer config.

## setup

The tests only read, so the config mock and the cache reset run once in `BeforeAll`, not per test. The mocked config is the same every test
and nothing mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).
