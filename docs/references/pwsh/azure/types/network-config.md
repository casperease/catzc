# pwsh/Azure/types/NetworkConfig.cs

The typed record of the cross-cutting IP plan, `configs/network.yml` ([ADR-AZ-NETWORK](../../../../drs/azure/azure-network-model.md)): the
single source of truth for vnet and subnet ranges. It holds the per-environment ranges, keyed by `azure.yml` environment name, and the
per-subscription hub or spoke networks, keyed by `azure.yml` subscription name. `Get-Config -Config network` returns this record, because it
is registered in `Catzc.Base.Config/configs/configs.yml` as `Catzc.Azure.NetworkConfig`. It mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- The top-level key `environments` is required and is a non-empty map of well-formed `NetworkEnvironment` entries.
- The top-level key `subscriptions` is optional and, when present, a non-empty map of well-formed `NetworkSubscription` entries.
- No other top-level key is allowed.
- No two virtual networks overlap: every environment's and every subscription's `vnet_address_space` is disjoint from every other
  ([ADR-AZ-NETWORK-NOOVERLAP](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-nooverlap)). A range already reported invalid
  is skipped.

## scope of the type

The type checks this file alone. The sync with `azure.yml`
([ADR-AZ-NETWORK-KEYEDBYENVIRONMENT](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-keyedbyenvironment),
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription)) joins two
configs, so it is the quality gate `Test-AzureNetworkPlan`, not a constructor that reads another config.

## properties

`environments` holds the per-environment IP plans, keyed by environment name in file order. `subscriptions` holds the hub and spoke
networks, keyed by subscription name in file order, and is empty when the file has no `subscriptions` key. A dictionary enumerates in
insertion order when nothing is removed, and these are never mutated after construction.
