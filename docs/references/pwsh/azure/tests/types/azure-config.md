# pwsh/Azure/tests/types/AzureConfig.Tests.ps1

The logic tests of the `AzureConfig` type, plus the integrity checks that read the shipped `azure.yml`. They prove what the constructor
accepts and each violation it reports.

## fixtures

The base config uses deliberately distinct tokens: org `tst`, tenant `fixtenant`, Greek environments and `core_*` subscriptions. The type
validates a passed dictionary on its own, so the fixture needs no shipped config, and editing the shipped `azure.yml` cannot change the
outcome ([ADR-AUTO-TEST-ONECATEGORY](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory),
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## normalized customer uniqueness

At load time the type groups customer subscriptions by their raw customer token, because it must not read `customer.yml`
([ADR-AZ-CUSTOMER](../../../../../drs/azure/azure-customer-model.md)). The integrity test of the shipped assets is the normalized
counterpart. With shortcodes resolved to canonical keys, every shipped customer still serves each environment exactly once, and so does the
non-customer set. Every configuration file resolution rests on that uniqueness
([ADR-AZ-DATAMOD](../../../../../drs/azure/azure-data-model.md)).

## customer field is not validated

A subscription's `customer` field is a cross-asset reference into `customer.yml`, by key or shortcode. The type carries it raw and does not
check it at load time. The integrity test above checks it, and `Get-AzureCustomer` checks it at runtime. A fixture Azure config can
therefore name a customer without a `customer.yml`.
