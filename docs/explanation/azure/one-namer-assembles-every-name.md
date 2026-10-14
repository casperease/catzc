# docs/explanation/azure/one-namer-assembles-every-name.md

`One resolver gathers the components and one namer assembles every Azure name`

```text
Every Azure name comes out of one resolver and one namer; nothing else builds names.

1  azure.yml, customer.yml     environment identity, org, and the customer key and shortcode
2  template, options.yml       the template folder derives short_name; options.yml may override it
3  variants.yml                the ado_naming repo variant picks the component order
4  Get-BicepResourceName       the resolver: reads all three sources, adds type, slot, customer, role
5  registries                  three pure-data sets: 2 orders, 13 resource types, 4 patterns
6  Get-AzureResourceName       the namer: validates, renders in order, asserts the length limit
7  throw                       a bad component, unknown customer or over-limit name stops here
8  Get-BicepResourceGroupName  the one in-tree consumer: the resource-group name

Supports ADR-AZ-NAMING#1, #4, #5 and #8 (architecture lens).
```

Every Azure resource name in cats comes out of one place. A resolver gathers the name components from three config files, and a single
namer, reading three pure-data registries, assembles and checks the name. A bad component or an over-limit name throws; a name that passes
is the resource-group name the deploy uses. Because nothing else builds names, a rule changed in the namer reaches every name at once.

![One resolver gathers the components and one namer assembles every Azure name](../../.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md).

## Walkthrough

1. **azure.yml and customer.yml.** The `Catzc.Azure` configs. `azure.yml` supplies the environment's readable name and its 2-char shortcode,
   the environment's `region_code`, and the repo-wide `org`. `customer.yml` supplies the customer key and its 2-char shortcode, which
   `Get-AzureCustomer` resolves from either form.
2. **The template and its options.yml.** The template folder under `infrastructure/templates/<folder>/` and its optional `options.yml`. The
   folder name derives the `short_name` (its first 5 `[a-z0-9]` characters) through `BicepShortName`, and an explicit `short_name` in
   `options.yml` overrides it.
3. **variants.yml.** It carries the `ado_naming` repo variant, which `Get-AdoNaming` reads with `standard` as the default. The variant picks
   the component order for every name.
4. **Get-BicepResourceName.** The resolver in the templating layer reads all three sources side by side. The caller adds only what is
   genuinely per call: the resource type and the optional slot, customer and role. An unknown customer stops it here.
5. **The registries.** Three pure-data registries: `Get-AzureNameOrderSet` holds the two orders `standard` and `classic`,
   `Get-AzureResourceTypeSet` holds 13 resource types, each tied to one pattern, and `Get-AzureNamePatternSet` holds the four patterns
   `long`, `kv`, `storage` and `vm`. Adding an order or a type changes no assembler code.
6. **Get-AzureResourceName.** The namer validates every component, renders the name in the order the registry gives, and asserts the length
   limit. It is order-agnostic: the order is data it is handed.
7. **Throw.** A bad component, an unknown customer or an over-limit name throws. A name is never truncated to fit.
8. **Get-BicepResourceGroupName.** The one in-tree consumer, so only the `rg` type is generated in the tree today. It is the single source
   of the resource-group name for both the deploy target (`Get-BicepDeploymentContext`) and the tracking-tag scope
   (`Set-BicepTrackingTagSet`), so the two never drift. Other types call `Get-BicepResourceName` directly.

## Why it holds

- Every name is assembled deterministically from one canonical component set, with no random suffix or hash (ADR-AZ-NAMING#1).
- Each resource type ties to one pattern in the type registry, and the pattern fixes the separator, the length budget and the form of the
  environment and customer segments (ADR-AZ-NAMING#4).
- The component order is the `ado_naming` repo variant, not a per-name argument, so changing it re-spells every derived name
  (ADR-AZ-NAMING#5).
- The subscription only selects the deploy target. It is never a name component and never an input to the resolver; the customer that
  renders is derived from it by the caller (ADR-AZ-NAMING#8).

## Where the code and the ADR differ

- The ADR has four patterns, and so do the code and its tests, but the help text of `Get-AzureNamePatternSet` and `Get-AzureResourceTypeSet`
  still says three.
- The help text of `Get-AdoNaming` says resource names are typed into each slot config and that a build-time check flags a mismatch; no
  in-tree caller compares configured names, and the validation use that `Get-BicepResourceName` describes is not wired.

## See also

- [Azure resource naming standard](../../adr/azure/azure-naming-standard.md) — the decision this article explains.
- The other lenses on the same naming standard: [meta](names-are-pure-and-never-truncated.md),
  [implementation](lookup-form-check-render-in-order.md), [operations](names-are-derived-never-typed.md) and
  [governance](how-each-naming-rule-is-held.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
