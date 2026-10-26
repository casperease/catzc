# pwsh/Azure/configs/azure.yml

The global Azure identity for the templating system: the org, the minimum Bicep version, and the tenants, environments and subscriptions.
The GUIDs are placeholders, replaced with real tenant and subscription IDs per deployment target. `Get-Config -Config azure` loads it and
the `AzureConfig` type validates it.

## schema pin

The file starts with an empty, match-anything schema pin. Without it the editor matches the file to the Azure Developer CLI `azure.yaml`
schema by filename alone and wrongly demands a `name` key.

## org

`org` is the vertical or organization shortcode, global and one per repository. It is the org component of every Azure resource name
([ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md)). The value is a placeholder, set to the organization's shortcode. The
order of the name components is not in this file: it is a durable tooling setting in code, `Get-AzureNameOrderSet`, and changing it means
re-editing every typed name in the configs.

## bicep_min_version

The minimum Bicep CLI version required to build and deploy templates, as MAJOR.MINOR.PATCH. `Assert-AzCliBicep` checks it before every
`az bicep build`, so a too-old or missing Bicep CLI fails fast with `az bicep upgrade` or `az bicep install` instead of silently emitting no
`main.json`.

## policy_enforcement

`policy_enforcement` is the `enforcementMode` of the policy assignments the templates make, per environment class: `Default` enforces and
`DoNotEnforce` only audits. The key is optional, and omitted keys take the default declared on `AzureConfig`: production `Default`,
nonproduction `DoNotEnforce`. A stricter repository sets `nonproduction: Default`. Templates read it by config address,
`global.azure.policy_enforcement.<key>`
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)).

## environments

The map key is the readable environment name. It is the deploy handle, the config-file name and the environment segment of relaxed resource
names ([ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md)), and it is unique.

- `shortcode` is a unique 2-letter code. It is the environment segment of the restricted, tight-budget patterns only (`kv`, `storage`,
  `vm`), so a readable name never costs a tight name a byte. Its second character lets environments with the same first letter coexist, such
  as preprod `pp` and prod `pr`.
- `region` is the Azure deployment location, and `region_code` is its 3-letter name component, such as `weu`.
- `staging_for` marks an environment as another's staging slot, inactive until activated. Preprod stages prod
  ([ADR-AZ-DATAMOD-STAGINGSLOT](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-stagingslot)).

## per-subscription environments

An environment with `per_subscription: true` exists exactly once per subscription: the subscription's identity environment, used by
templates of `environment_kind: subscription`, such as the foundation. `nsub` belongs to the nonprod subscription and `psub` to the prod
subscription. The standard environments above are many-per-subscription.

## subscriptions

A template's configuration tree addresses subscriptions by convention ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)):

- A config at the `configuration/` root, `<env>[-<slot>].yml`, is a shared-platform deployment. Its environment must be served by exactly
  one non-customer subscription, which is the resolved target.
- A config under a `configuration/<customer>/` subfolder, where the folder is always a customer key from `customer.yml`, resolves to that
  customer's one subscription serving the environment.

The subscription is always resolved and never spelled into a path. At deploy time the target is the az session's subscription, the service
connection, verified against this declaration and the explicit `-SubscriptionIdAssertIs` guard.

A subscription may carry an optional `customer`, a reference into `customer.yml` by key or by 2-character shortcode. It is the single source
of "is this a customer subscription", and the customer renders into the resource names of anything deployed there. Customer definitions live
in `configs/customer.yml` ([ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)), and which customers are enabled for deployment
is the `have_customers` variant in `variants.yml`.

A subscription's `environments` may mix standard environments (dev, test, preprod, prod) freely with at most one per-subscription identity
environment, `nsub` xor `psub`.

## shared and customer subscriptions

`shared_nonprod` and `shared_prod` are the shared platform pair and the only non-customer subscriptions, so every root config's environment
resolves to exactly one of them: nonprod serves dev, test and `nsub`, and prod serves preprod, prod and `psub`. The customer subscriptions
carry a `customer` key, and their configs live under the `configuration/<customer>/` subfolder. There is one pair per customer, and some
customers are nonprod-only.
