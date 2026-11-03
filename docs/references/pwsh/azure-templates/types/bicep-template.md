# pwsh/Azure.Templates/types/BicepTemplate.cs

The typed record of a discovered deployable template: one folder of Bicep under the templates tree, plus the deployment axes (environments,
subscriptions and customers) it fans out across, materialised as `slots`. It is the definitional record a deploy is planned from. It mirrors
a template's config keys (snake_case), overlaid with `options.yml`, and is constructed from that merged dictionary.

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties
(`Contains`, the indexer, `Keys`, `ToHashtable`), and its constructor uses the base's `Req`, `OptStr` and `StrArr` extraction helpers.

## Properties

- **`environment_kind`** — `subscription` when every slot's environment is a `per_subscription` one in `azure.yml`, else `standard`; a
  template with no slot is `standard`. It is inferred from the slots and the `per_subscription_environments` list, never read from
  `options.yml`.
- **`customer_deployment`** — whether this is a customer template, whose configs deploy into customer subscriptions. It is inferred: true
  when any slot has a customer (a customer folder under `configuration/`, [ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)),
  and always present as a bool.

## Construction

The constructor validates the required keys, so a malformed template cannot produce an instance.
