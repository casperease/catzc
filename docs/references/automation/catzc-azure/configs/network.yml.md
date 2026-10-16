---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/configs/network.yml.md
    folder: docs/references/automation/catzc-azure/configs
    name: network-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cdc1a6c15994
---

# automation/Catzc.Azure/configs/network.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `environments:`, written with `#`.

```text
Global cross-cutting network configuration — the IP address plan, side by side with azure.yml. The
single source of truth for vnet / subnet ranges. A template that creates a vnet reads the right
ranges at build time (its PrePost prepare hook, or a config address in its parameter file), so the
central plan is never duplicated into every template's per-slot config. Loaded via
Get-Config -Config network; validated by the NetworkConfig type.

Two blocks, and no two networks in the file overlap (see [ADR-AZ-NETWORK](/docs/adr/azure/azure-network-model.md)):

- `environments` is keyed by environment name (matching azure.yml's standard environments), so
  each environment gets a non-overlapping address space.
- `subscriptions` is keyed by subscription name (matching azure.yml's subscriptions): the
  hub-and-spoke network the subscriptions deploy. A subscription without `customer:` in
  azure.yml carries a `hub`: exactly GatewaySubnet and AzureFirewallSubnet (reserved — nothing is
  deployed into them) and shared-services. A subscription with `customer:` carries a `spoke`:
  private-endpoints, plus one workload subnet per standard environment it serves, named for that
  environment. Hubs take 10.0–10.1, spokes 10.100 upward, one /16 each; every subnet lies inside
  its vnet and no two subnets of a vnet overlap.
```
