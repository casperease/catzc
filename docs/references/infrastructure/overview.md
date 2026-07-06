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

## Reference articles

- [modules](modules.md) — the shared bicep modules.
- [foundation](foundation.md) — the once-per-subscription baseline (Log Analytics + Key Vault).
