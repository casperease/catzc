# pwsh/Azure/types/AzureConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Azure identity layer (configs/azure.yml, [ADR-AZ-DATAMOD](/docs/drs/azure/azure-data-model.md)): the org, the
minimum Bicep CLI version, and the tenants, environments and subscriptions — every named entity a map keyed by
name, so duplicate names are structurally impossible. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Azure.AzureConfig), so Get-Config -Config azure returns this typed record. Mirrors the YAML mapping
(snake_case keys, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); the
maps keep file order (a Dictionary enumerates in insertion order when nothing is removed, and these are never
mutated after construction).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - the top-level keys org, bicep_min_version, tenants, subscriptions, environments are required, policy_enforcement
    is optional, and no other key is allowed;
  - policy_enforcement maps exactly the keys production and nonproduction to a policy enforcement mode, Default or
    DoNotEnforce; a key it omits takes its sensible default, declared once here (DefaultPolicyEnforcement,
    [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), so an omitted map
    and a partial map both resolve to a full one
    ([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode));
  - org is 2-3 lowercase alphanumeric chars with a leading letter (the <org> name component,
    [ADR-AZ-NAMING-LOWERCASECOMPONENTS](/docs/drs/azure/azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents));
  - bicep_min_version is MAJOR.MINOR.PATCH (asserted by Assert-AzCliBicep before every az bicep build);
  - tenants, environments and subscriptions are non-empty maps of well-formed AzureTenantRecord /
    AzureEnvironmentRecord / AzureSubscriptionRecord entries;
  - environment shortcodes are unique;
  - a subscription's tenant is a defined tenant and each of its environments a defined environment;
  - a subscription lists at most one per_subscription environment (its identity env);
  - an environment's staging_for names a defined environment, neither of the two is per_subscription, and every
    subscription that serves the staging environment serves its target
    ([ADR-AZ-DATAMOD-STAGINGSLOT](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-stagingslot));
  - no two subscriptions of one customer serve the same environment — what makes a configuration/<customer>/
    config resolve to exactly one subscription ([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)).
    Grouping is by the RAW customer token; the normalized (key-vs-shortcode) grouping is a cross-asset fact.
Hermetic: a subscription's customer reference into customer.yml is NOT resolved here — it is enforced by a
shipped-asset integrity test and at runtime by Get-AzureCustomer
([ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)). Completeness ("every
environment is served") and root-config uniqueness are discovery/integrity concerns, not load rules
([ADR-AZ-DATAMOD-JOINSINPOWERSHELL](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-joinsinpowershell)).
```

## comment:2

Above `public static IReadOnlyDictionary<string, string> DefaultPolicyEnforcement {...`, written with `//`.

```text
The sensible default of policy_enforcement, declared once: production enforces its policies, every other
environment audits them without enforcing.
```

## comment:3

Above `public IReadOnlyDictionary<string, string> policy_enforcement { get; }`, written with `//`.

```text
The policy enforcement mode per environment class (production, nonproduction), always complete: the keys the
file omits take DefaultPolicyEnforcement.
```

## comment:4

Above `private static IReadOnlyDictionary<string, string>...`, written with `//`.

```text
The optional policy_enforcement map, completed from DefaultPolicyEnforcement: an omitted map is the default, and a
partial map keeps its own keys and takes the default for the rest. An unknown key or mode is a violation.
```

## comment:5

Above `private void CheckCustomerDisjointness(List<string> errors)`, written with `//`.

```text
A configuration/<customer>/<env>[-<slot>].yml config resolves to the customer's ONE subscription serving the
env, so no two subscriptions of one customer (by raw token) may serve the same environment.
```

## comment:6

Above `private static List<KeyValuePair<string, IDictionary>> Entries(object value,...`, written with `//`.

```text
The entries of a required, non-empty top-level map (name -> mapping); a non-mapping entry passes null so the
record reports it.
```

## comment:7

Above `private void CheckStaging(List<string> errors)`, written with `//`.

```text
A staging environment is its target's inactive slot: the target exists, neither is per-subscription, and every subscription that
serves the staging environment serves its target too.
```
