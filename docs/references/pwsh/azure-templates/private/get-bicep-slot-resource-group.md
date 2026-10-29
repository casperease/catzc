# pwsh/Azure.Templates/private/Get-BicepSlotResourceGroup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Answers the resource group a template declares for a coordinate, rendered for a runtime slot.

### description

Resolves the slot of the coordinate, reads the template configuration, and returns its top-level `ResourceGroup`. A bicepparam slot declares
the group in its sibling yml. A coordinate that matches a runtime slot gets the group rendered with the runtime slot segment. A coordinate
with no slot, or a configuration with no `ResourceGroup`, throws. Private helper of the Bicep commands; not exported.

### parameter `TemplateDescriptor`

The template descriptor Get-BicepTemplate returns, of a ResourceGroup-target template.

### parameter `Environment`

The environment of the coordinate.

### parameter `Slot`

The slot name. Empty selects the base slot.

### parameter `Customer`

The customer of the coordinate. Empty for the shared platform.

### outputs

`[string]` The resource group name.

### example 1

```powershell
Get-BicepSlotResourceGroup -TemplateDescriptor $template -Environment dev -Slot pr42
```

## comment:1

Above `$slotMatch = Resolve-BicepSlot -TemplateDescriptor $TemplateDescriptor...`, written with `#`.

```text
The slot declares its group
([ADR-AZ-DATAMOD-DECLAREDGROUPNAME](/docs/drs/azure/azure-data-model.md#rule-adr-az-datamod-declaredgroupname)): a
bicepparam slot in its sibling yml, a runtime slot through its base slot's yml.
```
