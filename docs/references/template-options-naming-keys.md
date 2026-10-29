# The naming keys of a template's `options.yml`: what they said, and where their meaning lives

A template's `options.yml` held a small rule language for the names of its slots, plus the facts, addresses and two classification bits the
build read. This page keeps what each key said until the Azure decision records absorb it: the declared-names restatement of
[naming-standard](../drs/azure/azure-naming-standard.md), [data-model](../drs/azure/azure-data-model.md) and
[customer-model](../drs/azure/azure-customer-model.md). `options.yml` keeps only `short_name`, `deployment_mode` and `deployment_target`.

## What the keys said

| Key                    | Files                                                             | What it said                                                                                                                                                                                            |
| ---------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `names`                | `infrastructure/templates/*/options.yml`, the test-asset fixtures | One entry per slot parameter that takes a name; the build rendered it through the namer and wrote it into every slot, so no slot spelled a name.                                                        |
| `names.<p>.type`       | as `names`                                                        | The resource-type ident of the name (`kv`, `rg`, `st`, …), a key of the type registry.                                                                                                                  |
| `names.<p>.role`       | as `names`                                                        | The role segment, 2–3 characters, leading letter.                                                                                                                                                       |
| `names.<p>.template`   | as `names`                                                        | Another template whose resource the name points at; the name rendered with that template's `short_name`, for its slot on this slot's subscription, and failed when it had none.                         |
| `names.<p>.owner_slot` | as `names`                                                        | With `template`, which slot of the other template owned the resource: `hub` followed the hub subscription the owner's slot parameters named, instead of this slot's subscription.                       |
| `names.<p>.roles`      | as `names`                                                        | An object parameter: one name per key, each key with its own role (`policyAssignmentNames`, alert-name maps).                                                                                           |
| `names.<p>.keys_from`  | as `names`                                                        | With `roles`, where the keys came from instead of every key of `roles`: `nsg_subnets`, the slot's subnets in `network.yml` that take a network security group.                                          |
| `names.<p>.each`       | as `names`                                                        | A list (or one object) parameter whose items each name another slot of the same template, keyed by `subscription` (the hub's `spokes` and `hub` items).                                                 |
| `names.<p>.names`      | as `names`                                                        | The names of an `each` entry's items, one per item field (`item_names` on the type).                                                                                                                    |
| `…names.<f>.from`      | as `names`                                                        | Which slot an item field rendered from: the item's slot (`item`) or this one (`self`).                                                                                                                  |
| `…names.<f>.role_from` | as `names`                                                        | An item field's role taken from the item, `customer_shortcode`, instead of a fixed `role`.                                                                                                              |
| `facts`                | `infrastructure/templates/*/options.yml`                          | Slot parameter to a field the build derives from `azure.yml` for the slot: `policy_enforcement`, `subscription_production`, `production`, `groups`, `module_resource_types` and the environment fields. |
| `addresses`            | `infrastructure/templates/*/options.yml`                          | Slot parameter to a config address every slot of the template took (`global.roles.roles`), so no slot wrote it.                                                                                         |
| `environment_kind`     | `infrastructure/templates/*/options.yml`, the fixtures            | `standard` or `subscription`: whether every slot's environment is an ordinary one or a `per_subscription` one (`nsub`/`psub`).                                                                          |
| `customer_deployment`  | the fixtures                                                      | Whether the template deploys for customers, defaulting to the `have_customers` variant; `true` allowed customer subfolders.                                                                             |

The names entries were read by `BicepNameEntry` and `BicepItemName` and rendered by `Resolve-BicepDerivedNames`; the resource group of a
resource-group-target slot was rendered by `Get-BicepResourceGroupName`.

## Why they go

A name rendered from rules appeared in no file, so a reader of a slot could not see what it deployed, and the rule keys restated what a
canonical name already carries: the template is its `short_name` segment, the slot and customer are its own segments, and the role is its
role segment. cats owns the grammar and the type list, so a consumer's `infrastructure/` holds only what cats cannot know
([DDR-THINPLAT-DELEGATENOTREIMPLEMENT](../drs/design/thin-platforms.md#rule-ddr-thinplat-delegatenotreimplement)).

## Where the meaning lives

- **`names` and its sub-keys:** every name is written in full in the slot yml and matched against the canonical form
  ([ADR-AZ-NAMING-DETERMINISTICNAMES](../drs/azure/azure-naming-standard.md#rule-adr-az-naming-deterministicnames),
  [ADR-AZ-DATAMOD-STATICRESOURCENAMES](../drs/azure/azure-data-model.md#rule-adr-az-datamod-staticresourcenames)). `template` and
  `owner_slot` become the owning template's `short_name` segment in the written name, checked by the gate against an existing slot of the
  owner; `roles` and `each` become plain nested yml; `keys_from: nsg_subnets` becomes the gate's coverage check of
  `networkSecurityGroupNames` against `network.yml`. The resource group is the slot's `ResourceGroup:` key
  ([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](../drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)).
- **`facts`:** a slot value `{ fact: <field> }`
  ([ADR-AZ-DATAMOD-VALUEBYFACT](../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyfact)).
- **`addresses`:** a slot value `{ address: … }` in each slot
  ([ADR-AZ-DATAMOD-VALUEBYADDRESS](../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress)).
- **`environment_kind`:** inferred from the slots' environment class, a template whose slots mix classes being a violation.
- **`customer_deployment`:** inferred from a customer folder under `configuration/`
  ([ADR-AZ-CUSTOMER-TEMPLATEFROMFOLDER](../drs/azure/azure-customer-model.md#rule-adr-az-customer-templatefromfolder)).
