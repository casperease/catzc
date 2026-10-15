---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/NetworkEnvironment.cs.md
    kind: comment-page
    body_sha: "6aca3e1870b0"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Azure/types/NetworkEnvironment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One environment's IP plan in configs/network.yml ([ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)): the
vnet address space and default subnet, keyed by the azure.yml environment name. Mirrors an `environments` entry
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
NetworkConfig builds one per entry and collects its violations with the file's.

Shape: the name is a lower-snake_case identifier; vnet_address_space and default_subnet are required, aligned IPv4
CIDRs (NetworkCidr); the default subnet lies inside the vnet address space; no other key.
```
