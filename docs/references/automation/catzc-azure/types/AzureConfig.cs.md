---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/AzureConfig.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "164526347027"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-AZ-CUSTOMER#3
      - ADR-AZ-DATAMOD#{7,8,11}
      - ADR-AZ-NAMING#6
---

# automation/Catzc.Azure/types/AzureConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Azure identity layer (configs/azure.yml, [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): the org, the
minimum Bicep CLI version, and the tenants, environments and subscriptions — every named entity a map keyed by
name, so duplicate names are structurally impossible. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Azure.AzureConfig), so Get-Config -Config azure returns this typed record. Mirrors the YAML mapping
(snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); the
maps keep file order (a Dictionary enumerates in insertion order when nothing is removed, and these are never
mutated after construction).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - the top-level keys org, bicep_min_version, tenants, subscriptions, environments are required, policy_enforcement
    is optional, and no other key is allowed;
  - policy_enforcement maps exactly the keys production and nonproduction to a policy enforcement mode, Default or
    DoNotEnforce; a key it omits takes its sensible default, declared once here (DefaultPolicyEnforcement,
    [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), so an omitted map
    and a partial map both resolve to a full one
    ([ADR-AZ-DATAMOD#11](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11));
  - org is 2-3 lowercase alphanumeric chars with a leading letter (the <org> name component,
    [ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6));
  - bicep_min_version is MAJOR.MINOR.PATCH (asserted by Assert-AzCliBicep before every az bicep build);
  - tenants, environments and subscriptions are non-empty maps of well-formed AzureTenantRecord /
    AzureEnvironmentRecord / AzureSubscriptionRecord entries;
  - environment shortcodes are unique;
  - a subscription's tenant is a defined tenant and each of its environments a defined environment;
  - a subscription lists at most one per_subscription environment (its identity env);
  - no two subscriptions of one customer serve the same environment — what makes a configuration/<customer>/
    config resolve to exactly one subscription ([ADR-AZ-DATAMOD#8](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod8)).
    Grouping is by the RAW customer token; the normalized (key-vs-shortcode) grouping is a cross-asset fact.
Hermetic: a subscription's customer reference into customer.yml is NOT resolved here — it is enforced by a
shipped-asset integrity test and at runtime by Get-AzureCustomer
([ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)). Completeness ("every
environment is served") and root-config uniqueness are discovery/integrity concerns, not load rules
([ADR-AZ-DATAMOD#7](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod7)).
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
