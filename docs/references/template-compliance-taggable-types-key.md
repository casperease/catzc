# The `taggable_types` key of `template-compliance.yml`: what it said, and the list that replaces it

## What the key said

`TemplateComplianceConfig` declared the resource types that take tags, so must carry the CAF tags, as an allow-list with this default:

```yaml
taggable_types:
  - Microsoft.Resources/resourceGroups
  - Microsoft.Storage/storageAccounts
  - Microsoft.Sql/servers
  - Microsoft.Sql/servers/databases
  - Microsoft.KeyVault/vaults
  - Microsoft.DataFactory/factories
  - Microsoft.OperationalInsights/workspaces
  - Microsoft.Network/virtualNetworks
  - Microsoft.Network/networkSecurityGroups
  - Microsoft.Network/routeTables
  - Microsoft.Network/privateEndpoints
  - Microsoft.Network/privateDnsZones
  - Microsoft.Network/networkInterfaces
  - Microsoft.Network/publicIPAddresses
  - Microsoft.Compute/virtualMachines
  - Microsoft.Network/networkWatchers
  - Microsoft.Network/networkWatchers/flowLogs
  - Microsoft.Insights/actionGroups
  - Microsoft.Insights/activityLogAlerts
  - Microsoft.Insights/scheduledQueryRules
```

`Test-BicepTemplateCompliance` checked the tags of a deployed resource only when its type was on the list; every other type passed
unchecked.

## Why it goes

An allow-list fails open: every new resource kind a template deploys has to be added by hand, or its tags are never checked. On 2026-10-27
it was missed twice in one night (the metric alerts, and the workbook, query pack and dashboard), each new kind passing the gate untagged or
unchecked ([PDR-POKAYOKE](../drs/principles/poka-yoke.md)).

## What replaces it

`untaggable_types`, the inverse: the kinds Azure gives no `tags` property (role and policy assignments, locks, diagnostic settings, nested
deployments, child resources such as subnets), default declared once on `TemplateComplianceConfig`. Every other deployed resource must carry
the CAF tags, so a new kind is checked from its first compile, and leaving it out of the check takes a deliberate entry. The Azure tagging
decision record absorbs this page when it is next restated.
