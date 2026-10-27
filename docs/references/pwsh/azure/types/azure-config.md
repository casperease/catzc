# pwsh/Azure/types/AzureConfig.cs

The typed record of the Azure identities, `configs/azure.yml` ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)): the org, the
minimum Bicep CLI version, and the tenants, environments and subscriptions. Every named entity is a map keyed by name, so duplicate names
are structurally impossible. `Get-Config -Config azure` returns this record, because it is registered in
`Catzc.Base.Config/configs/configs.yml` as `Catzc.Azure.AzureConfig`.

## shape

The type mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
maps keep file order: a dictionary enumerates in insertion order when nothing is removed, and these are never mutated after construction.

## validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- The keys `org`, `tenants`, `subscriptions` and `environments` are required, `policy_enforcement` is optional, and no other key is allowed.
- `org` is 2-3 lowercase alphanumeric characters with a leading letter, the org name component
  ([ADR-AZ-NAMING-LOWERCASECOMPONENTS](../../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents)).
- `tenants`, `environments` and `subscriptions` are non-empty maps of well-formed `AzureTenantRecord`, `AzureEnvironmentRecord` and
  `AzureSubscriptionRecord` entries.
- Environment shortcodes are unique.
- A subscription's tenant is a defined tenant, and each of its environments is a defined environment.
- A subscription lists at most one `per_subscription` environment, its identity environment.
- No two subscriptions of one customer serve the same environment. That is what makes a `configuration/<customer>/` config resolve to
  exactly one subscription
  ([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)). The grouping uses
  the raw customer token, and the normalized grouping, key against shortcode, is a cross-asset fact.

## policy enforcement

`policy_enforcement` maps exactly the keys `production` and `nonproduction` to a mode, `Default` or `DoNotEnforce`
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). A key the
file omits takes its sensible default, declared once as `DefaultPolicyEnforcement`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)):
production enforces its policies and every other environment audits them without enforcing. An omitted map and a partial map both resolve to
a complete one, and an unknown key or mode is a violation. The `policy_enforcement` property is therefore always complete.

## staging

A staging environment is the slot of its target that is not yet active
([ADR-AZ-DATAMOD-STAGINGSLOT](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-stagingslot)). The `staging_for` target exists,
neither environment is `per_subscription`, and every subscription that serves the staging environment serves its target too.

## customer disjointness

A `configuration/<customer>/<env>[-<slot>].yml` config resolves to the customer's one subscription serving the environment, so no two
subscriptions of one customer, by raw token, may serve the same environment.

## what it leaves out

The type is hermetic. A subscription's customer reference into `customer.yml` is not resolved here. A shipped-asset integrity test enforces
it and `Get-AzureCustomer` does at runtime
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).
Completeness, every environment being served, and root-config uniqueness are discovery and integrity concerns, not load rules
([ADR-AZ-DATAMOD-JOINSINPOWERSHELL](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell)).

## entry lists

A private helper reads the entries of a required, non-empty top-level map as name and mapping pairs. A non-mapping entry passes null on, so
its record reports it.
