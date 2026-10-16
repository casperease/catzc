---
catzc:
  derived:
    path: docs/references/infrastructure/overview.md
    kind: reference
    language: markdown
    filekind: md
    track: docs
    body_sha: "6b593dbc30b7"
    links:
      - docs/adr/azure/
      - docs/adr/azure/landing-zones.md
      - docs/references/automation/catzc-azure-templates.md
      - docs/references/infrastructure/discovery.md
      - docs/references/infrastructure/expedition.md
      - docs/references/infrastructure/foundation.md
      - docs/references/infrastructure/modules.md
---

# infrastructure

Bicep for the templating system, in two folders:

- **`templates/<name>/`** — deployable templates, one folder each. Discovered by `Get-BicepTemplates` and built/deployed by `Build-Bicep` /
  `Deploy-Bicep`. Each carries `main.bicep` and one `configuration/[<customer>/]<env>[-<slot>].yml` per resource group, plus an optional
  `options.yml`. A template's `short_name` (its Azure id segment) is derived from the folder name unless `options.yml` overrides it. A
  config at the configuration root is the shared platform's; a subfolder is always a customer key, and its configs are that customer's
  deployments. The subscription is resolved from the coordinate — at deploy time it is the az session's, guarded by
  `-SubscriptionIdAssertIs`.
- **`modules/`** — reusable bicep modules shared across templates. Referenced from a template's `main.bicep` via a relative `module`
  declaration (`../../modules/<x>.bicep`) and inlined by `az bicep build`. Not discovered as templates.

The system is documented in [the Catzc.Azure.Templates reference](../automation/catzc-azure-templates.md); the design rationale lives in
[`docs/adr/azure/`](../../adr/azure/).

## The templates and their order

Three templates tell one story, and each deploys after the one before, because it reads what that one created:

1. **`foundation`** — the once-per-subscription baseline: the Log Analytics workspace and the Key Vault every later template uses.
2. **`discovery`** — the CAF landing zone of the subscription, at subscription scope: a hub network in a shared subscription, a spoke in a
   customer subscription, the policies, and the budget. A new spoke needs its hub deployed first and again after it, so the peering and the
   DNS zone links find both networks ([landing-zones](../../adr/azure/landing-zones.md)).
3. **`expedition`** — the Well-Architected workload, one per configuration slot: storage and a SQL database behind private endpoints in the
   landing zone's network.

The customer CD pipelines deploy them in this order, and `ci-infrastructure` validates and builds all three.

## Reference articles

- [modules](modules.md) — the shared bicep modules.
- [foundation](foundation.md) — the once-per-subscription baseline (Log Analytics + Key Vault).
- [discovery](discovery.md) — the CAF landing zone per subscription: hub or spoke network, policies, budget.
- [expedition](expedition.md) — the Well-Architected workload: storage and SQL behind private endpoints.
