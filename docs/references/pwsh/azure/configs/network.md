# pwsh/Azure/configs/network.yml

The global cross-cutting network configuration: the IP address plan, beside `azure.yml`. It is the single source of truth for vnet and
subnet ranges. A template that creates a vnet reads the ranges at build time, in its PrePost prepare hook or through a config address in its
parameter file, so the central plan is never duplicated into every template's per-slot config. `Get-Config -Config network` loads it and the
`NetworkConfig` type validates it.

## blocks

Two blocks, and no two networks in the file overlap ([ADR-AZ-NETWORK](../../../../drs/azure/azure-network-model.md)):

- `environments` is keyed by environment name, matching the standard environments of `azure.yml`, so each environment gets a non-overlapping
  address space.
- `subscriptions` is keyed by subscription name, matching the subscriptions of `azure.yml`: the hub-and-spoke network the subscriptions
  deploy.

## hub and spoke

A subscription without `customer` in `azure.yml` carries a `hub`: exactly `GatewaySubnet` and `AzureFirewallSubnet`, which are reserved and
hold nothing deployed, and `shared-services`. A subscription with a `customer` carries a `spoke`: `private-endpoints`, plus one workload
subnet per standard environment it serves, named for that environment. Hubs take 10.0 to 10.1, spokes take 10.100 upward, one /16 each.
Every subnet lies inside its vnet and no two subnets of a vnet overlap.
