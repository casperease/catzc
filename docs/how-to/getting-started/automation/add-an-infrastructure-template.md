# Add an infrastructure template

<!-- cspell:ignore deweuzctsurvecorst deweuzctsurvestast deweuzctsurvemaadf -->

A template is a deployable Bicep unit discovered from the filesystem. Create a folder under `infrastructure/templates/<name>/`, give it a
`main.bicep` and one config file per resource group, and `Get-BicepTemplates` finds it automatically. Its `short_name` (the Azure id
segment) is **derived from the folder name** — no `options.yml` needed to get started; add one only to override `short_name` or set
deployment options. The data model behind this is in [data-model](../../../drs/azure/azure-data-model.md); the naming rules are in
[naming-standard](../../../drs/azure/azure-naming-standard.md).

## The layout

```text
infrastructure/templates/<name>/
  main.bicep                                       required — the root Bicep file
  options.yml                                      optional — override short_name (else derived), deployment mode and target
  PrePost.psm1                                     optional — build/deploy hooks
  configuration/
    <env>.yml                                      a shared-platform config (base slot) — one file = one resource group
    <env>-<slot>.yml                               a special slot (blue/green, ordinal, …)
    <customer>/                                    a customer KEY from customer.yml
      <env>[-<slot>].yml                           that customer's configs, same filename rules
```

Two rules make this work:

- **The coordinate is the deployment target.** A config at the configuration ROOT is the shared platform's — its env must be served by
  exactly one non-customer subscription, which is the resolved target. A subfolder is always a **customer key**, and its configs resolve to
  that customer's one subscription serving the env. Every file resolves to exactly ONE subscription id (asserted at discovery).
- **The filename is the identity.** `dev.yml` is the base (index-0) slot for environment `dev`; `dev-001.yml` is the `001` slot. **One
  config file ⟷ one (customer?, env, slot) ⟷ one Azure resource group.** Listing the `configuration/` tree is the resource-group inventory.

## Worked example

A minimal `survey` template — two storage accounts and a Data Factory, a shared-platform `dev` deployment. It needs **no `options.yml`**:
the `short_name` (the 2–5 char, globally-unique Azure identifier segment) is derived from the folder name — `survey` → `surve` (the folder
name is a human label; the derived `short_name` carries the Azure id). Add an `options.yml` with a `short_name:` override only when the
derived value is unsuitable (e.g. `discovery` → `disco`, but you want `disc`).

**`infrastructure/templates/survey/main.bicep`** — parameters are filled from the per-slot config; reusable bits come from
`infrastructure/modules/`:

```bicep
param location string = resourceGroup().location

param storageCoreName string
param storageStagingName string
param storageSku string = 'Standard_LRS'
param adfName string

module storageCore '../../modules/storage-account.bicep' = {
  name: 'survey-storage'
  params: { location: location, name: storageCoreName, skuName: storageSku }
}

module adfMain '../../modules/data-factory.bicep' = {
  name: 'survey-adf'
  params: { location: location, name: adfName }
}
```

**`infrastructure/templates/survey/configuration/dev.yml`** — the parameter values for this one resource group. Every real name is written
**in full** here (the build passes it through unchanged,
[ADR-AZ-DATAMOD-STATICRESOURCENAMES](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-staticresourcenames)), and the top-level
`ResourceGroup:` key names the group the slot deploys into
([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)):

```yaml
# survey, shared dev.
ResourceGroup: dev-weu-zct-surve-rg
ParametersFile:
  parameters:
    storageCoreName:
      value: deweuzctsurvecorst
    storageStagingName:
      value: deweuzctsurvestast
    adfName:
      value: deweuzctsurvemaadf
```

A canonical name carries the environment, region, organisation, `short_name`, role and type, so nothing beside the name is declared. The
gate matches it against the canonical form under the configured order
([ADR-AZ-NAMING-DETERMINISTICNAMES](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames)); the role is the one
part you choose. A `.bicepparam` slot declares its group in a sibling `<slot>.yml` that holds only `ResourceGroup:`.

## Names, facts and addresses

- A parameter whose key ends in `Name` or `Names` holds names, at any depth; lists and objects of names are plain nested yml.
- A value that is not a name comes from a config with `{ address: … }`
  ([ADR-AZ-DATAMOD-VALUEBYADDRESS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)) or from a computed field with
  `{ fact: <field> }` ([ADR-AZ-DATAMOD-VALUEBYFACT](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyfact)).
- A name owned by another template is written in full with that template's `short_name`; the gate checks that the owner has a slot at those
  coordinates.
- A name that must stay off the canonical form carries `naming_exception: <reason>` beside its `value`
  ([ADR-AZ-NAMING-EXCEPTIONENTRY](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-exceptionentry)); the gate lists every
  exception.

Scaffold the names for a new environment, or after a change of the `naming` order
([ADR-AZ-NAMING-ORDERISVARIANT](../../../drs/azure/azure-naming-standard.md#rule-adr-az-naming-orderisvariant)), with
`Sync-BicepResourceNames`, then check them with `Test-BicepResourceNames`.

## options.yml

| Key                 | Default               | Meaning                                                                           |
| ------------------- | --------------------- | --------------------------------------------------------------------------------- |
| `short_name`        | _derived from folder_ | 2–5 lowercase-alnum, unique across templates: the Azure id segment. Override only |
| `deployment_mode`   | _optional_            | `Incremental` / `Complete` / …                                                    |
| `deployment_target` | _optional_            | `ResourceGroup` / `Subscription`                                                  |

No other key is allowed. The environment class of a template is read from its slots (a template's slots all share one class), and a template
is a customer deployment when it has a customer folder under `configuration/`.

## PrePost hooks

`Optional: PrePost hooks`

If the template needs build- or deploy-time logic, copy the starter `pwsh/Azure.Templates/assets/PrePost.psm1` to
`infrastructure/templates/<name>/PrePost.psm1`, keep the hook(s) you need, delete the rest. The three opt-in hooks are:

- `Invoke-BicepPrepareParameterSet` — build-time. Merge global config into the per-slot parameter set before the parameter file is rendered
  (e.g. inject a Key Vault reference, or pull subnet ranges from [`network.yml`](../../../drs/azure/azure-network-model.md)).
- `Invoke-BicepPreDeploy` — runs before `az deployment ... create`. State-changing prep; **must honour `-DryRun`**.
- `Invoke-BicepPostDeploy` — runs after a successful deploy. Fixups and verification.

A template with no `PrePost.psm1`, or one that doesn't export a given hook, simply skips that step — there is no default. See
[prepost-extension-modules](../../../drs/automation/pwsh/prepost-extension-modules.md).

## Where the global config lives

Templates resolve identity from two shared assets in `pwsh/Azure/configs/`:

- `azure.yml` — tenants, environments, and subscriptions (the env names and shortcodes, the region codes, the `org` segment, each
  subscription's `customer`). Read via `Get-Config -Config azure`. Customer definitions live in `customer.yml` — the keys are the
  configuration subfolder names.
- `network.yml` — the per-environment IP plan, keyed by environment name. Read via `Get-Config -Config network`.

To deploy to a new subscription or environment, add it to `azure.yml` first, then create the matching
`configuration/[<customer>/]<env>.yml`.

## Build and deploy

```powershell
. ./importer.ps1

Get-BicepTemplates | Select-Object name                 # confirm discovery finds your template
Build-Bicep  -Template survey -Environments dev         # render parameter files + compile main.bicep to out/
Deploy-Bicep -Template survey -Environment dev -DryRun  # preview; drop -DryRun to deploy
```

`Build-Bicep` runs the prepare hook and renders one `parameters.[<customer>.]<config>.json` per slot under `out/`. `Deploy-Bicep` deploys
into the **az session's subscription** (what `Connect-AzCli` / `az account set` — or, in a pipeline, the service connection — points at),
runs the pre-deploy hook, calls `az deployment ... create`, sets tracking tags, and runs the post-deploy hook. In a pipeline you pin the
target with `-SubscriptionIdAssertIs <guid>` (mandatory there); on a devbox the guard is optional.

## Verify

`Test-Automation` includes generic integrity tests that build **every** shipped template and check each references only defined
environments/subscriptions and matches every declared name against the canonical form — so a misnamed config folder, an undefined
environment or a mistyped name fails the tests. Run it after adding a template:

```powershell
Test-Automation -Modules Catzc.Azure.Templates -Level 2
```
