# pwsh/Azure/tests/Get-AzureCustomer.Tests.ps1

The logic tests of the customer resolver. They prove a key and a shortcode resolve to the same record, and that an unknown token throws.

## setup

The `customer` config is redirected to a fixture catalogue (acme with shortcode ac, globex with gx). The resolver only reads, so the mock
and the cache reset run once ([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
