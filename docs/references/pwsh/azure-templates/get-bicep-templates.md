# pwsh/Azure.Templates/Get-BicepTemplates.ps1

<!-- cspell:ignore etlco -->

The function that discovers all bicep templates under the repository's `infrastructure/templates` folder and returns their descriptors:
options, short name, slots and configs, with the cross-layer checks run at discovery.

## help

### synopsis

Discovers all bicep templates under $(Get-RepositoryRoot)/infrastructure/templates.

### description

Scans `infrastructure/templates/` at depth 1 for template folders (reusable bicep modules live in the sibling `infrastructure/modules/` and
are NOT discovered here). Each folder must contain a `main.bicep` and a `configuration/` subfolder. A config lives at the configuration ROOT
— `configuration/<env>[-<slot>].yml`, a shared-platform deployment — or under a customer subfolder,
`configuration/<customer>/<env>[-<slot>].yml`, where the folder is always a customer KEY from customer.yml. One config file ⟷ one resource
group ([ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)). The filename resolves (Resolve-BicepConfigName) to its environment +
optional slot: `dev.yml` (base slot of env `dev`), `dev-001.yml` (slot `001`). The SUBSCRIPTION is resolved per config
(Get-BicepConfigSubscriptionCandidates): a root config's env must be served by exactly one non-customer subscription; a customer config's
env by exactly one of that customer's subscriptions. Validated at discovery: the subfolder is a defined customer key, and every config
resolves to exactly one subscription id.

Returns one ordered dictionary per template with these keys:

```text
name                  — folder name (the template identifier)
folder                — absolute path to the template folder
main                  — path to main.bicep
bicep_files           — all *.bicep files in the template folder
configuration_folder  — path to the configuration/ subfolder
configuration_files   — *.yml files at the configuration root and in configuration/<customer>/
environments          — distinct env names across the slots (excluding 'default')
subscriptions         — distinct resolved subscription names across the slots
customers             — distinct customer names across the slots (the config subfolders)
slots                 — one per config file: { name (=config), environment, slot, subscription, customer }
                        (slot/customer empty for a base / shared-platform slot)
short_name            — the Azure id segment (2-5 alnum, globally unique). DERIVED from the folder name
                        ([Catzc.Azure.Templates.BicepShortName]::Resolve) unless options.yml overrides it
output_folder         — where Build-Bicep writes main.json + parameters.<subscription>.<slot>.json
deployment_mode       — 'Incremental' unless overridden by options.yml
deployment_target     — 'ResourceGroup' unless overridden by options.yml
environment_kind      — INFERRED: 'subscription' when every slot's env is a per_subscription env in azure.yml, else 'standard'
                        (see [ADR-AZ-DATAMOD](/docs/drs/azure/azure-data-model.md))
customer_deployment   — INFERRED: true when a slot sits in a customer folder under configuration/
prepost_module        — path to PrePost.psm1 if present (key omitted otherwise)
resources             — extra files in resources/ if present (key omitted otherwise)
```

Returns an empty array if no `infrastructure/templates/` folder exists at the repo root.

A template's `short_name` is DERIVED from its folder name by default (the first 5 `[a-z0-9]` characters, hyphens dropped via
`[Catzc.Azure.Templates.BicepShortName]::Resolve`. A template MAY override it (and/or declare `deployment_mode` / `deployment_target`) in an
OPTIONAL `options.yml` beside `main.bicep`; Read-BicepTemplateOptions validates it (strict schema) and the values overlay the defaults here.
Templates with no options.yml take the derived short_name and the mode/target defaults.

### example 1

```powershell
Get-BicepTemplates | Format-Table name, deployment_target, environments
```

## Caching

Filesystem-derived information is cached for the session, lazily on first use, keyed on the discovery root and the output root
([ADR-AUTO-CACHE](../../../drs/automation/caching.md)). The on-disk file set is fixed at importer time (a static checkout in a pipeline; on
a devbox the importer is re-run after editing files), so re-running the importer is the only invalidation.

Keying on the roots lets a test redirect discovery to a fixture tree (mock `Get-BicepTemplatesRoot`) or the build output to a folder of its
own (mock `Get-BicepTemplatesOutputRoot`) without colliding with the real cache entry. Callers treat the result as read-only, since the same
object is returned on every call. The lazy cache entry is read with a strict-safe probe
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## The walk

The template folders are enumerated with `Get-ChildPath`, the bounded folder walker. It returns the folders sorted ordinally, so the output
is deterministic, and it carries none of `Get-ChildItem`'s per-call provider overhead, which discovery would otherwise pay dozens of times.

## Template options

- **Environment class.** The environment kind (standard or subscription) is inferred from the class of the slots' environments, by their
  `per_subscription` flag in `azure.yml` ([ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)). Slots that mix the two classes are a
  discovery violation, so the template splits in two. The slot is a per-config dimension, not a template bit, so a template may mix slotted
  and non-slotted configs.
- **Customer class.** Whether this is a customer template is inferred from the configuration tree: a slot in a customer folder makes it one
  ([ADR-AZ-CUSTOMER](../../../drs/azure/azure-customer-model.md)). A customer folder is allowed only when the `have_customers` repo variant
  (`Test-HaveCustomers`) enables customers and that customer.
- **Short name.** `short_name` is the Azure id segment every resource name is built from. It is derived from the folder name by default, and
  an `options.yml` `short_name` overrides it. `BicepShortName` owns the derivation and the format validation, and a malformed override, or a
  folder that cannot yield a valid short name without one, throws here and names the template
  ([ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-twotemplateidentifiers)).
- **Other overrides.** The remaining deployment overrides are overlaid; `short_name` is already applied, so it is excluded from the overlay.

## Configs and slots

A config lives at the configuration root (`<env>[-<slot>].yml`, the shared platform) or under a `configuration/<customer>/` subfolder, where
the folder is a customer key. The subscription is resolved per config, and both checks, that the subfolder is a defined customer key and
that the coordinate resolves to exactly one subscription, run at discovery through the shared `Get-BicepSubscriptionConfigViolations`.

Every config file is gathered with its customer (the subfolder, or empty for a root config): root files first, then the customer subfolders,
both sorted, so the output stays deterministic.

Each config file is one slot, one resource group. The file name `<env>[-<slot>]` resolves to its environment and slot through
`Resolve-BicepConfigName`, with `default.yml` a reserved skip. The subscription resolves from the customer and environment coordinate, so
one config file is one (customer, env, slot) coordinate, one subscription and one resource group.

There is one config per coordinate, never a yml and a bicepparam of one name
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)).
