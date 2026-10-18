# pwsh/Catzc.Azure/types/NetworkConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The cross-cutting IP plan (configs/network.yml, [ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)) — the
single source of truth for vnet / subnet ranges: the per-environment ranges, keyed by azure.yml environment name,
and the per-subscription hub or spoke networks, keyed by azure.yml subscription name. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.NetworkConfig), so Get-Config -Config network returns this
typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - the top-level key 'environments' is required and is a non-empty map of well-formed NetworkEnvironment entries;
  - the top-level key 'subscriptions' is optional and, when present, a non-empty map of well-formed
    NetworkSubscription entries;
  - no other top-level key;
  - no two virtual networks overlap — every environment's and every subscription's vnet_address_space is disjoint from every
    other ([ADR-AZ-NETWORK#6](/docs/adr/azure/azure-network-model.md#rule-adr-az-network6)).
The type checks this file alone. The cross-asset sync with azure.yml
([ADR-AZ-NETWORK#2](/docs/adr/azure/azure-network-model.md#rule-adr-az-network2),
[ADR-AZ-NETWORK#5](/docs/adr/azure/azure-network-model.md#rule-adr-az-network5)) joins two configs, so it is the
quality gate Test-AzureNetworkPlan, not a constructor that reads another config.
```

## comment:2

Above `public IReadOnlyDictionary<string, NetworkEnvironment> environments { get; }`, written with `//`.

```text
The per-environment IP plans, keyed by environment name in file order (a Dictionary enumerates in insertion
order when nothing is removed, and this one is never mutated after construction).
```

## comment:3

Above `public IReadOnlyDictionary<string, NetworkSubscription> subscriptions { get; }`, written with `//`.

```text
The per-subscription hub and spoke networks, keyed by subscription name in file order. Empty when the file has
no 'subscriptions' key.
```

## comment:4

Above `private static void CheckVnetOverlap(Dictionary<string, NetworkEnvironment>...`, written with `//`.

```text
No two virtual networks of the plan share an address: environments and subscriptions alike. A range already
reported invalid (null) is skipped.
```
