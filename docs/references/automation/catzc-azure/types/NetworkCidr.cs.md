---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/NetworkCidr.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "39dc46804c48"
---

# automation/Catzc.Azure/types/NetworkCidr.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
IPv4 CIDR arithmetic for the network plan (configs/network.yml,
[ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)): the one place a range is parsed, so the shape check,
the subnet-inside-its-vnet check, and the no-overlap check all read a range the same way. NetworkEnvironment,
NetworkSubscription and NetworkConfig call it while they validate.

A valid range is an aligned IPv4 CIDR: a dotted-quad address, a prefix length from 0 to 32, and no host bits set
(10.10.0.0/16, never 10.10.0.1/16), because Azure rejects an address prefix with host bits set.
```
