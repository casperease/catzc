# pwsh/Azure/types/NetworkSubscription.cs

One subscription's network in `configs/network.yml` ([ADR-AZ-NETWORK](../../../../drs/azure/azure-network-model.md)): a hub or a spoke vnet,
keyed by the `azure.yml` subscription name. It mirrors a `subscriptions` entry with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`NetworkConfig` builds one per entry and collects its violations with the file's.

## shape

- The name is a lower-snake_case identifier.
- `kind` is `hub` or `spoke`.
- `vnet_address_space` is an aligned IPv4 CIDR (`NetworkCidr`).
- `subnets` is a non-empty map of subnet name to aligned IPv4 CIDR. Each subnet lies inside the vnet and no two overlap.
- No other key is allowed.

## hub

A hub carries exactly the hub subnets: `GatewaySubnet` and `AzureFirewallSubnet`, which are reserved, and nothing is deployed into them,
plus `shared-services`. The `HubSubnets` list holds them.

## spoke

A spoke carries `private-endpoints` plus workload subnets. Every other subnet is a workload subnet named for the environment it serves, so
its name is a lower-snake_case identifier. The check is skipped when `subnets` is missing or empty, because that is reported already.

## what the type leaves out

Which kind a subscription needs, and which environments it serves, are `azure.yml` facts. That join belongs to the quality gate
`Test-AzureNetworkPlan`, not to this type.

## subnet names

The subnet names are read as written, including those with an invalid range. A subnet with a bad range is then reported once, as a bad
range, and not also as missing. The list is empty when `subnets` is missing or not a map.
