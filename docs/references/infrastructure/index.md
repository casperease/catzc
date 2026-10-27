# Infrastructure reference

One article per infrastructure unit — the templating-system overview, the shared bicep modules, and one per deployable template. Each
template article describes what the template deploys and how it is configured, not line-by-line bicep.

## How to read these articles

- **overview** and **modules** describe the system and its shared building blocks.
- each **template** article lists the Azure resources it deploys, the shared modules it uses, and its configuration — its `short_name`,
  environments and slots, and subscriptions.

Design rationale lives in the [Azure ADRs](../../drs/azure/).

## The articles

| Article                                           | In one line                                                                        |
| ------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [overview](overview.md)                           | The templating system — layout, discovery, build and deploy                        |
| [modules](modules.md)                             | The shared bicep modules referenced by templates                                   |
| [foundation](foundation.md)                       | Once-per-subscription baseline: Log Analytics and Key Vault                        |
| [discovery](discovery.md)                         | CAF landing zone per subscription: hub or spoke network, policies, budget          |
| [expedition](expedition.md)                       | Well-Architected workload: storage and SQL behind private endpoints                |
| [foundation cost model](foundation-cost-model.md) | What foundation's meters are and how its slot is estimated                         |
| [discovery cost model](discovery-cost-model.md)   | Discovery's meters, the firewall by tier, and the budget derived from the estimate |
| [expedition cost model](expedition-cost-model.md) | What expedition's meters are and how its slot is estimated                         |
| [threat-model](threat-model.md)                   | The templates and their pipeline by trust boundary and STRIDE category             |
