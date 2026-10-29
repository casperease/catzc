---
plan:
  status: active
  value: high
  reviewed: 2026-10-29
  class: feature
  targets: [pwsh/Azure.Templates, pwsh/Base.Variants, infrastructure/templates, docs/drs/azure, contracts/catzc/0.1.0/pwsh.azure.templates]
---

# Azure declared names: full names in the slot yml, thin options, cats matches

## Why its value is high

cats is a thin platform (DDR-THINPLAT-DELEGATENOTREIMPLEMENT). A consumer's `infrastructure/` should hold only what cats cannot know. Today
it holds the opposite. Each `options.yml` carries a naming rule language: `names:` with
type/role/template/owner_slot/each/item_names/from/role_from/roles/keys_from, plus `facts:`, `addresses:`, `environment_kind` and
`customer_deployment`. `Resolve-BicepDerivedNames` then computes names that appear in no file, and the 20 slot files contain no name at all.

Target:

1. Every real name is spelled out in full in the slot yml.
2. `options.yml` holds only `short_name` and `deployment_target`.
3. cats owns the type list and the grammar, and checks every declared name against the canonical form.
4. The canonical form (segment order) is a variant the consumer can configure.

Management-group scope is out of scope here and gets its own plan.

## Decisions (each with its reason)

1. **The name describes itself.** A canonical name already carries env, slot, region, org, short_name, customer, role and the type ident, so
   the consumer declares nothing per name.
2. **Names are matched, not parsed.** In the `storage`/`vm` patterns the parts are joined without separators, and org, short_name, role and
   slot vary in length, so free parsing is ambiguous. Every part except role comes from a small, known set: envs (azure.yml), customers
   (customer.yml), short_names (all templates), slots (all slot files), the type idents and one org. The matcher renders candidates through
   the **one** renderer under the configured order, then takes the leftover as the role. The role must match `^[a-z][a-z0-9]{1,2}$`.
   - Exactly one match: OK, returning the components.
   - No match: a per-part diagnosis.
   - More than one match: an ambiguity error, which in practice is a short_name collision the integrity test already blocks.
3. **The role is the consumer's free choice.** Equality with the canonical form pins every other part, and the role is whatever the consumer
   wrote, provided it is valid. That is the only free text left in a name.
4. **Which values are names:**
   - every string leaf (at any depth: object values, list item fields) under a slot parameter whose key ends in `Name` or `Names`;
   - the slot's top-level `ResourceGroup` key;
   - the `resourceGroups/<x>` and resource-name segments inside ARM ids found anywhere in the slot. Today
     `discovery/configuration/nsub.yml:33` hard-codes `nsub-weu-zct-fnd-rg` and `ns-weu-zct-fnd-kv` in a key vault reference, and nothing
     checks them.

   Keys ending in a suffix listed under `not_names` in `pwsh/Azure.Templates/configs/resource-types.yml` (default on the type: `SkuName`,
   `SubnetName`) are not names: a SKU or a pinned subnet name is not a resource name (delegated decision, 2026-10-29, from the scaffold
   run's false matches on `storageSkuName`, `databaseSkuName`, `privateEndpointSubnetName`; PDR-CONFIG-DEFAULTDECLAREDONCE).

   This uses a key suffix instead of tracing through bicep. `main.bicep` uses names in `scope: resourceGroup(x)`, in `'${vnet}/${subnet}'`
   and in `displayName:`, so module-param tracing would be fragile. A wrong ident cannot slip through either, because the suffix rule makes
   every `*Name` value either match or fail.

5. **Exception:** a parameter keeps a non-canonical name only with `naming_exception: <reason>` next to its `value`
   (PDR-CONFIG-EXCEPTIONISCONFIGENTRY). The gate counts and lists them, and `ConvertTo-BicepParam` drops the key.
6. **The resource group is declared.** A `ResourceGroup`-target slot yml carries a top-level `ResourceGroup: <name>`. The key already
   exists: `Get-BicepDeploymentContext.ps1:88` rejects it for Subscription targets, and for ResourceGroup targets it will now read it in
   place of `Get-BicepResourceGroupName`. A Subscription-target template that creates its RG (discovery's `resourceGroupName`) declares it
   as an ordinary `*Name` param. A runtime slot takes its group from `Resolve-BicepRuntimeSlotNames`, the base slot's declared
   `ResourceGroup:` re-rendered with `slot = <runtime>`, never the base group itself. A ResourceGroup-target `.bicepparam` slot declares its
   group in a sibling `<slot>.yml` that holds only `ResourceGroup:` (delegated decisions, 2026-10-29: options stay two keys, and a deploy
   into the base group from an ephemeral slot is refused by construction).
7. **Names owned by another template** are written in full. Their short_name segment points at the owning template, and the gate checks that
   the owner's slot for those coordinates exists. The rule keys `template:`, `owner_slot: hub`, `each`, `from` and `role_from` all go away,
   because the name itself now says what they used to encode.
8. **Lists and objects of names** are written as plain nested yml:
   - `spokes: [{ subscription: apex_nonprod, resourceGroupName: …, virtualNetworkName: …, peeringName: … }]`
   - `policyAssignmentNames: { allowedLocations: …-loc-pa, … }`

   The NSG-per-subnet rule (`keys_from: nsg_subnets`) becomes a gate **coverage** check: the keys of `networkSecurityGroupNames` must equal
   the subscription's subnets in `network.yml` minus `no_nsg_subnets`.

9. **Ephemeral slots.** A runtime slot has no file and is the one place cats still computes a name. `Build-Bicep -RuntimeSlots` matches each
   declared name of the base slot, then re-renders the ones whose short_name, env, customer and slot all equal the base slot's own, with
   `slot = <runtime>`. Foreign names and names pointing at a sibling slot of the same template (a hub) stay as written (delegated decision,
   2026-10-29: the old resolver rendered such item names slotless, so this keeps them). One function, `Resolve-BicepRuntimeSlotNames`,
   replaces `Resolve-BicepDerivedNames`.
10. **The order variant** `ado_naming` becomes `naming`. It also orders the service-connection names, so it is the one naming order. The
    value is either a preset (`standard`, `classic`) or an explicit list of segments. It can be overlaid from `.catzc/`
    (ADR-AUTO-OVERLAY-CONFIGFRAGMENT; the variants file is not among SEALEDENGINECONFIGS). `Get/Test/Assert-AdoNaming` become
    `Get/Test/Assert-Naming`, and `VariantsConfig.cs` validates the list: every component exactly once, and `type` present.
11. **The type list moves to config.** `pwsh/Azure.Templates/configs/resource-types.yml` holds one line per ident with only what differs
    from the default on its C# type (`ResourceTypesConfig`). The defaults are pattern `long` and charset `[a-z0-9-]`
    (PDR-CONFIG-DEFAULTDECLAREDONCE). Examples: `kv: { pattern: kv }`, `rg: { limit: 90 }`,
    `vm: { pattern: vm, omit: [org, customer, role] }`. The 4 patterns sit in the same file. The descriptive key is the ident itself (`kv`);
    the readable name lives in the comment, as today, so the ident stays the one name.
12. **`environment_kind` is inferred.** A template's kind is its slots' env class (`per_subscription` in azure.yml). The new violation is a
    template whose slots mix classes, raised by `Get-BicepConfigClassViolations`. The descriptor property stays, now computed.
13. **`customer_deployment` is inferred.** It is true when the template has a customer folder under `configuration/`
    (ADR-AZ-CUSTOMER-KEYISSUBFOLDER). The have_customers check in `Get-BicepCustomerClassViolations` / `Get-BicepTemplates.ps1:54` now fires
    on the folder, not the key.
14. **`facts:` becomes a slot value form,** `{ fact: <field> }`, a sibling of `{ address: … }` (ADR-AZ-DATAMOD-VALUEBYADDRESS). The computed
    fields (`policy_enforcement`, `subscription_production`, `groups`, `module_resource_types`, env fields) cannot be plain addresses.
    `Resolve-BicepEnvironmentFacts` keeps its logic, keyed per slot value instead of per options entry. The source stays visible in the file
    that uses it.
15. **`addresses:` in options** is moved into each slot as `{ address: … }` (the form already exists there).

## Open steps

Each file is verified with its tests before the next (CLAUDE.md editing rule).

18. [ ] **Final run** (every other step landed; the rebuild proof read 35 of 37 byte-identical on 2026-10-29, the two discovery files
        differing only in the four intended peering renames): the plan closes on the user's one full run, task-user-runs-and-commits step 1
        (check: a fresh session dot-sources `importer.ps1` and `Test-Automation` reads green; then this plan is deleted).
