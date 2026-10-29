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

   This uses a key suffix instead of tracing through bicep. `main.bicep` uses names in `scope: resourceGroup(x)`, in `'${vnet}/${subnet}'`
   and in `displayName:`, so module-param tracing would be fragile. A wrong ident cannot slip through either, because the suffix rule makes
   every `*Name` value either match or fail.

5. **Exception:** a parameter keeps a non-canonical name only with `naming_exception: <reason>` next to its `value`
   (PDR-CONFIG-EXCEPTIONISCONFIGENTRY). The gate counts and lists them, and `ConvertTo-BicepParam` drops the key.
6. **The resource group is declared.** A `ResourceGroup`-target slot yml carries a top-level `ResourceGroup: <name>`. The key already
   exists: `Get-BicepDeploymentContext.ps1:88` rejects it for Subscription targets, and for ResourceGroup targets it will now read it in
   place of `Get-BicepResourceGroupName`. A Subscription-target template that creates its RG (discovery's `resourceGroupName`) declares it
   as an ordinary `*Name` param.
7. **Names owned by another template** are written in full. Their short_name segment points at the owning template, and the gate checks that
   the owner's slot for those coordinates exists. The rule keys `template:`, `owner_slot: hub`, `each`, `from` and `role_from` all go away,
   because the name itself now says what they used to encode.
8. **Lists and objects of names** are written as plain nested yml:
   - `spokes: [{ subscription: apex_nonprod, resourceGroupName: …, virtualNetworkName: …, peeringName: … }]`
   - `policyAssignmentNames: { allowedLocations: …-loc-pa, … }`

   The NSG-per-subnet rule (`keys_from: nsg_subnets`) becomes a gate **coverage** check: the keys of `networkSecurityGroupNames` must equal
   the subscription's subnets in `network.yml` minus `no_nsg_subnets`.

9. **Ephemeral slots.** A runtime slot has no file and is the one place cats still computes a name. `Build-Bicep -RuntimeSlots` matches each
   declared name of the base slot, then re-renders the ones whose short_name is this template's, with `slot = <runtime>`. Foreign names stay
   as written. One function, `Resolve-BicepRuntimeSlotNames`, replaces `Resolve-BicepDerivedNames`.
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

6. [ ] **Variants diagram** (blocked on task-user-runs-and-commits step 1: the render reads the committed tree, whose `variants.yml` still
       holds `ado_naming`, and the new validator refuses it): re-render the `.drawio.png` of
       `docs/explanation/repository/how-variants-yml-keys-are-read.md` (blocks `g-naming`/`g-test-naming`) and of
       `docs/explanation/azure/what-holds-the-azure-session-rule.md`, `what-holds-the-azure-coordinate-rules.md` and
       `how-a-bicep-deployment-context-is-built.md` (declared resource group), from each page's inline `yml drawio` block, and look at each
       (check: each render shows its new labels; `Test-Links` on the pages).
7. [ ] **Scaffold:** `Sync-BicepResourceNames [-Template] [-WhatIf]` (staged burst). For each slot it writes today's
       `Resolve-BicepDerivedNames` output into the slot yml (plus `ResourceGroup:`), and moves `facts:` and `addresses:` into slot values.
       It runs once over `infrastructure/templates/*` and the 9 test-asset templates, **before** the deletions. Afterwards it is a one-shot
       re-render for a new env or an order change, reusing the matcher plus the renderer. Setting `naming: classic` in a test overlay and
       then running Sync makes the gate pass again (check:
       `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Sync-BicepResourceNames.Tests.ps1`).
8. [ ] **Gate:** rewrite `Test-BicepResourceNames` with the which-values-are-names scope, the matched-not-parsed match, own-coordinate
       equality (env, customer and slot of the file; short_name of the template), owner-slot existence for foreign names, the NSG coverage
       check and the exception count. It reports facts: Names, Exceptions, Foreign. The tests seed 6 faults (wrong ident, a foreign
       short_name without an owner slot, wrong env, wrong customer, a missing NSG key, an RG typo in an Azure resource ID), each with its
       expected message (check: `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Test-BicepResourceNames.Tests.ps1`, then
       `Test-BicepResourceNames` on the tree).
9. [ ] **Runtime slots:** add `pwsh/Azure.Templates/private/Resolve-BicepRuntimeSlotNames.ps1`, which matches each declared name of the base
       slot and re-renders this template's own with `slot = <runtime>`, foreign names as written; `Build-Bicep -RuntimeSlots` calls it
       (check: `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Resolve-BicepRuntimeSlotNames.Tests.ps1`, a runtime slot producing the
       names the old resolver produced).
10. [ ] **Declared resource group:** `pwsh/Azure.Templates/Get-BicepDeploymentContext.ps1` reads the slot's `ResourceGroup:` key for a
        ResourceGroup target (check: `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1`).
11. [ ] **Options shrink:** `pwsh/Azure.Templates/private/Read-BicepTemplateOptions.ps1` allows only `short_name`, `deployment_mode` and
        `deployment_target` (check: `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Read-BicepTemplateOptions.Tests.ps1`).
12. [ ] **Template type:** `pwsh/Azure.Templates/types/BicepTemplate.cs` computes `environment_kind` and `customer_deployment`, and its
        `names`, `facts` and `addresses` go (check: `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Get-BicepTemplate.Tests.ps1` in a
        fresh process).
13. [ ] **Old resolver deleted:** `Resolve-BicepDerivedNames`, `pwsh/Azure.Templates/types/BicepNameEntry.cs` and
        `pwsh/Azure.Templates/types/BicepItemName.cs` deleted with their tests, after the runtime-slots step lands (check: a Grep for the
        three deleted names under `pwsh` and `docs` returns nothing).
14. [ ] **Resource-group namer deleted:** `Get-BicepResourceGroupName` and its test deleted, after the declared-resource-group step lands;
        `docs/explanation/azure/which-code-builds-azure-names.md` (l.16, 56, 117), `how-the-az-session-becomes-a-declared-identity.md`
        (l.109) and `how-an-azure-resource-gets-its-name.md` (l.99) then name the declared `ResourceGroup:` key (check: a Grep for the
        deleted function's name under `pwsh` and `docs` returns nothing).
15. [ ] **Contracts:** `contracts/catzc/0.1.0/pwsh.azure.templates/*` describe the shrunk options and the new commands (check:
        `Test-Contracts` on `contracts/catzc/0.1.0/pwsh.azure.templates`).
16. [ ] **Consumer options:** the 3 `infrastructure/templates/*/options.yml` and the test-asset fixtures hold only `short_name`,
        `deployment_mode` and `deployment_target` (check: a Grep for `names:|facts:|environment_kind|customer_deployment` under
        `infrastructure/templates` and the fixtures returns nothing).
17. [ ] **Consumer docs:** `infrastructure/README.md` and `docs/how-to/getting-started/automation/add-an-infrastructure-template.md`
        describe declared names and the two-key options (check: `Test-Links` and `Test-Spelling` on both).

19. [ ] **Proof:** rebuild every slot with `Build-Bicep -OutputFolder` and compare it with the captured baseline (check: every `.bicepparam`
        is byte-identical). The full Test-Automation run is the user's final run.
