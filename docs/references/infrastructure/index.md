---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/infrastructure/index.md
    folder: docs/references/infrastructure
    name: index
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/azure/
      - docs/references/infrastructure/discovery.md
      - docs/references/infrastructure/expedition.md
      - docs/references/infrastructure/foundation.md
      - docs/references/infrastructure/modules.md
      - docs/references/infrastructure/overview.md
---

# Infrastructure reference

One article per infrastructure unit — the templating-system overview, the shared bicep modules, and one per deployable template. Each
template article describes what the template deploys and how it is configured, not line-by-line bicep.

## How to read these articles

- **overview** and **modules** describe the system and its shared building blocks.
- each **template** article lists the Azure resources it deploys, the shared modules it uses, and its configuration — its `short_name`,
  environments and slots, and subscriptions.

Design rationale lives in the [Azure ADRs](../../adr/azure/).

## The articles

| Article                     | In one line                                                               |
| --------------------------- | ------------------------------------------------------------------------- |
| [overview](overview.md)     | The templating system — layout, discovery, build and deploy               |
| [modules](modules.md)       | The shared bicep modules referenced by templates                          |
| [foundation](foundation.md) | Once-per-subscription baseline: Log Analytics and Key Vault               |
| [discovery](discovery.md)   | CAF landing zone per subscription: hub or spoke network, policies, budget |
| [expedition](expedition.md) | Well-Architected workload: storage and SQL behind private endpoints       |
