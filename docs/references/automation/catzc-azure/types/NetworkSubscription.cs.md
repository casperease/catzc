---
catzc:
  immutable:
    with_body_sha: dedf00873437
    path: docs/references/automation/catzc-azure/types/NetworkSubscription.cs.md
    folder: docs/references/automation/catzc-azure/types
    name: network-subscription-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Azure/types/NetworkSubscription.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One subscription's network in configs/network.yml ([ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)): a hub
or a spoke VNet, keyed by the azure.yml subscription name. Mirrors a `subscriptions` entry (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). NetworkConfig builds one
per entry and collects its violations with the file's.

Shape: the name is a lower-snake_case identifier; `kind` is `hub` or `spoke`; `vnet_address_space` is an aligned
IPv4 CIDR (NetworkCidr); `subnets` is a non-empty map of subnet name -> aligned IPv4 CIDR, each inside the VNet and
no two overlapping; no other key. A hub carries exactly the hub subnets (GatewaySubnet and AzureFirewallSubnet,
reserved, and shared-services). A spoke carries private-endpoints plus workload subnets, each named for the
environment it serves (a lower-snake_case identifier). Which kind a subscription needs, and which environments it
serves, are azure.yml facts, so that join is the quality gate Test-AzureNetworkPlan's, not this type's.
```

## comment:2

Above `public static IReadOnlyList<string> HubSubnets => HubSubnetNames;`, written with `//`.

```text
The subnets a hub carries, exactly: the two reserved Azure subnets (nothing is deployed into them) and
shared-services.
```

## comment:3

Above `private static List<string> SubnetNames(IDictionary d)`, written with `//`.

```text
The subnet names as written, including those with an invalid range, so a subnet with a bad range is reported
once (as a bad range), not also as missing. Empty when subnets is missing or not a map.
```

## comment:4

Above `private static void CheckSpoke(string where, List<string> names, List<string>...`, written with `//`.

```text
A spoke carries private-endpoints; every other subnet is a workload subnet named for an environment. Skipped
when subnets is missing or empty (reported already).
```
