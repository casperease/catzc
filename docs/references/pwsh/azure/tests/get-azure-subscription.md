# pwsh/Azure/tests/Get-AzureSubscription.Tests.ps1

The logic tests of the subscription resolver, run against a fixture Azure config. They prove the id, the embedded tenant and the customer
come back for a named subscription.

## setup

The tests only read, so the config mock and the cache reset run once in `BeforeAll`, not per test. The mocked config is the same every test
and nothing mutates it, so the cache stays warm
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce),
[ADR-AUTO-TEST-SAFESEAMSWAPS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-safeseamswaps)).

## fixture root

The config-assets root is redirected to the test fixture, so the test owns its identity inputs and never depends on the shipped `azure.yml`.
