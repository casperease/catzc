# pwsh/Catzc.Azure/configs/azure.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `org: zct`, written with `#`.

```text
(Pins an empty, match-anything schema. Without it the editor matches this file to the Azure
 Developer CLI `azure.yaml` schema by filename alone and wrongly demands a `name` key.)
```

## comment:2

Above `org: zct`, written with `#`.

```text
Global Azure identity for the templating system.

Placeholder GUIDs — replace with real tenant/subscription IDs per deployment target.
Loaded by Get-Config -Config azure; validated by the AzureConfig type.
```

## comment:3

Above `org: zct`, written with `#`.

```text
Vertical / organization shortcode — global, one per repo. The <org> component of every Azure
resource name (see [ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). Placeholder — set your org's shortcode.
(The resource-name component ORDER is NOT here — it is a durable tooling setting in code:
 Get-AzureNameOrder. Changing it requires re-editing every typed name in the configs.)
```

## comment:4

Above `bicep_min_version: "0.43.8"`, written with `#`.

```text
Minimum Bicep CLI version required to build/deploy templates. Asserted before every `az bicep build`
(Assert-AzCliBicep) so a too-old or missing Bicep CLI fails fast with `az bicep upgrade` / `az bicep
install`, rather than silently emitting no main.json. MAJOR.MINOR.PATCH.
```

## comment:5

Above `tenants:`, written with `#`.

```text
policy_enforcement — the enforcementMode of the policy assignments the templates make, per environment class:
Default (enforce) or DoNotEnforce (audit only). Optional; omitted keys take the default declared on
AzureConfig, { production: Default, nonproduction: DoNotEnforce }. A stricter repository sets
nonproduction: Default. Templates read it by config address (global.azure.policy_enforcement.<key>),
[ADR-AZ-DATAMOD#11](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11).
policy_enforcement: { production: Default, nonproduction: Default }
```

## comment:6

Above `environments:`, written with `#`.

```text
Customer DEFINITIONS live in configs/customer.yml (the catalogue), not here — see
[ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md). A subscription below binds a customer by naming it in its `customer`
field, by EITHER its key (apex) OR its 2-char shortcode (ap); WHICH customers are enabled for deployment
is the `have_customers` variant in variants.yml.
```

## comment:7

Above `environments:`, written with `#`.

```text
Environments. The map KEY is the readable env name (the deploy handle, the config-file name, and
the env-segment of relaxed resource names — see [ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)); it must be
unique. `shortcode` is a 2-letter code, unique, used
as the env-segment of the restricted (tight-budget) patterns only — `kv`/`storage`/`vm` — so a
readable name never costs a tight name a byte; its 2nd char lets same-first-letter envs coexist
(e.g. preprod `pp` vs prod `pr`). `region` is the Azure deployment location; `region_code`
is its 3-letter name component (`weu`).
```

## comment:8

Above `nsub:`, written with `#`.

```text
Per-subscription environments (per_subscription: true) — exactly one per subscription (the sub's
identity env), used by environment_kind: subscription templates (e.g. foundation). nsub = the
nonprod subscription, psub = the prod subscription. Standard envs (above) are many-per-subscription.
```

## comment:9

Above `subscriptions:`, written with `#`.

```text
Subscriptions. A template's configuration tree addresses subscriptions by convention
([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): a config at the configuration/ ROOT (`<env>[-<slot>].yml`) is a
shared-platform deployment — its env must be served by exactly ONE non-customer subscription, which is
the resolved target; a config under a `configuration/<customer>/` subfolder (the folder is always a
customer KEY from customer.yml) resolves to that customer's one subscription serving the env. The
subscription is always resolved, never spelled into a path — and at deploy time the target is the az
session's subscription (the service connection), verified against this declaration and the explicit
-SubscriptionIdAssertIs guard. A subscription MAY carry an optional `customer` (a reference into
customer.yml, by key or 2-char shortcode) — the single source of "is this a customer subscription?";
the customer renders into the resource names of anything deployed here (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). A subscription's `environments` may freely mix standard envs
(dev/test/preprod/prod) with AT MOST ONE per-subscription identity env (nsub xor psub) — the identity
env addresses once-per-subscription templates (environment_kind: subscription).
```

## comment:10

Above `shared_nonprod:`, written with `#`.

```text
The shared platform pair — the only non-customer subscriptions, so every root config's env resolves
to exactly one of them (nonprod serves dev/test/nsub; prod serves preprod/prod/psub).
```

## comment:11

Above `apex_nonprod:`, written with `#`.

```text
Customer subscriptions — carry a `customer` key; their configs live under the
configuration/<customer>/ subfolder. One pair per customer (nova/flux are nonprod-only for now).
```
