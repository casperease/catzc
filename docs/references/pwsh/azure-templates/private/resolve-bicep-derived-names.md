# pwsh/Azure.Templates/private/Resolve-BicepDerivedNames.ps1

The function that derives the resource names a slot's parameters take from a template's names entries.

## help

### synopsis

Derives the names a template's names entries give a slot, by parameter.

### description

For each entry of the template descriptor's names, in order, it renders the name or names the namer gives, through Get-BicepResourceName,
and returns them as an ordered dictionary keyed by parameter.

A plain entry renders one name of its type and role, for the template and the slot's environment, slot and customer. An entry that names
another template renders for that template's slot on this slot's subscription, and throws when it has none; with `owner_slot` set to `hub`
it follows the hub subscription that the owning slot's parameters name. An entry with roles renders an object with one name per key, each
with its key's role; `keys_from` set to `nsg_subnets` keys it by the slot's subnets that take an NSG, and a key without a role throws.

An `each` entry renders one item per entry of the slot's own parameter of that name, a single object staying one object and a list staying a
list. Each item names another slot of the template by its subscription and throws when none serves it; a field renders from that slot
(`item`) or this one (`self`), and an item that already writes a derived field throws. An `each` entry with no parameter in the slot is
skipped.

### parameter `TemplateDescriptor`

The template whose names entries are rendered.

### parameter `Slot`

The slot the names are derived for.

### parameter `SlotParameters`

The slot's own parameters, which hold an each entry's items; empty when the template has no each entry.

### outputs

`[System.Collections.Specialized.OrderedDictionary]`

### example 1

```powershell
& (Get-Module Azure.Templates) { Resolve-BicepDerivedNames -TemplateDescriptor $template -Slot $slot }
```
