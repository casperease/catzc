---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/NetworkEnvironment.cs.md
    folder: docs/references/automation/catzc-azure/types
    name: network-environment-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "77ff15dce0c0"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Azure/types/NetworkEnvironment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One environment's IP plan in configs/network.yml ([ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)): the
vnet address space and default subnet, keyed by the azure.yml environment name. Mirrors an `environments` entry
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
NetworkConfig builds one per entry and collects its violations with the file's.

Shape: the name is a lower-snake_case identifier; vnet_address_space and default_subnet are required, aligned IPv4
CIDRs (NetworkCidr); the default subnet lies inside the vnet address space; no other key.
```
