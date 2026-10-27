# pwsh/Azure.Templates/Test-BicepResourceNames.ps1

The gate that keeps resource names out of the template configuration: a name a template declares is derived from the namer at build time, so
a slot that writes one by hand is an issue.

## help

### synopsis

Lists every template slot that writes a name its template's options.yml derives, and every declared name that does not derive for a slot.

### description

Reads the names section of each template's options.yml: each entry maps a slot parameter to the namer's resource type, an optional role,
and, for another template's resource, that template and optionally `owner_slot: hub`. For every slot it reports a declared parameter the
slot's yml writes, and resolves every declared name for the slot (Resolve-BicepDerivedNames, the same step Build-Bicep runs before the
template's hook), reporting one that does not derive. Build-Bicep refuses such a slot as well; the gate finds it without a build.

The keys of a names entry, each a closed set where it names a choice:

- `type`: the namer's resource type key (Get-AzureResourceTypeSet), checked when options.yml is read.
- `role`: the 2-3 character role segment of the name.
- `template`: another template that owns the named resource; its slot on this slot's subscription renders the name.
- `owner_slot: hub`: with `template`, the hub that slot peers to renders the name instead (the private DNS zones live in the hub).
- `roles`: makes the parameter an object with one derived name per key, each key with its own role (discovery's policy assignments).
- `keys_from: nsg_subnets`: with `roles`, the keys are the slot's subnets that carry a network security group, every subnet but the ones
  network.yml's `no_nsg_subnets` lists.
- `each: subscription` with `names`: the parameter is an array of items, or one object, each naming another slot of this template by its
  subscription. The slot writes the items' subscriptions, and each name under `names` is derived per item. An item name takes `type`, `role`
  or `role_from: customer_shortcode` (the customer shortcode of the item's slot), and `from: item` (the default: the item's slot renders it) or
  `from: self` (the slot holding the list renders it).

### parameter `Template`

The templates to check. Defaults to every shipped template.

### parameter `OutputFolder`

Where the gate report is written. Defaults to the shared report folder.

### parameter `PassThru`

Return the gate result instead of throwing on issues.

### example 1

```powershell
Test-BicepResourceNames -PassThru
```
