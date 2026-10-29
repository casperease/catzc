# pwsh/Azure.Templates/private/Get-BicepSlotDeploymentFacts.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Names where a Bicep slot deploys: location, subscription id and resource group.

### description

Reads azure.yml: the region of the slot's environment and the id of its subscription. For a template whose deployment target is
`ResourceGroup`, the resource group name is the one the slot declares under its `ResourceGroup:` key (Get-BicepSlotResourceGroup). A fact
azure.yml does not declare stays an empty string. Private helper of the deploy; not exported.

### parameter `Template`

The template descriptor Get-BicepTemplate returns: its name and deployment_target.

### parameter `Slot`

One of the descriptor's slots: its environment, slot, customer and subscription.

### outputs

`[hashtable]` With `Location`, `SubscriptionId` and `ResourceGroupName`.

### example 1

```powershell
Get-BicepSlotDeploymentFacts -Template $template -Slot $template.slots[0]
```

## comment:1

Above `$azure = Get-Config -Config azure`, written with `#`.

```text
Where Deploy-Bicep sends the slot, read from azure.yml and the naming standard, never from the az session: a fact it does not
declare stays '', and Get-ArmDeployedResource leaves what reads it unresolved.
```
